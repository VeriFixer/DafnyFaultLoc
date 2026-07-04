ghost function f(n: int): int
{
  if n < 0 then
    0
  else
    3 * f(n - 5) + n
}

method {:testEntry} problem5(n: nat) returns (x: int)
  ensures x == f(n)
{
  var a := 1;
  var b := 0;
  var k := n;
  while k == 0
    invariant f(n) == a * f(k) + b
    invariant -5 <= k <= n
    decreases k
  {
    assert f(n) == a * f(k) + b;
    assert f(n) == a * (3 * f(k - 5) + k) + b;
    assert f(n) == 3 * a * f(k - 5) + a * k + b;
    b := a * k + b;
    assert f(n) == 3 * a * f(k - 5) + b;
    a := 3 * a;
    assert f(n) == a * f(k - 5) + b;
    k := k - 5;
    assert f(n) == a * f(k) + b;
  }
  assert k < 0;
  assert f(n) == a * f(k) + b;
  assert f(n) == a * 0 + b;
  x := b;
  assert x == f(n);
}


method {:test} Test0() {
var r0 := problem5(1);
}

method {:test} Test1() {
var r0 := problem5(2);
}

method {:test} Test2() {
var r0 := problem5(3);
}

method {:test} Test3() {
var r0 := problem5(4);
}

method {:test} Test4() {
var r0 := problem5(1801);
}

method {:test} Test5() {
var r0 := problem5(1803);
}

method {:test} Test6() {
var r0 := problem5(1806);
}

method {:test} Test7() {
var r0 := problem5(1809);
}

method {:test} Test8() {
var r0 := problem5(1812);
}

method {:test} Test9() {
var r0 := problem5(1815);
}

