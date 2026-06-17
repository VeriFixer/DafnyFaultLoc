method {:testEntry} SumOfFourthPowerOfOddNumbers(n: int) returns (sum: int)
    requires n > 0
    ensures sum == n * (2 * n + 1) * (24 * n * n * n - 12 * n * n  - 14 * n + 7) / 15
{
    sum := 0;
    var i := 1;
    for k := 0 to n
        invariant 0 <= k <= n
        invariant i == 2 * k + 1
        invariant sum == k * (2 * k + 1) * (24 * k * k * k - 12 * k * k  - 14 * k + 7) / 15
    {
        sum := sum + i * i * i * i;
        i := i + 2;
    }
}

method {:test} Test0() {
expect 25 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SumOfFourthPowerOfOddNumbers(25);
expect r0 == 25 * (2 * 25 + 1) * (24 * 25 * 25 * 25 - 12 * 25 * 25 - 14 * 25 + 7) / 15;
}
method {:test} Test1() {
expect 1 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SumOfFourthPowerOfOddNumbers(1);
expect r0 == 1 * (2 * 1 + 1) * (24 * 1 * 1 * 1 - 12 * 1 * 1 - 14 * 1 + 7) / 15;
}
method {:test} Test2() {
expect 100 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SumOfFourthPowerOfOddNumbers(100);
expect r0 == 100 * (2 * 100 + 1) * (24 * 100 * 100 * 100 - 12 * 100 * 100 - 14 * 100 + 7) / 15;
}
method {:test} Test3() {
expect 33 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SumOfFourthPowerOfOddNumbers(33);
expect r0 == 33 * (2 * 33 + 1) * (24 * 33 * 33 * 33 - 12 * 33 * 33 - 14 * 33 + 7) / 15;
}
method {:test} Test4() {
expect 27 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SumOfFourthPowerOfOddNumbers(27);
expect r0 == 27 * (2 * 27 + 1) * (24 * 27 * 27 * 27 - 12 * 27 * 27 - 14 * 27 + 7) / 15;
}

// REPEAT 1 - TIME: 55.0562257 s

method {:test} Test5() {
expect 340 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SumOfFourthPowerOfOddNumbers(340);
expect r0 == 340 * (2 * 340 + 1) * (24 * 340 * 340 * 340 - 12 * 340 * 340 - 14 * 340 + 7) / 15;
}

// REPEAT 2 - TIME: 78.4709372 s

method {:test} Test6() {
expect 341 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SumOfFourthPowerOfOddNumbers(341);
expect r0 == 341 * (2 * 341 + 1) * (24 * 341 * 341 * 341 - 12 * 341 * 341 - 14 * 341 + 7) / 15;
}

// REPEAT 3 - TIME: 78.7558782 s

method {:test} Test7() {
expect 342 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SumOfFourthPowerOfOddNumbers(342);
expect r0 == 342 * (2 * 342 + 1) * (24 * 342 * 342 * 342 - 12 * 342 * 342 - 14 * 342 + 7) / 15;
}

// REPEAT 4 - TIME: 78.9949034 s

method {:test} Test8() {
expect 343 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SumOfFourthPowerOfOddNumbers(343);
expect r0 == 343 * (2 * 343 + 1) * (24 * 343 * 343 * 343 - 12 * 343 * 343 - 14 * 343 + 7) / 15;
}

// REPEAT 5 - TIME: 79.2425953 s
