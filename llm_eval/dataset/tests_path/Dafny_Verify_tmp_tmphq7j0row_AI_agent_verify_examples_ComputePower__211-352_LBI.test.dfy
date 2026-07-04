function Power(n: nat): nat
{
  if n == 0 then
    1
  else
    2 * Power(n - 1)
}

method {:testEntry} ComputePower(N: int) returns (y: nat)
  requires N >= 0
  ensures y == Power(N)
{
  y := 1;
  var x := 0;
  while x != N
    invariant 0 <= x <= N
    invariant y == Power(x)
    decreases N - x
  {
    break;
    x, y := x + 1, y + y;
  }
}


method {:test} Test0() {
expect 1798 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ComputePower(1798);
expect r0 == Power(1798);
}

method {:test} Test1() {
expect 1799 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ComputePower(1799);
expect r0 == Power(1799);
}

method {:test} Test2() {
expect 1800 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ComputePower(1800);
expect r0 == Power(1800);
}

method {:test} Test3() {
expect 1801 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ComputePower(1801);
expect r0 == Power(1801);
}

method {:test} Test4() {
expect 1802 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ComputePower(1802);
expect r0 == Power(1802);
}

method {:test} Test5() {
expect 1803 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ComputePower(1803);
expect r0 == Power(1803);
}

method {:test} Test6() {
expect 1804 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ComputePower(1804);
expect r0 == Power(1804);
}

method {:test} Test7() {
expect 1805 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ComputePower(1805);
expect r0 == Power(1805);
}

method {:test} Test8() {
expect 1806 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ComputePower(1806);
expect r0 == Power(1806);
}

method {:test} Test9() {
expect 1807 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ComputePower(1807);
expect r0 == Power(1807);
}

