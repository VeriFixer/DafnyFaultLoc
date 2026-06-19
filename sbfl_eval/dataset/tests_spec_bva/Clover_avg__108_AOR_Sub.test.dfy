// Clover_avg.dfy

method {:testEntry} ComputeAvg(a: int, b: int) returns (avg: int)
  ensures avg == (a + b) / 2
{
  avg := a + b - 2;
}


method {:test} Test0() {
var r0 := ComputeAvg(0, 1);
expect r0 == (0 + 1) / 2;
}
method {:test} Test1() {
var r0 := ComputeAvg(-100, 101);
expect r0 == (-100 + 101) / 2;
}
method {:test} Test2() {
var r0 := ComputeAvg(100, -100);
expect r0 == (100 + -100) / 2;
}
method {:test} Test3() {
var r0 := ComputeAvg(101, -100);
expect r0 == (101 + -100) / 2;
}
method {:test} Test4() {
var r0 := ComputeAvg(-100, 100);
expect r0 == (-100 + 100) / 2;
}
method {:test} Test6() {
var r0 := ComputeAvg(-200, 0);
expect r0 == (-200 + 0) / 2;
}
method {:test} Test7() {
var r0 := ComputeAvg(200, 0);
expect r0 == (200 + 0) / 2;
}
method {:test} Test8() {
var r0 := ComputeAvg(0, 1236);
expect r0 == (0 + 1236) / 2;
}
method {:test} Test9() {
var r0 := ComputeAvg(0, 0);
expect r0 == (0 + 0) / 2;
}

// REPEAT 1 - TIME: 7.2118812 s

method {:test} Test10() {
var r0 := ComputeAvg(202, 1238);
expect r0 == (202 + 1238) / 2;
}

// REPEAT 2 - TIME: 8.0938767 s

method {:test} Test11() {
var r0 := ComputeAvg(204, 1240);
expect r0 == (204 + 1240) / 2;
}

// REPEAT 3 - TIME: 9.0323522 s

method {:test} Test12() {
var r0 := ComputeAvg(206, 1242);
expect r0 == (206 + 1242) / 2;
}

// REPEAT 4 - TIME: 9.8914201 s

method {:test} Test13() {
var r0 := ComputeAvg(208, 1244);
expect r0 == (208 + 1244) / 2;
}

// REPEAT 5 - TIME: 10.5551429 s
