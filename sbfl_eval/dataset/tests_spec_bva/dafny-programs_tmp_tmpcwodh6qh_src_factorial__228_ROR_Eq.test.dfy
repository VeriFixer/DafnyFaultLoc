// dafny-programs_tmp_tmpcwodh6qh_src_factorial.dfy

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
  while i == n + 1
    invariant 0 < i <= n + 1
    invariant res == fact(i - 1)
  {
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

// REPEAT 1 - TIME: 5.7012159 s

method {:test} Test6() {
var r0 := factorial(101);
expect r0 == fact(101);
}

// REPEAT 2 - TIME: 6.5195404 s

method {:test} Test7() {
var r0 := factorial(102);
expect r0 == fact(102);
}

// REPEAT 3 - TIME: 7.3112336 s

method {:test} Test8() {
var r0 := factorial(103);
expect r0 == fact(103);
}

// REPEAT 4 - TIME: 8.1035157 s

method {:test} Test9() {
var r0 := factorial(104);
expect r0 == fact(104);
}

// REPEAT 5 - TIME: 8.8180005 s
