// dafny-synthesis_task_id_86.dfy

method {:testEntry} CenteredHexagonalNumber(n: nat) returns (result: nat)
  requires n >= 0
  ensures result == 3 * n * (n - 1) + 1
{
  result := 3 * n * (n - 1);
}


method {:testEntry} CenteredHexagonalNumber(n: nat) returns (result: nat)
    requires n >= 0
    ensures result == 3 * n * (n - 1) + 1
{
    result := 3 * n * (n - 1) + 1;
}

method {:test} Test0() {
expect 0 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CenteredHexagonalNumber(0);
expect r0 == 3 * 0 * (0 - 1) + 1;
}
method {:test} Test2() {
expect 100 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CenteredHexagonalNumber(100);
expect r0 == 3 * 100 * (100 - 1) + 1;
}

// REPEAT 1 - TIME: 4.8874418 s

method {:test} Test6() {
expect 101 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CenteredHexagonalNumber(101);
expect r0 == 3 * 101 * (101 - 1) + 1;
}

// REPEAT 2 - TIME: 5.7958681 s

method {:test} Test7() {
expect 102 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CenteredHexagonalNumber(102);
expect r0 == 3 * 102 * (102 - 1) + 1;
}

// REPEAT 3 - TIME: 6.7489549 s

method {:test} Test8() {
expect 103 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CenteredHexagonalNumber(103);
expect r0 == 3 * 103 * (103 - 1) + 1;
}

// REPEAT 4 - TIME: 7.6802522 s

method {:test} Test9() {
expect 104 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CenteredHexagonalNumber(104);
expect r0 == 3 * 104 * (104 - 1) + 1;
}

// REPEAT 5 - TIME: 8.3862944 s
