// dafny-synthesis_task_id_641.dfy

method {:testEntry} NthNonagonalNumber(n: int) returns (number: int)
  requires n >= 0
  ensures number == n * (7 * n - 5) / 2
{
  number := (n - 5) / 2;
}


method {:testEntry} NthNonagonalNumber(n: int) returns (number: int)
    requires n >= 0
    ensures number == n * (7 * n - 5) / 2
{
    number := n * (7 * n - 5) / 2;
}

method {:test} Test0() {
expect 0 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := NthNonagonalNumber(0);
expect r0 == 0 * (7 * 0 - 5) / 2;
}
method {:test} Test2() {
expect 100 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := NthNonagonalNumber(100);
expect r0 == 100 * (7 * 100 - 5) / 2;
}

// REPEAT 1 - TIME: 35.6622627 s

method {:test} Test6() {
expect 101 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := NthNonagonalNumber(101);
expect r0 == 101 * (7 * 101 - 5) / 2;
}

// REPEAT 2 - TIME: 36.3385662 s

method {:test} Test7() {
expect 102 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := NthNonagonalNumber(102);
expect r0 == 102 * (7 * 102 - 5) / 2;
}

// REPEAT 3 - TIME: 37.0176795 s

method {:test} Test8() {
expect 103 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := NthNonagonalNumber(103);
expect r0 == 103 * (7 * 103 - 5) / 2;
}

// REPEAT 4 - TIME: 37.714355 s

method {:test} Test9() {
expect 104 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := NthNonagonalNumber(104);
expect r0 == 104 * (7 * 104 - 5) / 2;
}

// REPEAT 5 - TIME: 38.416435 s
