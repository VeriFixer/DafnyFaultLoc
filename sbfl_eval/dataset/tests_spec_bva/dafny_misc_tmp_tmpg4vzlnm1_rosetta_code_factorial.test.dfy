// recursive definition of factorial
function Factorial(n: nat): nat {
  if n == 0 then 1 else n * Factorial(n - 1)
}

// iterative implementation of factorial
method {:testEntry} IterativeFactorial(n: nat) returns (result: nat)
  ensures result == Factorial(n)
{
  result := 1;
  var i := 1;
  while i <= n
    invariant i <= n + 1
    invariant result == Factorial(i - 1)
  {
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

// REPEAT 1 - TIME: 5.4899404 s

method {:test} Test6() {
var r0 := IterativeFactorial(101);
expect r0 == Factorial(101);
}

// REPEAT 2 - TIME: 6.2794795 s

method {:test} Test7() {
var r0 := IterativeFactorial(102);
expect r0 == Factorial(102);
}

// REPEAT 3 - TIME: 6.9327321 s

method {:test} Test8() {
var r0 := IterativeFactorial(103);
expect r0 == Factorial(103);
}

// REPEAT 4 - TIME: 7.7221686 s

method {:test} Test9() {
var r0 := IterativeFactorial(104);
expect r0 == Factorial(104);
}

// REPEAT 5 - TIME: 8.3601261 s
