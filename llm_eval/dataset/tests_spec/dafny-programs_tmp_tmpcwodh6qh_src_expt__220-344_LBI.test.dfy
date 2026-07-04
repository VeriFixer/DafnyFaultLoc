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
var r0 := expt(0, 5922);
expect r0 == Expt(0, 5922);
}

method {:test} Test1() {
var r0 := expt(1, 5923);
expect r0 == Expt(1, 5923);
}

method {:test} Test2() {
var r0 := expt(2, 5924);
expect r0 == Expt(2, 5924);
}

method {:test} Test3() {
var r0 := expt(284, 5925);
expect r0 == Expt(284, 5925);
}

method {:test} Test4() {
var r0 := expt(285, 5926);
expect r0 == Expt(285, 5926);
}

method {:test} Test5() {
var r0 := expt(286, 5927);
expect r0 == Expt(286, 5927);
}

method {:test} Test6() {
var r0 := expt(287, 5928);
expect r0 == Expt(287, 5928);
}

method {:test} Test7() {
var r0 := expt(288, 5929);
expect r0 == Expt(288, 5929);
}

method {:test} Test8() {
var r0 := expt(289, 5930);
expect r0 == Expt(289, 5930);
}

method {:test} Test9() {
var r0 := expt(290, 5931);
expect r0 == Expt(290, 5931);
}

