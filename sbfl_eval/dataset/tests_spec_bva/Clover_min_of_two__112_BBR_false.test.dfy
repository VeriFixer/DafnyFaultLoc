// Clover_min_of_two.dfy

method {:testEntry} Min(x: int, y: int) returns (z: int)
  ensures x <= y ==> z == x
  ensures x > y ==> z == y
{
  if false {
    return x;
  } else {
    return y;
  }
}

method {:test} Test0() {
var r0 := Min(1, 0);
expect 1 <= 0 ==> r0 == 1;
expect 1 > 0 ==> r0 == 0;
}
method {:test} Test1() {
var r0 := Min(-100, -101);
expect -100 <= -101 ==> r0 == -100;
expect -100 > -101 ==> r0 == -101;
}
method {:test} Test2() {
var r0 := Min(100, 0);
expect 100 <= 0 ==> r0 == 100;
expect 100 > 0 ==> r0 == 0;
}
method {:test} Test3() {
var r0 := Min(0, -100);
expect 0 <= -100 ==> r0 == 0;
expect 0 > -100 ==> r0 == -100;
}
method {:test} Test4() {
var r0 := Min(101, 100);
expect 101 <= 100 ==> r0 == 101;
expect 101 > 100 ==> r0 == 100;
}
method {:test} Test10() {
var r0 := Min(0, 0);
expect 0 <= 0 ==> r0 == 0;
expect 0 > 0 ==> r0 == 0;
}
method {:test} Test11() {
var r0 := Min(-100, 0);
expect -100 <= 0 ==> r0 == -100;
expect -100 > 0 ==> r0 == 0;
}
method {:test} Test12() {
var r0 := Min(100, 100);
expect 100 <= 100 ==> r0 == 100;
expect 100 > 100 ==> r0 == 100;
}
method {:test} Test13() {
var r0 := Min(-100, -100);
expect -100 <= -100 ==> r0 == -100;
expect -100 > -100 ==> r0 == -100;
}
method {:test} Test14() {
var r0 := Min(0, 100);
expect 0 <= 100 ==> r0 == 0;
expect 0 > 100 ==> r0 == 100;
}

// REPEAT 1 - TIME: 15.8793803 s

method {:test} Test20() {
var r0 := Min(102, 101);
expect 102 <= 101 ==> r0 == 102;
expect 102 > 101 ==> r0 == 101;
}
method {:test} Test21() {
var r0 := Min(102, 102);
expect 102 <= 102 ==> r0 == 102;
expect 102 > 102 ==> r0 == 102;
}

// REPEAT 2 - TIME: 17.4663292 s

method {:test} Test22() {
var r0 := Min(104, 103);
expect 104 <= 103 ==> r0 == 104;
expect 104 > 103 ==> r0 == 103;
}
method {:test} Test23() {
var r0 := Min(103, 103);
expect 103 <= 103 ==> r0 == 103;
expect 103 > 103 ==> r0 == 103;
}

// REPEAT 3 - TIME: 18.9528156 s

method {:test} Test24() {
var r0 := Min(105, 104);
expect 105 <= 104 ==> r0 == 105;
expect 105 > 104 ==> r0 == 104;
}
method {:test} Test25() {
var r0 := Min(105, 105);
expect 105 <= 105 ==> r0 == 105;
expect 105 > 105 ==> r0 == 105;
}

// REPEAT 4 - TIME: 20.3314451 s

method {:test} Test26() {
var r0 := Min(107, 106);
expect 107 <= 106 ==> r0 == 107;
expect 107 > 106 ==> r0 == 106;
}
method {:test} Test27() {
var r0 := Min(106, 106);
expect 106 <= 106 ==> r0 == 106;
expect 106 > 106 ==> r0 == 106;
}

// REPEAT 5 - TIME: 21.6641906 s
