method {:testEntry} main(x: int) returns (j: int, i: int)
  requires x > 0
  ensures j == 2 * x
{
  i := 0;
  j := 0;
  while i < x
    invariant 0 <= i <= x
    invariant j == 2 * i
  {
    break;
    j := j + 2;
    i := i + 1;
  }
}


method {:test} Test0() {
expect 1 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(1);
expect r0 == 2 * 1;
}
method {:test} Test2() {
expect 100 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(100);
expect r0 == 2 * 100;
}

method {:test} Test9() {
expect 101 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(101);
expect r0 == 2 * 101;
}

method {:test} Test10() {
expect 102 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(102);
expect r0 == 2 * 102;
}

method {:test} Test11() {
expect 103 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(103);
expect r0 == 2 * 103;
}

method {:test} Test12() {
expect 104 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(104);
expect r0 == 2 * 104;
}

method {:test} Test13() {
expect 105 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(105);
expect r0 == 2 * 105;
}

method {:test} Test14() {
expect 106 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(106);
expect r0 == 2 * 106;
}

method {:test} Test15() {
expect 107 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(107);
expect r0 == 2 * 107;
}

method {:test} Test16() {
expect 108 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(108);
expect r0 == 2 * 108;
}

method {:test} Test17() {
expect 109 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(109);
expect r0 == 2 * 109;
}

