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
    x := a + x;
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
var r0 := Pow(1, 8101);
}

method {:test} Test2() {
var r0 := Pow(2, 8102);
}

method {:test} Test3() {
var r0 := Pow(3, 8103);
}

method {:test} Test4() {
var r0 := Pow(4, 8104);
}

method {:test} Test5() {
var r0 := Pow(5, 8105);
}

method {:test} Test6() {
var r0 := Pow(6, 8106);
}

method {:test} Test7() {
var r0 := Pow(7, 8107);
}

method {:test} Test8() {
var r0 := Pow(8, 8108);
}

method {:test} Test9() {
var r0 := Pow(9, 8109);
}

