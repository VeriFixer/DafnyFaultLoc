method {:testEntry} Mult(x: nat, y: nat) returns (r: nat)
  ensures r == x * y
{
  var m := x;
  var n := y;
  r := 0;
  while m > 0
    invariant m >= 0
    invariant m * n + r == x * y
  {
    m := m - 1;
  }
  return r;
}


method {:test} Test0() {
var r0 := Mult(0, 0);
expect r0 == 0 * 0;
}

method {:test} Test1() {
var r0 := Mult(1, 1);
expect r0 == 1 * 1;
}

method {:test} Test2() {
var r0 := Mult(2, 2);
expect r0 == 2 * 2;
}

method {:test} Test3() {
var r0 := Mult(3, 3);
expect r0 == 3 * 3;
}

method {:test} Test4() {
var r0 := Mult(4, 4);
expect r0 == 4 * 4;
}

method {:test} Test5() {
var r0 := Mult(5, 5);
expect r0 == 5 * 5;
}

method {:test} Test6() {
var r0 := Mult(6, 6);
expect r0 == 6 * 6;
}

method {:test} Test7() {
var r0 := Mult(7, 7);
expect r0 == 7 * 7;
}

method {:test} Test8() {
var r0 := Mult(8, 8);
expect r0 == 8 * 8;
}

method {:test} Test9() {
var r0 := Mult(9, 9);
expect r0 == 9 * 9;
}

