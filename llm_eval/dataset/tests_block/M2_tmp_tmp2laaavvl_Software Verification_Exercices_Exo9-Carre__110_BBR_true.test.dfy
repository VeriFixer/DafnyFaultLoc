method {:testEntry} Carre(a: nat) returns (c: nat)
  ensures c == a * a
{
  var i := 0;
  c := 0;
  while true
    invariant 0 <= i <= a
    invariant c == i * i
    decreases a - i
  {
    c := c + 2 * i + 1;
    i := i + 1;
  }
}


method {:test} Test0() {
var r0 := Carre(1);
expect r0 == 1 * 1;
}

method {:test} Test1() {
var r0 := Carre(2);
expect r0 == 2 * 2;
}

method {:test} Test2() {
var r0 := Carre(3);
expect r0 == 3 * 3;
}

method {:test} Test3() {
var r0 := Carre(4);
expect r0 == 4 * 4;
}

method {:test} Test4() {
var r0 := Carre(5);
expect r0 == 5 * 5;
}

method {:test} Test5() {
var r0 := Carre(6);
expect r0 == 6 * 6;
}

method {:test} Test6() {
var r0 := Carre(7);
expect r0 == 7 * 7;
}

method {:test} Test7() {
var r0 := Carre(8);
expect r0 == 8 * 8;
}

method {:test} Test8() {
var r0 := Carre(9);
expect r0 == 9 * 9;
}

method {:test} Test9() {
var r0 := Carre(10);
expect r0 == 10 * 10;
}

