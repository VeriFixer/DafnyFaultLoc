using Microsoft.Dafny;
using Microsoft.Dafny.Plugins;
using System.Collections.Generic;
using System.Reflection;

namespace DafnyTestCoverage;

public class CoveragePlugin : PluginConfiguration {

    private int _maxIterations = 1000;

    public override void ParseArguments(string[] args) {
        foreach (var arg in args) {
            if (arg.StartsWith("max_iter=")) {
                var valueStr = arg.Substring("max_iter=".Length);
                if (int.TryParse(valueStr, out int parsedLimit)) {
                    _maxIterations = parsedLimit;
                }
            }
        }
    }

    public override Rewriter[] GetRewriters(ErrorReporter reporter) {
        return new Rewriter[] { new CoverageInstrumenter(reporter, _maxIterations) };
    }
}

public class CoverageInstrumenter : Rewriter {
    private readonly int _maxIterations;

    public CoverageInstrumenter(ErrorReporter reporter, int maxIterations) : base(reporter) {
        _maxIterations = maxIterations;
    }

    public override void PreResolve(ModuleDefinition module) {
        var builder = new CoverageTraceBuilder(_maxIterations);
        foreach (var decl in module.TopLevelDecls) {
            if (decl is TopLevelDeclWithMembers classDecl) {
                foreach (var member in classDecl.Members) {
                    if (member is Method method && method.Body != null) {
                        builder.InstrumentMethod(method);
                    }
                }
            }
        }
    }
}

public sealed class CoverageTraceBuilder {
    private readonly int _maxIterations;
    private List<Statement> _newBlockBody = new List<Statement>();

    public CoverageTraceBuilder(int maxIterations){
        _maxIterations = maxIterations;
    }

    public void InstrumentMethod(Method method) {
        if (method == null || method.Body == null) return;

        if (method.Attributes != null && Attributes.Contains(method.Attributes, "test")) {
            var token = (Token)method.StartToken;
            var prefix = new StringLiteralExpr(token, "--- RUNNING TEST: " + method.Name + " ---\\n", false);
            var printStmt = new PrintStmt(token, new List<Expression> { prefix });

            if (method.Body.Body != null) {
                method.Body.Body.Insert(0, printStmt);
            }
            return; 
        }
        HandleBlock(method.Body);
    }

    private void HandleBlock(BlockStmt blockStmt) {
        if (blockStmt == null || blockStmt.Body == null) return;

        var prevNewBlock = _newBlockBody;
        _newBlockBody = new List<Statement>(); 

        foreach (var stmt in blockStmt.Body) {
            if (stmt is PrintStmt) {
                _newBlockBody.Add(stmt);
                continue;
            }
            
            if (stmt is IfStmt ifStmt) {
                if (ifStmt.Els != null && !(ifStmt.Els is BlockStmt)) {
                    var elsStartToken = (Token)ifStmt.Els.StartToken;
                    var wrapperBlock = new BlockStmt(elsStartToken, new List<Statement> { ifStmt.Els });
                    
                    var elsField = typeof(IfStmt).GetField("Els");
                    if (elsField != null) {
                        elsField.SetValue(ifStmt, wrapperBlock);
                    }
                }
            }

            if (stmt.StartToken != null) {
                var printStmt = CreateCoveragePrint((Token)stmt.StartToken);
                _newBlockBody.Add(printStmt);
            }

            if (stmt is WhileStmt whileStmt) {
                InjectLoopVariable(whileStmt);
            }
            
            _newBlockBody.Add(stmt);
            
            HandleStatement(stmt); 

            if (stmt is WhileStmt whileStmtAfter) {
                InjectLoopIncrementAndExpect(whileStmtAfter);
            }
        }

        blockStmt.Body.Clear();
        blockStmt.Body.AddRange(_newBlockBody);
        _newBlockBody = prevNewBlock;
    }
    
