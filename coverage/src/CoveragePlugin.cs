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
                    if (member is Method method && method.Body != null && !method.IsGhost) {
                        builder.InstrumentMethod(method);
                    }
                    else if (member is Function function && function.Body != null && !function.IsGhost) {
                        builder.InstrumentFunction(function);
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
            var resetCall = CoverageUtils.CreateFunctionCall(token, "Reset");
            
            var resetMsg = new StringLiteralExpr(token, "Recursion counter reset", false);
            var resetExpect = new ExpectStmt(token, resetCall, resetMsg, null);
            
            var prefix = new StringLiteralExpr(token, "--- RUNNING TEST: " + method.Name + " ---\\n", false);
            var printStmt = new PrintStmt(token, new List<Expression> { prefix });

            if (method.Body.Body != null) {
                method.Body.Body.Insert(0, printStmt);
                method.Body.Body.Insert(0, resetExpect);
            }  
            return; 
        }
        HandleBlock(method.Body);
        InjectRecursionExpect(method);
    }

    public void InstrumentFunction(Function function) {
        if (function == null || function.Body == null) return;
        
        var token = (Token)function.StartToken;
        var argExpr = Expression.CreateIntLiteral(token, _maxIterations);
        var checkDepthCall = CoverageUtils.CreateFunctionCall(token, "CheckDepth", argExpr);

        var cloner = new Microsoft.Dafny.Cloner();
        var clonedBody = cloner.CloneExpr(function.Body);

        var iteExpr = new ITEExpr(token, false, checkDepthCall, function.Body, clonedBody);
        function.Body = iteExpr;
    }

    private void HandleBlock(BlockStmt blockStmt) {
        if (blockStmt == null || blockStmt.Body == null) return;

        var prevNewBlock = _newBlockBody;
        _newBlockBody = new List<Statement>(); 

        foreach (var stmt in blockStmt.Body) {
            if (stmt is PrintStmt || stmt.IsGhost) {
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
                var printStmt = CoverageUtils.CreateCoveragePrint((Token)stmt.StartToken);
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
                        var targetToken = (Token)elsBlock.StartToken;
                        var elseToken = CoverageUtils.FindElseToken(targetToken, (Token)ifStmt.StartToken);
                        var printStmt = CoverageUtils.CreateCoveragePrint(targetToken);
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

        else if (stmt is MatchStmt matchStmt) {
            if (matchStmt.Cases != null) {
                foreach (var matchCase in matchStmt.Cases) {
                    if (matchCase.Body != null) {
                        foreach (var caseStmt in matchCase.Body) {
                            HandleStatement(caseStmt);
                        }
                    }
                }
            }
        }
        else if (stmt is AlternativeStmt altStmt) {
            if (altStmt.Alternatives != null) {
                foreach (var alt in altStmt.Alternatives) {
                    if (alt.Body != null) {
                        foreach (var altStmtBody in alt.Body) {
                            HandleStatement(altStmtBody);
                        }
                    }
                }
            }
        }
    }

    private void InjectLoopVariable(WhileStmt whileStmt) {
        var token = (Token)whileStmt.StartToken;
        var initStatements = CoverageUtils.CreateLoopVariableInits(token);
        _newBlockBody.AddRange(initStatements); 
    }

    private void InjectLoopIncrementAndExpect(WhileStmt whileStmt) {
        if (whileStmt.Body != null && whileStmt.Body.Body != null) {
            var token = (Token)whileStmt.StartToken;
            var loopGuards = CoverageUtils.CreateLoopIncrementAndExpect(token, _maxIterations);

            whileStmt.Body.Body.Insert(0, loopGuards[0]);
            whileStmt.Body.Body.Insert(1, loopGuards[1]);
        }
    }

    private void InjectRecursionExpect(Method method) {
        if (method.Body == null || method.Body.Body == null) return;

        var token = (Token)method.StartToken;

        var argExpr = Expression.CreateIntLiteral(token, _maxIterations);
        var checkDepthCall = CoverageUtils.CreateFunctionCall(token, "CheckDepth", argExpr);
        
        var expectMsg = new StringLiteralExpr(token, "Possible infinite recursion blocked by coverage plugin", false);
        var expectStmt = new ExpectStmt(token, checkDepthCall, expectMsg, null);

        method.Body.Body.Insert(0, expectStmt);
    }
}