function Sum(n: nat): nat
{
  if n == 0 then
    0
  else
    n + Sum(n - 1)
}

method {:testEntry} ComputeSum(n: nat) returns (s: nat)
  ensures s == Sum(n)
{
  s := 0;
  var i := 0;
  while i < n
    invariant 0 <= i <= n
    invariant s == Sum(i)
  {
    break;
    s := s + i + 1;
    i := i + 1;
  }
}


method {:test} Test0() {
var r0 := ComputeSum(7721);
expect r0 == Sum(7721);
}

method {:test} Test1() {
var r0 := ComputeSum(7722);
expect r0 == Sum(7722);
}

method {:test} Test2() {
var r0 := ComputeSum(7723);
expect r0 == Sum(7723);
}

method {:test} Test3() {
var r0 := ComputeSum(7724);
expect r0 == Sum(7724);
}

method {:test} Test4() {
var r0 := ComputeSum(7725);
expect r0 == Sum(7725);
}

method {:test} Test5() {
var r0 := ComputeSum(7726);
expect r0 == Sum(7726);
}

method {:test} Test6() {
var r0 := ComputeSum(7727);
expect r0 == Sum(7727);
}

method {:test} Test7() {
var r0 := ComputeSum(7728);
expect r0 == Sum(7728);
}

method {:test} Test8() {
var r0 := ComputeSum(7729);
expect r0 == Sum(7729);
}

method {:test} Test9() {
var r0 := ComputeSum(7730);
expect r0 == Sum(7730);
}

