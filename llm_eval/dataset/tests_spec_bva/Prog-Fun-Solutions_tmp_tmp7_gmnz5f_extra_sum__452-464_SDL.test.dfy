ghost function sum(n: nat): int
{
  if n == 0 then
    0
  else
    n + sum(n - 1)
}

method {:testEntry} Sum(n: nat) returns (s: int)
  ensures s == sum(n)
{
  var x: nat := 0;
  var y: nat := 1;
  var k: nat := n;
  while k > 0
    invariant sum(n) == x + y * sum(k)
    invariant 0 <= k <= n
    decreases k
  {
    assert sum(n) == x + y * sum(k);
    assert sum(n) == x + y * (k + sum(k - 1));
    assert sum(n) == x + y * k + y * sum(k - 1);
    assert sum(n) == x + y * sum(k - 1);
    assert sum(n) == x + y * sum(k - 1);
    k := k - 1;
    assert sum(n) == x + y * sum(k);
  }
  assert k == 0;
  assert sum(n) == x + y * sum(0);
  assert sum(n) == x + y * 0;
  s := x;
  assert sum(n) == s;
}


method {:test} Test0() {
var r0 := Sum(7721);
}
method {:test} Test1() {
var r0 := Sum(100);
}

method {:test} Test7() {
var r0 := Sum(7722);
}

method {:test} Test8() {
var r0 := Sum(7723);
}

method {:test} Test9() {
var r0 := Sum(7724);
}

method {:test} Test10() {
var r0 := Sum(7725);
}

method {:test} Test11() {
var r0 := Sum(7726);
}

method {:test} Test12() {
var r0 := Sum(7727);
}

method {:test} Test13() {
var r0 := Sum(7728);
}

method {:test} Test14() {
var r0 := Sum(7729);
}

method {:test} Test15() {
var r0 := Sum(7730);
}

