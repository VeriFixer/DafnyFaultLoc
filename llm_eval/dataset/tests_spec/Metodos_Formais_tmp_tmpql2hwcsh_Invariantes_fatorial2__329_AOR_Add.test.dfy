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
  while i <= n
    invariant 1 <= i <= n + 1
    invariant f == Fat(i - 1)
    decreases n - i
  {
    f := f + i;
    i := i + 1;
  }
  return f;
}


method {:test} Test0() {
var r0 := Fatorial(2);
expect r0 == Fat(2);
}

method {:test} Test1() {
var r0 := Fatorial(3);
expect r0 == Fat(3);
}

method {:test} Test2() {
var r0 := Fatorial(4);
expect r0 == Fat(4);
}

method {:test} Test3() {
var r0 := Fatorial(5);
expect r0 == Fat(5);
}

method {:test} Test4() {
var r0 := Fatorial(6);
expect r0 == Fat(6);
}

method {:test} Test5() {
var r0 := Fatorial(7);
expect r0 == Fat(7);
}

method {:test} Test6() {
var r0 := Fatorial(8);
expect r0 == Fat(8);
}

method {:test} Test7() {
var r0 := Fatorial(9);
expect r0 == Fat(9);
}

method {:test} Test8() {
var r0 := Fatorial(10);
expect r0 == Fat(10);
}

method {:test} Test9() {
var r0 := Fatorial(11);
expect r0 == Fat(11);
}

