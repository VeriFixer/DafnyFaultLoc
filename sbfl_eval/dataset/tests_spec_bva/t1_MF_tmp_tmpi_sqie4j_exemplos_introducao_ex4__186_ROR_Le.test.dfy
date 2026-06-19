// t1_MF_tmp_tmpi_sqie4j_exemplos_introducao_ex4.dfy

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
  while i <= n
    invariant 0 <= i <= n
    invariant r == Fat(i)
  {
    i := i + 1;
    r := r * i;
  }
}


method {:test} Test0() {
var r0 := Fatorial(2);
expect r0 == Fat(2);
}
method {:test} Test1() {
var r0 := Fatorial(100);
expect r0 == Fat(100);
}

// REPEAT 1 - TIME: 5.9946189 s

method {:test} Test6() {
var r0 := Fatorial(101);
expect r0 == Fat(101);
}

// REPEAT 2 - TIME: 6.8530705 s

method {:test} Test7() {
var r0 := Fatorial(102);
expect r0 == Fat(102);
}

// REPEAT 3 - TIME: 7.6677722 s

method {:test} Test8() {
var r0 := Fatorial(103);
expect r0 == Fat(103);
}

// REPEAT 4 - TIME: 8.3928527 s

method {:test} Test9() {
var r0 := Fatorial(104);
expect r0 == Fat(104);
}

// REPEAT 5 - TIME: 9.0514221 s
