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
var r0 := ComputeSum(40);
expect r0 == Sum(40);
}

method {:test} Test1() {
var r0 := ComputeSum(41);
expect r0 == Sum(41);
}

method {:test} Test2() {
var r0 := ComputeSum(42);
expect r0 == Sum(42);
}

method {:test} Test3() {
var r0 := ComputeSum(43);
expect r0 == Sum(43);
}

method {:test} Test4() {
var r0 := ComputeSum(44);
expect r0 == Sum(44);
}

method {:test} Test5() {
var r0 := ComputeSum(45);
expect r0 == Sum(45);
}

method {:test} Test6() {
var r0 := ComputeSum(46);
expect r0 == Sum(46);
}

method {:test} Test7() {
var r0 := ComputeSum(47);
expect r0 == Sum(47);
}

method {:test} Test8() {
var r0 := ComputeSum(48);
expect r0 == Sum(48);
}

method {:test} Test9() {
var r0 := ComputeSum(49);
expect r0 == Sum(49);
}