    private void HandleStatement(Statement stmt) {
        if (stmt is IfStmt ifStmt) {
            if (ifStmt.Thn != null) {
                HandleBlock(ifStmt.Thn);
            }
            if (ifStmt.Els != null) {
                if (ifStmt.Els is BlockStmt elsBlock) {
                    int blockStartLine = elsBlock.StartToken != null ? ((Token)elsBlock.StartToken).line : -1;
                    int firstStmtLine = -1;
                    
                    if (elsBlock.Body != null && elsBlock.Body.Count > 0 && elsBlock.Body[0].StartToken != null) {
                        firstStmtLine = ((Token)elsBlock.Body[0].StartToken).line;
                    }

                    HandleBlock(elsBlock);
                    
                    if (elsBlock.StartToken != null && blockStartLine != firstStmtLine && elsBlock.Body != null) {
                        var printStmt = CreateCoveragePrint((Token)elsBlock.StartToken);
                        elsBlock.Body.Insert(0, printStmt); 
                    }
                } 
                else {
                    HandleStatement(ifStmt.Els);
                }
            }
        } else if (stmt is WhileStmt whileStmt) {
            if (whileStmt.Body != null) {
                HandleBlock(whileStmt.Body);
            }
        } else if (stmt is ForLoopStmt forLoopStmt) {
            if (forLoopStmt.Body != null) {
                HandleBlock(forLoopStmt.Body);
            }
        } else if (stmt is BlockStmt blockStmt) {
            HandleBlock(blockStmt);
        }
    }

    private void InjectLoopVariable(WhileStmt whileStmt) {
        var token = (Token)whileStmt.StartToken;
        string counterName = $"__loop_counter_{token.line}_{token.col}";

        var localVar = new LocalVariable(token, counterName, new IntType(), false);
        var varDecl = new VarDeclStmt(token, new List<LocalVariable> { localVar }, null);
        _newBlockBody.Add(varDecl); 

        var initLhs = new NameSegment(token, counterName, null);
        var initAssign = new AssignStatement(token, 
            new List<Expression> { initLhs }, 
            new List<AssignmentRhs> { new ExprRhs(Expression.CreateIntLiteral(token, 0)) }
        );
        _newBlockBody.Add(initAssign);
    }

    private void InjectLoopIncrementAndExpect(WhileStmt whileStmt) {
        var token = (Token)whileStmt.StartToken;
        string counterName = $"__loop_counter_{token.line}_{token.col}";

        if (whileStmt.Body != null && whileStmt.Body.Body != null) {
            var incLhs = new NameSegment(token, counterName, null);
            var incRhs = new NameSegment(token, counterName, null);
            var expectLhs = new NameSegment(token, counterName, null);

            var plusOneExpr = new BinaryExpr(token, BinaryExpr.Opcode.Add, incRhs, Expression.CreateIntLiteral(token, 1));
            var incrementStmt = new AssignStatement(token, 
                new List<Expression> { incLhs }, 
                new List<AssignmentRhs> { new ExprRhs(plusOneExpr) }
            );

            var condition = new BinaryExpr(token, BinaryExpr.Opcode.Le, expectLhs, Expression.CreateIntLiteral(token, _maxIterations));
            var expectMsg = new StringLiteralExpr(token, "Infinite loop blocked by test coverage plugin", false);
            var expectStmt = new ExpectStmt(token, condition, expectMsg, null);

            whileStmt.Body.Body.Insert(0, incrementStmt);
            whileStmt.Body.Body.Insert(1, expectStmt);
        }
    }

    private PrintStmt CreateCoveragePrint(Token token) {
        var prefixElement = new StringLiteralExpr(token, "COVERAGE_LINE: ", false);
        var lineElement = Expression.CreateIntLiteral(token, token.line);
        var suffixElement = new StringLiteralExpr(token, "\\n", false); 

        var printElements = new List<Expression> { prefixElement, lineElement, suffixElement };
        return new PrintStmt(token, printElements);
    }
}