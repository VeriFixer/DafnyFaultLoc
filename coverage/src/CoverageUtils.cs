using Microsoft.Dafny;
using System.Collections.Generic;
using System.Reflection;

namespace DafnyTestCoverage;

public static class CoverageUtils {

    private readonly static string _loopCounterName = "loop_counter";

    /// <summary>
    /// Creates a PrintStmt that outputs "COVERAGE_LINE: [line]\n"
    /// </summary>
    public static PrintStmt CreateCoveragePrint(Token token) {
        var prefixElement = new StringLiteralExpr(token, "COVERAGE_LINE: ", false);
        var lineElement = Expression.CreateIntLiteral(token, token.line);
        var suffixElement = new StringLiteralExpr(token, "\\n", false); 

        var printElements = new List<Expression> { prefixElement, lineElement, suffixElement };
        return new PrintStmt(token, printElements);
    }

    /// <summary>
    /// Walks backwards from a target token to find the 'else' keyword token.
    /// </summary>
    public static Token FindElseToken(Token targetToken, Token ifStartToken) {
        var currentTok = targetToken.Prev;

        while (currentTok != null) {
            if (currentTok.val == "else") {
                return currentTok;
            }
            if (currentTok == ifStartToken) {
                break;
            }
            currentTok = currentTok.Prev;
        }
        
        return targetToken;
    }

    /// <summary>
    /// Creates a function call
    /// </summary>
    public static ApplySuffix CreateFunctionCall(Token token, string funtionName, Expression? argExpr = null) {
        var funcName = new NameSegment(token, funtionName, null);
        
        var bindings = argExpr == null 
            ? new ActualBindings(new List<Expression>())
            : new ActualBindings(new List<Expression> { argExpr });

        return new ApplySuffix(token, null, funcName, bindings, token);
    }

    /// <summary>
    /// Creates loop varible init statements
    /// </summary>
    public static List<Statement> CreateLoopVariableInits(Token token) {
        string counterName = $"__{_loopCounterName}_{token.line}_{token.col}";

        var localVar = new LocalVariable(token, counterName, new IntType(), false);
        var varDecl = new VarDeclStmt(token, new List<LocalVariable> { localVar }, null); 

        var initLhs = new NameSegment(token, counterName, null);
        var initAssign = new AssignStatement(token, 
            new List<Expression> { initLhs }, 
            new List<AssignmentRhs> { new ExprRhs(Expression.CreateIntLiteral(token, 0)) }
        );

        return new List<Statement> { varDecl, initAssign };
    }

    /// <summary>
    /// Creates loop increment and expect statements
    /// </summary>
    public static List<Statement> CreateLoopIncrementAndExpect(Token token, int maxIterations) {
        string counterName = $"__{_loopCounterName}_{token.line}_{token.col}";

        var incLhs = new NameSegment(token, counterName, null);
        var incRhs = new NameSegment(token, counterName, null);
        var expectLhs = new NameSegment(token, counterName, null);

        var plusOneExpr = new BinaryExpr(token, BinaryExpr.Opcode.Add, incRhs, Expression.CreateIntLiteral(token, 1));
        var incrementStmt = new AssignStatement(token, 
            new List<Expression> { incLhs }, 
            new List<AssignmentRhs> { new ExprRhs(plusOneExpr) }
        );

        var condition = new BinaryExpr(token, BinaryExpr.Opcode.Le, expectLhs, Expression.CreateIntLiteral(token, maxIterations));
        var expectMsg = new StringLiteralExpr(token, "Possible infinite loop blocked by coverage plugin", false);
        var expectStmt = new ExpectStmt(token, condition, expectMsg, null);

        return new List<Statement> { incrementStmt, expectStmt };
    }
}