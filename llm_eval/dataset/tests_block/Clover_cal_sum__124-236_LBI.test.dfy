method {:testEntry} Sum(N: int) returns (s: int)
  requires N >= 0
  ensures s == N * (N + 1) / 2
{
  var n := 0;
  s := 0;
  while n != N
    invariant 0 <= n <= N
    invariant s == n * (n + 1) / 2
  {
    break;
    n := n + 1;
    s := s + n;
  }
}


method {:test} Test0() {
expect 1797 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Sum(1797);
expect r0 == 1797 * (1797 + 1) / 2;
}

method {:test} Test1() {
expect 1798 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Sum(1798);
expect r0 == 1798 * (1798 + 1) / 2;
}

method {:test} Test2() {
expect 9518 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Sum(9518);
expect r0 == 9518 * (9518 + 1) / 2;
}

method {:test} Test3() {
expect 9519 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Sum(9519);
expect r0 == 9519 * (9519 + 1) / 2;
}

method {:test} Test4() {
expect 9520 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Sum(9520);
expect r0 == 9520 * (9520 + 1) / 2;
}

method {:test} Test5() {
expect 9521 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Sum(9521);
expect r0 == 9521 * (9521 + 1) / 2;
}

method {:test} Test6() {
expect 9522 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Sum(9522);
expect r0 == 9522 * (9522 + 1) / 2;
}

method {:test} Test7() {
expect 9523 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Sum(9523);
expect r0 == 9523 * (9523 + 1) / 2;
}

method {:test} Test8() {
expect 17243 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Sum(17243);
expect r0 == 17243 * (17243 + 1) / 2;
}

method {:test} Test9() {
expect 17244 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Sum(17244);
expect r0 == 17244 * (17244 + 1) / 2;
}

