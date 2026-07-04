function fact(n: nat): nat
  ensures fact(n) >= 1
{
  if n == 0 then
    1
  else
    n * fact(n - 1)
}

method {:testEntry} factorial(n: nat) returns (res: nat)
  ensures res == fact(n)
{
  var i := 1;
  res := 1;
  while i < n + 1
    invariant 0 < i <= n + 1
    invariant res == fact(i - 1)
  {
    break;
    res := i * res;
    i := i + 1;
  }
}


method {:test} Test0() {
var r0 := factorial(2);
expect r0 == fact(2);
}
method {:test} Test1() {
var r0 := factorial(100);
expect r0 == fact(100);
}
method {:test} Test3() {
var r0 := factorial(5);
expect r0 == fact(5);
}

method {:test} Test6() {
var r0 := factorial(101);
expect r0 == fact(101);
}

method {:test} Test7() {
var r0 := factorial(102);
expect r0 == fact(102);
}

method {:test} Test8() {
var r0 := factorial(103);
expect r0 == fact(103);
}

method {:test} Test9() {
var r0 := factorial(104);
expect r0 == fact(104);
}

method {:test} Test10() {
var r0 := factorial(105);
expect r0 == fact(105);
}

method {:test} Test11() {
var r0 := factorial(106);
expect r0 == fact(106);
}

method {:test} Test12() {
var r0 := factorial(107);
expect r0 == fact(107);
}

method {:test} Test13() {
var r0 := factorial(108);
expect r0 == fact(108);
}

method {:test} Test14() {
var r0 := factorial(109);
expect r0 == fact(109);
}

