function power(a: int, n: int): int
  requires 0 <= n
  decreases n
{
  if n == 0 then
    1
  else
    a * power(a, n - 1)
}

method {:testEntry} A8Q1(y0: int, x: int) returns (z: int)
  requires y0 >= 0
  ensures z == power(x, y0)
{
  var y := y0;
  z := 1;
  while y > 0
    invariant z == power(x, y0 - y) && y >= 0
    decreases y
  {
    break;
    z := z * x;
    y := y - 1;
  }
}


method {:test} Test0() {
expect 1 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := A8Q1(1, 7719);
expect r0 == power(7719, 1);
}

method {:test} Test1() {
expect 2 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := A8Q1(2, 7720);
expect r0 == power(7720, 2);
}

method {:test} Test2() {
expect 3 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := A8Q1(3, 7721);
expect r0 == power(7721, 3);
}

method {:test} Test3() {
expect 4 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := A8Q1(4, 7722);
expect r0 == power(7722, 4);
}

method {:test} Test4() {
expect 5 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := A8Q1(5, 7723);
expect r0 == power(7723, 5);
}

method {:test} Test5() {
expect 6 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := A8Q1(6, 7724);
expect r0 == power(7724, 6);
}

method {:test} Test6() {
expect 7 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := A8Q1(7, 7725);
expect r0 == power(7725, 7);
}

method {:test} Test7() {
expect 8 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := A8Q1(8, 7726);
expect r0 == power(7726, 8);
}

method {:test} Test8() {
expect 9 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := A8Q1(9, 7727);
expect r0 == power(7727, 9);
}

method {:test} Test9() {
expect 10 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := A8Q1(10, 7728);
expect r0 == power(7728, 10);
}

