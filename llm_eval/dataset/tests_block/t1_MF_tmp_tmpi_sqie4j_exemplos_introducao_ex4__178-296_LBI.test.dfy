function Fat(n: nat): nat
{
  if n == 0 then
    1
  else
    n * Fat(n - 1)
}

method {:testEntry} Fatorial(n: nat) returns (r: nat)
  ensures r == Fat(n)
{
  r := 1;
  var i := 0;
  while i < n
    invariant 0 <= i <= n
    invariant r == Fat(i)
  {
    break;
    i := i + 1;
    r := r * i;
  }
}


method {:test} Test0() {
var r0 := Fatorial(1);
expect r0 == Fat(1);
}

method {:test} Test1() {
var r0 := Fatorial(2);
expect r0 == Fat(2);
}

method {:test} Test2() {
var r0 := Fatorial(3);
expect r0 == Fat(3);
}

method {:test} Test3() {
var r0 := Fatorial(4);
expect r0 == Fat(4);
}

method {:test} Test4() {
var r0 := Fatorial(5);
expect r0 == Fat(5);
}

method {:test} Test5() {
var r0 := Fatorial(6);
expect r0 == Fat(6);
}

method {:test} Test6() {
var r0 := Fatorial(7);
expect r0 == Fat(7);
}

method {:test} Test7() {
var r0 := Fatorial(8);
expect r0 == Fat(8);
}

method {:test} Test8() {
var r0 := Fatorial(9);
expect r0 == Fat(9);
}

method {:test} Test9() {
var r0 := Fatorial(10);
expect r0 == Fat(10);
}

