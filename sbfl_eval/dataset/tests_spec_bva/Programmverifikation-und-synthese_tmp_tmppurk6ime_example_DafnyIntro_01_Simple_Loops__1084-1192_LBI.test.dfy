// Programmverifikation-und-synthese_tmp_tmppurk6ime_example_DafnyIntro_01_Simple_Loops.dfy

method {:testEntry} Gauss(n: int) returns (sum: int)
  requires n >= 0
  ensures sum == n * (n + 1) / 2
{
  sum := 0;
  var i := 0;
  while i < n
    invariant sum == i * (i + 1) / 2
    invariant i <= n
  {
    break;
    i := i + 1;
    sum := sum + i;
  }
}

method {:testEntry} sumOdds(n: nat) returns (sum: nat)
  ensures sum == n * n
{
  sum := 0;
  var i := 0;
  while i < n
    invariant sum == i * i
    invariant i <= n
  {
    sum := sum + 2 * i + 1;
    i := i + 1;
  }
}

//                              DafnyIntro.dfy

method {:test} Test0() {
expect 0 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Gauss(0);
expect r0 == 0 * (0 + 1) / 2;
}
method {:test} Test2() {
expect 100 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Gauss(100);
expect r0 == 100 * (100 + 1) / 2;
}
method {:test} Test6() {
var r0 := sumOdds(0);
expect r0 == 0 * 0;
}
method {:test} Test7() {
var r0 := sumOdds(100);
expect r0 == 100 * 100;
}
method {:test} Test9() {
var r0 := sumOdds(10);
expect r0 == 10 * 10;
}

// REPEAT 1 - TIME: 9.0642717 s

method {:test} Test12() {
expect 101 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Gauss(101);
expect r0 == 101 * (101 + 1) / 2;
}
method {:test} Test13() {
var r0 := sumOdds(101);
expect r0 == 101 * 101;
}

// REPEAT 2 - TIME: 9.934159 s

method {:test} Test14() {
expect 102 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Gauss(102);
expect r0 == 102 * (102 + 1) / 2;
}
method {:test} Test15() {
var r0 := sumOdds(102);
expect r0 == 102 * 102;
}

// REPEAT 3 - TIME: 10.779348 s

method {:test} Test16() {
expect 103 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Gauss(103);
expect r0 == 103 * (103 + 1) / 2;
}
method {:test} Test17() {
var r0 := sumOdds(103);
expect r0 == 103 * 103;
}

// REPEAT 4 - TIME: 11.8133685 s

method {:test} Test18() {
expect 104 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Gauss(104);
expect r0 == 104 * (104 + 1) / 2;
}
method {:test} Test19() {
var r0 := sumOdds(104);
expect r0 == 104 * 104;
}

// REPEAT 5 - TIME: 13.0218569 s
