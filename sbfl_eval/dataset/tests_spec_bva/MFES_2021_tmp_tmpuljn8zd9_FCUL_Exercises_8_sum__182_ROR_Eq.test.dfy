// MFES_2021_tmp_tmpuljn8zd9_FCUL_Exercises_8_sum.dfy

function calcSum(n: nat): nat
{
  n * (n - 1) / 2
}

method {:testEntry} sum(n: nat) returns (s: nat)
  ensures s == calcSum(n + 1)
{
  s := 0;
  var i := 0;
  while i == n
    invariant 0 <= i <= n
    invariant s == calcSum(i + 1)
    decreases n - i
  {
    i := i + 1;
    s := s + i;
  }
}

method {:test} Test0() {
var r0 := sum(0);
expect r0 == calcSum(0 + 1);
}
method {:test} Test1() {
var r0 := sum(100);
expect r0 == calcSum(100 + 1);
}

// REPEAT 1 - TIME: 6.259495 s

method {:test} Test5() {
var r0 := sum(101);
expect r0 == calcSum(101 + 1);
}

// REPEAT 2 - TIME: 7.2174938 s

method {:test} Test6() {
var r0 := sum(102);
expect r0 == calcSum(102 + 1);
}

// REPEAT 3 - TIME: 8.0132547 s

method {:test} Test7() {
var r0 := sum(103);
expect r0 == calcSum(103 + 1);
}

// REPEAT 4 - TIME: 8.9109873 s

method {:test} Test8() {
var r0 := sum(104);
expect r0 == calcSum(104 + 1);
}

// REPEAT 5 - TIME: 9.7134513 s
