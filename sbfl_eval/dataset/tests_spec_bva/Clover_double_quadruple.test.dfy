method {:testEntry} DoubleQuadruple(x: int) returns (a: int, b: int)
  ensures a == 2 * x && b == 4 * x
{
  a := 2 * x;
  b := 2 * a;
}

method {:test} Test0() {
var r0, r1 := DoubleQuadruple(0);
expect r0 == 2 * 0 && r1 == 4 * 0;
}
method {:test} Test1() {
var r0, r1 := DoubleQuadruple(-100);
expect r0 == 2 * -100 && r1 == 4 * -100;
}
method {:test} Test2() {
var r0, r1 := DoubleQuadruple(100);
expect r0 == 2 * 100 && r1 == 4 * 100;
}

// REPEAT 1 - TIME: 5.2623587 s

method {:test} Test7() {
var r0, r1 := DoubleQuadruple(101);
expect r0 == 2 * 101 && r1 == 4 * 101;
}

// REPEAT 2 - TIME: 6.1647433 s

method {:test} Test8() {
var r0, r1 := DoubleQuadruple(102);
expect r0 == 2 * 102 && r1 == 4 * 102;
}

// REPEAT 3 - TIME: 7.0557088 s

method {:test} Test9() {
var r0, r1 := DoubleQuadruple(103);
expect r0 == 2 * 103 && r1 == 4 * 103;
}

// REPEAT 4 - TIME: 7.9015895 s

method {:test} Test10() {
var r0, r1 := DoubleQuadruple(104);
expect r0 == 2 * 104 && r1 == 4 * 104;
}

// REPEAT 5 - TIME: 8.7541818 s
