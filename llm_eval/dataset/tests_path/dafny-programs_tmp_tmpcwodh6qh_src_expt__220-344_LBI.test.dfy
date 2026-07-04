function Expt(b: int, n: nat): int
  requires n >= 0
{
  if n == 0 then
    1
  else
    b * Expt(b, n - 1)
}

method {:testEntry} expt(b: int, n: nat) returns (res: int)
  ensures res == Expt(b, n)
{
  var i := 1;
  res := 1;
  while i < n + 1
    invariant 0 < i <= n + 1
    invariant res == Expt(b, i - 1)
  {
    break;
    res := res * b;
    i := i + 1;
  }
}

lemma {:induction a} distributive(x: int, a: nat, b: nat)
  ensures Expt(x, a) * Expt(x, b) == Expt(x, a + b)


method {:test} Test0() {
var r0 := expt(25, 0);
expect r0 == Expt(25, 0);
}

method {:test} Test1() {
var r0 := expt(26, 283);
expect r0 == Expt(26, 283);
}

method {:test} Test2() {
var r0 := expt(27, 284);
expect r0 == Expt(27, 284);
}

method {:test} Test3() {
var r0 := expt(28, 285);
expect r0 == Expt(28, 285);
}

method {:test} Test4() {
var r0 := expt(29, 286);
expect r0 == Expt(29, 286);
}

method {:test} Test5() {
var r0 := expt(30, 287);
expect r0 == Expt(30, 287);
}

method {:test} Test6() {
var r0 := expt(31, 288);
expect r0 == Expt(31, 288);
}

method {:test} Test7() {
var r0 := expt(32, 289);
expect r0 == Expt(32, 289);
}

method {:test} Test8() {
var r0 := expt(33, 290);
expect r0 == Expt(33, 290);
}

method {:test} Test9() {
var r0 := expt(34, 291);
expect r0 == Expt(34, 291);
}

