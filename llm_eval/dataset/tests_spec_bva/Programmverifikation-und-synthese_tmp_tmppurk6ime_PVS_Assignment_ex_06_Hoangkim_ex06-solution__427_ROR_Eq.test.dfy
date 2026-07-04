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
    if x == y {
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
expect 16677 > 0 && 7720 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(16677, 7720);
}
method {:test} Test1() {
expect 1 > 0 && 1239 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(1, 1239);
}
method {:test} Test2() {
expect 100 > 0 && 201 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(100, 201);
}
method {:test} Test3() {
expect 1239 > 0 && 1 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(1239, 1);
}
method {:test} Test4() {
expect 201 > 0 && 100 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(201, 100);
}

method {:test} Test10() {
expect 16754 > 0 && 8377 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(16754, 8377);
}

method {:test} Test11() {
expect 16757 > 0 && 8378 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(16757, 8378);
}

method {:test} Test12() {
expect 16759 > 0 && 8379 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(16759, 8379);
}

method {:test} Test13() {
expect 16836 > 0 && 8418 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(16836, 8418);
}

method {:test} Test14() {
expect 16838 > 0 && 8419 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(16838, 8419);
}

method {:test} Test15() {
expect 16840 > 0 && 8420 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(16840, 8420);
}

method {:test} Test16() {
expect 16843 > 0 && 8421 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(16843, 8421);
}

method {:test} Test17() {
expect 16845 > 0 && 8422 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(16845, 8422);
}

method {:test} Test18() {
expect 16847 > 0 && 8423 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(16847, 8423);
}

