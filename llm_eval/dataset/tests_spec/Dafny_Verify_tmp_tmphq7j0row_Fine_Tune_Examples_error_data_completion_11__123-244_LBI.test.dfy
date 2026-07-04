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

method {:test} Test1() {
expect 40 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(40);
expect r0 == 2 * 40;
}

method {:test} Test2() {
expect 41 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(41);
expect r0 == 2 * 41;
}

method {:test} Test3() {
expect 42 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(42);
expect r0 == 2 * 42;
}

method {:test} Test4() {
expect 43 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(43);
expect r0 == 2 * 43;
}

method {:test} Test5() {
expect 44 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(44);
expect r0 == 2 * 44;
}

method {:test} Test6() {
expect 45 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(45);
expect r0 == 2 * 45;
}

method {:test} Test7() {
expect 46 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(46);
expect r0 == 2 * 46;
}

method {:test} Test8() {
expect 47 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(47);
expect r0 == 2 * 47;
}

method {:test} Test9() {
expect 48 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(48);
expect r0 == 2 * 48;
}

