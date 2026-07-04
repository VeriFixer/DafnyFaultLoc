function Factorial(n: nat): nat
{
  if n == 0 then
    1
  else
    n * Factorial(n - 1)
}

method {:testEntry} IterativeFactorial(n: nat) returns (result: nat)
  ensures result == Factorial(n)
{
  result := 1;
  var i := 1;
  while i <= n
    invariant i <= n + 1
    invariant result == Factorial(i - 1)
  {
    break;
    result := result * i;
    i := i + 1;
  }
}


method {:test} Test0() {
var r0 := IterativeFactorial(2);
expect r0 == Factorial(2);
}
method {:test} Test1() {
var r0 := IterativeFactorial(100);
expect r0 == Factorial(100);
}

method {:test} Test6() {
var r0 := IterativeFactorial(101);
expect r0 == Factorial(101);
}

method {:test} Test7() {
var r0 := IterativeFactorial(102);
expect r0 == Factorial(102);
}

method {:test} Test8() {
var r0 := IterativeFactorial(103);
expect r0 == Factorial(103);
}

method {:test} Test9() {
var r0 := IterativeFactorial(104);
expect r0 == Factorial(104);
}

method {:test} Test10() {
var r0 := IterativeFactorial(105);
expect r0 == Factorial(105);
}

method {:test} Test11() {
var r0 := IterativeFactorial(106);
expect r0 == Factorial(106);
}

method {:test} Test12() {
var r0 := IterativeFactorial(107);
expect r0 == Factorial(107);
}

method {:test} Test13() {
var r0 := IterativeFactorial(108);
expect r0 == Factorial(108);
}

method {:test} Test14() {
var r0 := IterativeFactorial(109);
expect r0 == Factorial(109);
}

