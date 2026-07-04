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
var r0 := ComputeSum(1);
expect r0 == Sum(1);
}

method {:test} Test1() {
var r0 := ComputeSum(2);
expect r0 == Sum(2);
}

method {:test} Test2() {
var r0 := ComputeSum(3);
expect r0 == Sum(3);
}

method {:test} Test3() {
var r0 := ComputeSum(4);
expect r0 == Sum(4);
}

method {:test} Test4() {
var r0 := ComputeSum(5);
expect r0 == Sum(5);
}

method {:test} Test5() {
var r0 := ComputeSum(6);
expect r0 == Sum(6);
}

method {:test} Test6() {
var r0 := ComputeSum(7);
expect r0 == Sum(7);
}

method {:test} Test7() {
var r0 := ComputeSum(8);
expect r0 == Sum(8);
}

method {:test} Test8() {
var r0 := ComputeSum(9);
expect r0 == Sum(9);
}

method {:test} Test9() {
var r0 := ComputeSum(10);
expect r0 == Sum(10);
}

