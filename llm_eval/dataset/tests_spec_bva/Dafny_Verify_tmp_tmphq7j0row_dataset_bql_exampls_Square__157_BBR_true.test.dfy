method {:testEntry} square(n: int) returns (r: int)
  requires 0 <= n
  ensures r == n * n
{
  var x: int;
  var i: int;
  r := 0;
  i := 0;
  x := 1;
  while true
    invariant i <= n
    invariant r == i * i
    invariant x == 2 * i + 1
  {
    r := r + x;
    x := x + 2;
    i := i + 1;
  }
}


method {:test} Test0() {
expect 0 <= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := square(0);
expect r0 == 0 * 0;
}
method {:test} Test2() {
expect 0 <= 100, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := square(100);
expect r0 == 100 * 100;
}
method {:test} Test4() {
expect 0 <= 10, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := square(10);
expect r0 == 10 * 10;
}

method {:test} Test7() {
expect 0 <= 101, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := square(101);
expect r0 == 101 * 101;
}

method {:test} Test8() {
expect 0 <= 102, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := square(102);
expect r0 == 102 * 102;
}

method {:test} Test9() {
expect 0 <= 103, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := square(103);
expect r0 == 103 * 103;
}

method {:test} Test10() {
expect 0 <= 104, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := square(104);
expect r0 == 104 * 104;
}

method {:test} Test11() {
expect 0 <= 105, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := square(105);
expect r0 == 105 * 105;
}

method {:test} Test12() {
expect 0 <= 106, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := square(106);
expect r0 == 106 * 106;
}

method {:test} Test13() {
expect 0 <= 107, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := square(107);
expect r0 == 107 * 107;
}

method {:test} Test14() {
expect 0 <= 108, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := square(108);
expect r0 == 108 * 108;
}

method {:test} Test15() {
expect 0 <= 109, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := square(109);
expect r0 == 109 * 109;
}

