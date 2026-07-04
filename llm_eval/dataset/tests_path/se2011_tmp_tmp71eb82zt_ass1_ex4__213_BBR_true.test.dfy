method {:testEntry} Eval(x: int) returns (r: int)
  requires x >= 0
  ensures r == x * x
{
  var y: int := x;
  var z: int := 0;
  while true
    invariant 0 <= y <= x && z == x * (x - y)
    decreases y
  {
    z := z + x;
    y := y - 1;
  }
  return z;
}


method {:test} Test0() {
expect 0 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Eval(0);
expect r0 == 0 * 0;
}

method {:test} Test1() {
expect 1 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Eval(1);
expect r0 == 1 * 1;
}

method {:test} Test2() {
expect 2 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Eval(2);
expect r0 == 2 * 2;
}

method {:test} Test3() {
expect 3 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Eval(3);
expect r0 == 3 * 3;
}

method {:test} Test4() {
expect 4 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Eval(4);
expect r0 == 4 * 4;
}

method {:test} Test5() {
expect 5 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Eval(5);
expect r0 == 5 * 5;
}

method {:test} Test6() {
expect 6 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Eval(6);
expect r0 == 6 * 6;
}

method {:test} Test7() {
expect 7 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Eval(7);
expect r0 == 7 * 7;
}

method {:test} Test8() {
expect 8 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Eval(8);
expect r0 == 8 * 8;
}

method {:test} Test9() {
expect 9 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Eval(9);
expect r0 == 9 * 9;
}

