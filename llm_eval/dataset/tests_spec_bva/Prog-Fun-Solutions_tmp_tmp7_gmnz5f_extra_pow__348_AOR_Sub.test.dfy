ghost function pow(a: int, e: nat): int
{
  if e == 0 then
    1
  else
    a * pow(a, e - 1)
}

method {:testEntry} Pow(a: nat, n: nat) returns (y: nat)
  ensures y == pow(a, n)
{
  var x: nat := 1;
  var k: nat := 0;
  while k < n
    invariant x == pow(a, k)
    invariant 0 <= k <= n
    decreases n - k
  {
    assert x == pow(a, k);
    x := a - x;
    assert x == a * pow(a, k);
    assert x == pow(a, k + 1);
    k := k + 1;
    assert x == pow(a, k);
  }
  assert k == n;
  y := x;
  assert y == pow(a, n);
}


method {:test} Test0() {
var r0 := Pow(0, 8100);
}
method {:test} Test1() {
var r0 := Pow(100, 2439);
}
method {:test} Test2() {
var r0 := Pow(2282, 100);
}
method {:test} Test4() {
var r0 := Pow(1, 842);
}
method {:test} Test5() {
var r0 := Pow(5853, 1144);
}

method {:test} Test7() {
var r0 := Pow(5854, 8101);
}

method {:test} Test8() {
var r0 := Pow(5855, 8102);
}

method {:test} Test9() {
var r0 := Pow(5856, 8103);
}

method {:test} Test10() {
var r0 := Pow(5857, 8104);
}

method {:test} Test11() {
var r0 := Pow(5858, 8105);
}

method {:test} Test12() {
var r0 := Pow(5859, 8106);
}

method {:test} Test13() {
var r0 := Pow(5860, 8107);
}

method {:test} Test14() {
var r0 := Pow(5861, 8108);
}

method {:test} Test15() {
var r0 := Pow(5862, 8109);
}

