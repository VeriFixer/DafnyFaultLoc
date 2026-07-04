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
expect 1 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ComputePower(1);
expect r0 == Power(1);
}

method {:test} Test1() {
expect 2 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ComputePower(2);
expect r0 == Power(2);
}

method {:test} Test2() {
expect 3 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ComputePower(3);
expect r0 == Power(3);
}

method {:test} Test3() {
expect 4 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ComputePower(4);
expect r0 == Power(4);
}

method {:test} Test4() {
expect 5 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ComputePower(5);
expect r0 == Power(5);
}

method {:test} Test5() {
expect 6 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ComputePower(6);
expect r0 == Power(6);
}

method {:test} Test6() {
expect 7 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ComputePower(7);
expect r0 == Power(7);
}

method {:test} Test7() {
expect 8 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ComputePower(8);
expect r0 == Power(8);
}

method {:test} Test8() {
expect 9 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ComputePower(9);
expect r0 == Power(9);
}

method {:test} Test9() {
expect 10 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ComputePower(10);
expect r0 == Power(10);
}

