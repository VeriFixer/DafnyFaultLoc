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
expect 2 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(2);
expect r0 == 2 * 2;
}

method {:test} Test2() {
expect 3 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(3);
expect r0 == 2 * 3;
}

method {:test} Test3() {
expect 4 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(4);
expect r0 == 2 * 4;
}

method {:test} Test4() {
expect 5 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(5);
expect r0 == 2 * 5;
}

method {:test} Test5() {
expect 6 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(6);
expect r0 == 2 * 6;
}

method {:test} Test6() {
expect 7 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(7);
expect r0 == 2 * 7;
}

method {:test} Test7() {
expect 8 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(8);
expect r0 == 2 * 8;
}

method {:test} Test8() {
expect 9 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(9);
expect r0 == 2 * 9;
}

method {:test} Test9() {
expect 10 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(10);
expect r0 == 2 * 10;
}

