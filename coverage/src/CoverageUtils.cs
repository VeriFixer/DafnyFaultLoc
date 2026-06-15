using Microsoft.Dafny;
using System.Collections.Generic;
using System.Reflection;

namespace DafnyTestCoverage;

public static class CoverageUtils {

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
}