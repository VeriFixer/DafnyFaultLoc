using System;
using System.Numerics;

public static class CoverageRuntime {
    [ThreadStatic]
    private static int _recursionDepth = 0;

    public static bool Reset() {
        _recursionDepth = 0;
        return true;
    }

    public static bool CheckDepth(BigInteger maxIterations) {
        _recursionDepth++;
        if (_recursionDepth > maxIterations) {
            _recursionDepth = 0;
            throw new Dafny.HaltException($"Execution limit of {maxIterations} reached. Possible infinite loop or recursion blocked.");
        }
        return true; 
    }
}