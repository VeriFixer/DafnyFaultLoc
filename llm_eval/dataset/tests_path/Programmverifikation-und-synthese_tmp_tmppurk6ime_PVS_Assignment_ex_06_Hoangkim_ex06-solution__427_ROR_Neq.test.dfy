ghost function gcd(x: int, y: int): int
  requires x > 0 && y > 0
{
  if x == y then
    x
  else if x > y then
    gcd(x - y, y)
  else
    gcd(x, y - x)
}

method {:testEntry} gcdI(m: int, n: int) returns (d: int)
  requires m > 0 && n > 0
  ensures d == gcd(m, n)
{
  var x, y := m, n;
  d := 1;
  while x != y
    invariant x > 0 && y > 0
    invariant gcd(x, y) == gcd(m, n)
    decreases x + y
  {
    if x != y {
      x := x - y;
    } else {
      y := y - x;
    }
  }
  d := x;
}

ghost function gcd'(x: int, y: int): int
  requires x > 0 && y > 0
  decreases x + y, y
{
  if x == y then
    x
  else if x > y then
    gcd'(x - y, y)
  else
    gcd'(y, x)
}


method {:test} Test0() {
expect 39 > 0 && 1315 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(39, 1315);
}

method {:test} Test1() {
expect 40 > 0 && 1316 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(40, 1316);
}

method {:test} Test2() {
expect 697 > 0 && 1394 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(697, 1394);
}

method {:test} Test3() {
expect 698 > 0 && 9116 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(698, 9116);
}

method {:test} Test4() {
expect 4597 > 0 && 9194 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(4597, 9194);
}

method {:test} Test5() {
expect 4598 > 0 && 16916 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(4598, 16916);
}

method {:test} Test6() {
expect 8497 > 0 && 16994 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(8497, 16994);
}

method {:test} Test7() {
expect 8498 > 0 && 16996 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(8498, 16996);
}

method {:test} Test8() {
expect 8499 > 0 && 24718 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(8499, 24718);
}

method {:test} Test9() {
expect 8500 > 0 && 24719 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(8500, 24719);
}

