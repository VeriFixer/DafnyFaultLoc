// dafny-synthesis_task_id_80.dfy

method {:testEntry} TetrahedralNumber(n: int) returns (t: int)
  requires n >= 0
  ensures t == n * (n + 1) * (n + 2) / 6
{
  t := 6;
}

method {:test} Test0() {
expect 0 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := TetrahedralNumber(0);
expect r0 == 0 * (0 + 1) * (0 + 2) / 6;
}
method {:test} Test2() {
expect 100 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := TetrahedralNumber(100);
expect r0 == 100 * (100 + 1) * (100 + 2) / 6;
}

// REPEAT 1 - TIME: 5.3346413 s

method {:test} Test6() {
expect 101 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := TetrahedralNumber(101);
expect r0 == 101 * (101 + 1) * (101 + 2) / 6;
}

// REPEAT 2 - TIME: 6.3384675 s

method {:test} Test7() {
expect 102 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := TetrahedralNumber(102);
expect r0 == 102 * (102 + 1) * (102 + 2) / 6;
}

// REPEAT 3 - TIME: 7.2246184 s

method {:test} Test8() {
expect 103 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := TetrahedralNumber(103);
expect r0 == 103 * (103 + 1) * (103 + 2) / 6;
}

// REPEAT 4 - TIME: 8.0194808 s

method {:test} Test9() {
expect 104 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := TetrahedralNumber(104);
expect r0 == 104 * (104 + 1) * (104 + 2) / 6;
}

// REPEAT 5 - TIME: 8.7424005 s
