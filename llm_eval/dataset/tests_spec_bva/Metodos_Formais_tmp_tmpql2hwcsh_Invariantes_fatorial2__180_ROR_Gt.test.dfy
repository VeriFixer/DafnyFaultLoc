function Fat(n: nat): nat
{
  if n == 0 then
    1
  else
    n * Fat(n - 1)
}

method {:testEntry} Fatorial(n: nat) returns (f: nat)
  ensures f == Fat(n)
{
  f := 1;
  var i := 1;
  while i > n
    invariant 1 <= i <= n + 1
    invariant f == Fat(i - 1)
    decreases n - i
  {
    f := f * i;
    i := i + 1;
  }
  return f;
}


method {:test} Test0() {
var r0 := Fatorial(2);
expect r0 == Fat(2);
}
method {:test} Test1() {
var r0 := Fatorial(100);
expect r0 == Fat(100);
}

method {:test} Test6() {
var r0 := Fatorial(101);
expect r0 == Fat(101);
}

method {:test} Test7() {
var r0 := Fatorial(102);
expect r0 == Fat(102);
}

method {:test} Test8() {
var r0 := Fatorial(103);
expect r0 == Fat(103);
}

method {:test} Test9() {
var r0 := Fatorial(104);
expect r0 == Fat(104);
}

method {:test} Test10() {
var r0 := Fatorial(105);
expect r0 == Fat(105);
}

method {:test} Test11() {
var r0 := Fatorial(106);
expect r0 == Fat(106);
}

method {:test} Test12() {
var r0 := Fatorial(107);
expect r0 == Fat(107);
}

method {:test} Test13() {
var r0 := Fatorial(108);
expect r0 == Fat(108);
}

method {:test} Test14() {
var r0 := Fatorial(109);
expect r0 == Fat(109);
}

