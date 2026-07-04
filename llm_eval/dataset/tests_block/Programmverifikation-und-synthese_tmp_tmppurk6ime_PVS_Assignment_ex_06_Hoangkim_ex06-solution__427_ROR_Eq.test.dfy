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
expect 39 > 0 && 1315 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(39, 1315);
}
method {:test} Test1() {
expect 103 > 0 && 12602 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(103, 12602);
}
method {:test} Test2() {
expect 3369 > 0 && 14970 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(3369, 14970);
}

method {:test} Test3() {
expect 3370 > 0 && 14971 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(3370, 14971);
}

method {:test} Test6() {
expect 3371 > 0 && 14972 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(3371, 14972);
}
method {:test} Test7() {
expect 8722 > 0 && 17444 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(8722, 17444);
}

method {:test} Test9() {
expect 8723 > 0 && 25166 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(8723, 25166);
}
method {:test} Test10() {
expect 16442 > 0 && 32884 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(16442, 32884);
}
method {:test} Test11() {
expect 8723 > 0 && 17446 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(8723, 17446);
}

method {:test} Test12() {
expect 16443 > 0 && 32886 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(16443, 32886);
}
method {:test} Test13() {
expect 16443 > 0 && 41742 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(16443, 41742);
}

method {:test} Test15() {
expect 20910 > 0 && 41820 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(20910, 41820);
}
method {:test} Test16() {
expect 16444 > 0 && 41743 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(16444, 41743);
}

method {:test} Test18() {
expect 20911 > 0 && 41822 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(20911, 41822);
}
method {:test} Test19() {
expect 20911 > 0 && 44260 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(20911, 44260);
}

method {:test} Test21() {
expect 20912 > 0 && 44261 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(20912, 44261);
}
method {:test} Test23() {
expect 23367 > 0 && 46734 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(23367, 46734);
}

method {:test} Test24() {
expect 23368 > 0 && 54456 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(23368, 54456);
}
method {:test} Test25() {
expect 23368 > 0 && 49174 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(23368, 49174);
}
method {:test} Test26() {
expect 23368 > 0 && 55592 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(23368, 55592);
}

method {:test} Test27() {
expect 23369 > 0 && 55593 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(23369, 55593);
}

