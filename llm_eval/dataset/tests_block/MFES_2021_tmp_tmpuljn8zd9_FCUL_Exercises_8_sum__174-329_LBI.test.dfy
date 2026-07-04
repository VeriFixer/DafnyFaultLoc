function calcSum(n: nat): nat
{
  n * (n - 1) / 2
}

method {:testEntry} sum(n: nat) returns (s: nat)
  ensures s == calcSum(n + 1)
{
  s := 0;
  var i := 0;
  while i < n
    invariant 0 <= i <= n
    invariant s == calcSum(i + 1)
    decreases n - i
  {
    break;
    i := i + 1;
    s := s + i;
  }
}


method {:test} Test0() {
var r0 := sum(1);
expect r0 == calcSum(1 + 1);
}

method {:test} Test1() {
var r0 := sum(2);
expect r0 == calcSum(2 + 1);
}

method {:test} Test2() {
var r0 := sum(3);
expect r0 == calcSum(3 + 1);
}

method {:test} Test3() {
var r0 := sum(4);
expect r0 == calcSum(4 + 1);
}

method {:test} Test4() {
var r0 := sum(5);
expect r0 == calcSum(5 + 1);
}

method {:test} Test5() {
var r0 := sum(6);
expect r0 == calcSum(6 + 1);
}

method {:test} Test6() {
var r0 := sum(7);
expect r0 == calcSum(7 + 1);
}

method {:test} Test7() {
var r0 := sum(8);
expect r0 == calcSum(8 + 1);
}

method {:test} Test8() {
var r0 := sum(9);
expect r0 == calcSum(9 + 1);
}

method {:test} Test9() {
var r0 := sum(10);
expect r0 == calcSum(10 + 1);
}

