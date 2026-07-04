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
  var x: int;
  d := m;
  x := n;
  while false
    invariant x > 0
    invariant d > 0
    invariant gcd(d, x) == gcd(m, n)
    decreases x + d
  {
    if d > x {
      d := d - x;
    } else {
      x := x - d;
    }
  }
}

ghost function gcd'(x: int, y: int): int
  requires x > 0 && y > 0
  decreases if x > y then x else y
{
  if x == y then
    x
  else if x > y then
    gcd'(x - y, y)
  else
    gcd(y, x)
}


method {:test} Test0() {
expect 2 > 0 && 1 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(2, 1);
}

method {:test} Test1() {
expect 7724 > 0 && 2 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(7724, 2);
}

method {:test} Test2() {
expect 7725 > 0 && 3 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(7725, 3);
}

method {:test} Test3() {
expect 7726 > 0 && 4 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(7726, 4);
}

method {:test} Test4() {
expect 7727 > 0 && 5 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(7727, 5);
}

method {:test} Test5() {
expect 7728 > 0 && 9 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(7728, 9);
}

method {:test} Test6() {
expect 7729 > 0 && 19 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(7729, 19);
}

method {:test} Test7() {
expect 23168 > 0 && 11584 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(23168, 11584);
}

method {:test} Test8() {
expect 23170 > 0 && 11585 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(23170, 11585);
}

method {:test} Test9() {
expect 23172 > 0 && 11586 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(23172, 11586);
}

