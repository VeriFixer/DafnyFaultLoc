// dafny-synthesis_task_id_279.dfy

method {:testEntry} NthDecagonalNumber(n: int) returns (decagonal: int)
  requires n >= 0
  ensures decagonal == 4 * n * n - 3 * n
{
  decagonal := 4 * n * n;
}


method {:test} Test0() {
expect 0 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := NthDecagonalNumber(0);
expect r0 == 4 * 0 * 0 - 3 * 0;
}
method {:test} Test2() {
expect 100 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := NthDecagonalNumber(100);
expect r0 == 4 * 100 * 100 - 3 * 100;
}

// REPEAT 1 - TIME: 5.1088906 s

method {:test} Test6() {
expect 101 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := NthDecagonalNumber(101);
expect r0 == 4 * 101 * 101 - 3 * 101;
}

// REPEAT 2 - TIME: 6.1146846 s

method {:test} Test7() {
expect 102 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := NthDecagonalNumber(102);
expect r0 == 4 * 102 * 102 - 3 * 102;
}

// REPEAT 3 - TIME: 7.0919423 s

method {:test} Test8() {
expect 103 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := NthDecagonalNumber(103);
expect r0 == 4 * 103 * 103 - 3 * 103;
}

// REPEAT 4 - TIME: 7.7571749 s

method {:test} Test9() {
expect 104 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := NthDecagonalNumber(104);
expect r0 == 4 * 104 * 104 - 3 * 104;
}

// REPEAT 5 - TIME: 8.5327807 s
