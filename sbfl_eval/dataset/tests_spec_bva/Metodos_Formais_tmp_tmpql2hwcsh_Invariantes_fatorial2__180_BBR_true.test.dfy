// Metodos_Formais_tmp_tmpql2hwcsh_Invariantes_fatorial2.dfy

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
  while true
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

// REPEAT 1 - TIME: 6.011644 s

method {:test} Test6() {
var r0 := Fatorial(101);
expect r0 == Fat(101);
}

// REPEAT 2 - TIME: 7.0493121 s

method {:test} Test7() {
var r0 := Fatorial(102);
expect r0 == Fat(102);
}

// REPEAT 3 - TIME: 8.1097698 s

method {:test} Test8() {
var r0 := Fatorial(103);
expect r0 == Fat(103);
}

// REPEAT 4 - TIME: 8.9670815 s

method {:test} Test9() {
var r0 := Fatorial(104);
expect r0 == Fat(104);
}

// REPEAT 5 - TIME: 9.6921582 s
