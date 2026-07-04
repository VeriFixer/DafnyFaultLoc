method {:testEntry} Mult(x: nat, y: nat) returns (r: nat)
  ensures r == x * y
{
  var m := x;
  var n := y;
  r := 0;
  while m == 0
    invariant m >= 0
    invariant m * n + r == x * y
  {
    r := r + n;
    m := m - 1;
  }
  return r;
}


method {:test} Test0() {
var r0 := Mult(0, 0);
expect r0 == 0 * 0;
}
method {:test} Test1() {
var r0 := Mult(100, 38);
expect r0 == 100 * 38;
}
method {:test} Test2() {
var r0 := Mult(38, 100);
expect r0 == 38 * 100;
}
method {:test} Test4() {
var r0 := Mult(1, 100);
expect r0 == 1 * 100;
}

method {:test} Test7() {
var r0 := Mult(101, 101);
expect r0 == 101 * 101;
}

method {:test} Test8() {
var r0 := Mult(102, 102);
expect r0 == 102 * 102;
}

method {:test} Test9() {
var r0 := Mult(103, 103);
expect r0 == 103 * 103;
}

method {:test} Test10() {
var r0 := Mult(104, 104);
expect r0 == 104 * 104;
}

method {:test} Test11() {
var r0 := Mult(105, 105);
expect r0 == 105 * 105;
}

method {:test} Test12() {
var r0 := Mult(106, 106);
expect r0 == 106 * 106;
}

method {:test} Test13() {
var r0 := Mult(107, 107);
expect r0 == 107 * 107;
}

method {:test} Test14() {
var r0 := Mult(108, 108);
expect r0 == 108 * 108;
}

method {:test} Test15() {
var r0 := Mult(109, 109);
expect r0 == 109 * 109;
}

