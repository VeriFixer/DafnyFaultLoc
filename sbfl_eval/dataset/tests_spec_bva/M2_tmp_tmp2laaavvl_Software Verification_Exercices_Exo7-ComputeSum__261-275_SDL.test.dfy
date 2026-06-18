// M2_tmp_tmp2laaavvl_Software Verification_Exercices_Exo7-ComputeSum.dfy

function Sum(n: nat): nat
{
  if n == 0 then
    0
  else
    n + Sum(n - 1)
}

method {:testEntry} ComputeSum(n: nat) returns (s: nat)
  ensures s == Sum(n)
{
  s := 0;
  var i := 0;
  while i < n
    invariant 0 <= i <= n
    invariant s == Sum(i)
  {
    i := i + 1;
  }
}

method {:test} Test0() {
var r0 := ComputeSum(7721);
expect r0 == Sum(7721);
}
method {:test} Test1() {
var r0 := ComputeSum(100);
expect r0 == Sum(100);
}
method {:test} Test3() {
var r0 := ComputeSum(24);
expect r0 == Sum(24);
}

// REPEAT 1 - TIME: 5.8341494 s

method {:test} Test6() {
var r0 := ComputeSum(7722);
expect r0 == Sum(7722);
}

// REPEAT 2 - TIME: 6.8074868 s

method {:test} Test7() {
var r0 := ComputeSum(7723);
expect r0 == Sum(7723);
}

// REPEAT 3 - TIME: 7.550764 s

method {:test} Test8() {
var r0 := ComputeSum(7724);
expect r0 == Sum(7724);
}

// REPEAT 4 - TIME: 8.3763906 s

method {:test} Test9() {
var r0 := ComputeSum(7725);
expect r0 == Sum(7725);
}

// REPEAT 5 - TIME: 9.2045536 s
