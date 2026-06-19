// Clover_multi_return.dfy

method {:testEntry} MultipleReturns(x: int, y: int)
    returns (more: int, less: int)
  ensures more == x + y
  ensures less == x - y
{
  more := -(x + y);
  less := x - y;
}


method {:test} Test0() {
var r0, r1 := MultipleReturns(0, 0);
expect r0 == 0 + 0;
expect r1 == 0 - 0;
}
method {:test} Test1() {
var r0, r1 := MultipleReturns(-100, 0);
expect r0 == -100 + 0;
expect r1 == -100 - 0;
}
method {:test} Test2() {
var r0, r1 := MultipleReturns(100, 0);
expect r0 == 100 + 0;
expect r1 == 100 - 0;
}
method {:test} Test3() {
var r0, r1 := MultipleReturns(0, -100);
expect r0 == 0 + -100;
expect r1 == 0 - -100;
}
method {:test} Test4() {
var r0, r1 := MultipleReturns(0, 100);
expect r0 == 0 + 100;
expect r1 == 0 - 100;
}

// REPEAT 1 - TIME: 6.569738 s

method {:test} Test13() {
var r0, r1 := MultipleReturns(101, 101);
expect r0 == 101 + 101;
expect r1 == 101 - 101;
}

// REPEAT 2 - TIME: 7.0942823 s

method {:test} Test14() {
var r0, r1 := MultipleReturns(102, 102);
expect r0 == 102 + 102;
expect r1 == 102 - 102;
}

// REPEAT 3 - TIME: 7.5877442 s

method {:test} Test15() {
var r0, r1 := MultipleReturns(103, 103);
expect r0 == 103 + 103;
expect r1 == 103 - 103;
}

// REPEAT 4 - TIME: 8.0402306 s

method {:test} Test16() {
var r0, r1 := MultipleReturns(104, 104);
expect r0 == 104 + 104;
expect r1 == 104 - 104;
}

// REPEAT 5 - TIME: 8.4601702 s
