method {:testEntry} main(n: int, k: int)
    returns (i: int, j: int)
  requires n >= 0
  requires k == 1 || k >= 0
  ensures k + i + j >= 2 * n
{
  i := 0;
  j := 0;
  while i < n
    invariant 0 <= i <= n
    invariant j == i * (i + 1) / 2
  {
    break;
    i := i + 1;
    j := j + i;
  }
}


method {:test} Test0() {
expect 0 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 1 == 1 || 1 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(0, 1);
expect 1 + r0 + r1 >= 2 * 0;
}
method {:test} Test1() {
expect 0 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 2 == 1 || 2 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(0, 2);
expect 2 + r0 + r1 >= 2 * 0;
}

method {:test} Test2() {
expect 1 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 3 == 1 || 3 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(1, 3);
expect 3 + r0 + r1 >= 2 * 1;
}

method {:test} Test3() {
expect 2 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 4 == 1 || 4 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(2, 4);
expect 4 + r0 + r1 >= 2 * 2;
}

method {:test} Test4() {
expect 7722 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 5 == 1 || 5 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(7722, 5);
expect 5 + r0 + r1 >= 2 * 7722;
}

method {:test} Test5() {
expect 7723 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 6 == 1 || 6 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(7723, 6);
expect 6 + r0 + r1 >= 2 * 7723;
}

method {:test} Test6() {
expect 7724 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 7 == 1 || 7 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(7724, 7);
expect 7 + r0 + r1 >= 2 * 7724;
}

method {:test} Test7() {
expect 7725 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 8 == 1 || 8 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(7725, 8);
expect 8 + r0 + r1 >= 2 * 7725;
}

method {:test} Test8() {
expect 7726 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 9 == 1 || 9 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(7726, 9);
expect 9 + r0 + r1 >= 2 * 7726;
}

method {:test} Test9() {
expect 7727 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 10 == 1 || 10 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(7727, 10);
expect 10 + r0 + r1 >= 2 * 7727;
}

method {:test} Test10() {
expect 7728 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 11 == 1 || 11 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(7728, 11);
expect 11 + r0 + r1 >= 2 * 7728;
}

