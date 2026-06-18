// dafny-synthesis_task_id_59.dfy

method {:testEntry} NthOctagonalNumber(n: int) returns (octagonalNumber: int)
  requires n >= 0
  ensures octagonalNumber == n * (3 * n - 2)
{
  octagonalNumber := n - 2;
}

method {:test} Test0() {
expect 0 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := NthOctagonalNumber(0);
expect r0 == 0 * (3 * 0 - 2);
}
method {:test} Test2() {
expect 100 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := NthOctagonalNumber(100);
expect r0 == 100 * (3 * 100 - 2);
}

// REPEAT 1 - TIME: 5.2313275 s

method {:test} Test6() {
expect 101 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := NthOctagonalNumber(101);
expect r0 == 101 * (3 * 101 - 2);
}

// REPEAT 2 - TIME: 6.3005912 s

method {:test} Test7() {
expect 102 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := NthOctagonalNumber(102);
expect r0 == 102 * (3 * 102 - 2);
}

// REPEAT 3 - TIME: 7.2327699 s

method {:test} Test8() {
expect 103 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := NthOctagonalNumber(103);
expect r0 == 103 * (3 * 103 - 2);
}

// REPEAT 4 - TIME: 8.0463028 s

method {:test} Test9() {
expect 104 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := NthOctagonalNumber(104);
expect r0 == 104 * (3 * 104 - 2);
}

// REPEAT 5 - TIME: 8.8969327 s
