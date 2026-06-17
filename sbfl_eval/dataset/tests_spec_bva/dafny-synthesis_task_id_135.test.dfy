method {:testEntry} NthHexagonalNumber(n: int) returns (hexNum: int)
    requires n >= 0
    ensures hexNum == n * ((2 * n) - 1)
{
    hexNum := n * ((2 * n) - 1);
}

method {:test} Test0() {
expect 0 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := NthHexagonalNumber(0);
expect r0 == 0 * (2 * 0 - 1);
}
method {:test} Test2() {
expect 100 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := NthHexagonalNumber(100);
expect r0 == 100 * (2 * 100 - 1);
}

// REPEAT 1 - TIME: 4.983369 s

method {:test} Test6() {
expect 101 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := NthHexagonalNumber(101);
expect r0 == 101 * (2 * 101 - 1);
}

// REPEAT 2 - TIME: 5.9037995 s

method {:test} Test7() {
expect 102 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := NthHexagonalNumber(102);
expect r0 == 102 * (2 * 102 - 1);
}

// REPEAT 3 - TIME: 6.5548332 s

method {:test} Test8() {
expect 103 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := NthHexagonalNumber(103);
expect r0 == 103 * (2 * 103 - 1);
}

// REPEAT 4 - TIME: 7.4057316 s

method {:test} Test9() {
expect 104 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := NthHexagonalNumber(104);
expect r0 == 104 * (2 * 104 - 1);
}

// REPEAT 5 - TIME: 8.2724287 s
