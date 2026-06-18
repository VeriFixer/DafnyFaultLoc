// dafny-synthesis_task_id_58.dfy

method {:testEntry} HasOppositeSign(a: int, b: int) returns (result: bool)
  ensures result <==> (a < 0 && b > 0) || (a > 0 && b < 0)
{
  result := a < 0 && b > 0 ==> a > 0 && b < 0;
}


method {:testEntry} HasOppositeSign(a: int, b: int) returns (result: bool)
  ensures result <==> (a < 0 && b > 0) || (a > 0 && b < 0)
{
  result := (a < 0 && b > 0) || (a > 0 && b < 0);
}

method {:test} Test0() {
var r0 := HasOppositeSign(-1, 1);
expect r0 <==> (-1 < 0 && 1 > 0) || (-1 > 0 && 1 < 0);
}
method {:test} Test1() {
var r0 := HasOppositeSign(-100, 1);
expect r0 <==> (-100 < 0 && 1 > 0) || (-100 > 0 && 1 < 0);
}
method {:test} Test4() {
var r0 := HasOppositeSign(-1, 100);
expect r0 <==> (-1 < 0 && 100 > 0) || (-1 > 0 && 100 < 0);
}
method {:test} Test9() {
var r0 := HasOppositeSign(1, -1);
expect r0 <==> (1 < 0 && -1 > 0) || (1 > 0 && -1 < 0);
}
method {:test} Test11() {
var r0 := HasOppositeSign(100, -1);
expect r0 <==> (100 < 0 && -1 > 0) || (100 > 0 && -1 < 0);
}
method {:test} Test12() {
var r0 := HasOppositeSign(1, -100);
expect r0 <==> (1 < 0 && -100 > 0) || (1 > 0 && -100 < 0);
}
method {:test} Test18() {
var r0 := HasOppositeSign(0, 0);
expect r0 <==> (0 < 0 && 0 > 0) || (0 > 0 && 0 < 0);
}
method {:test} Test19() {
var r0 := HasOppositeSign(0, -100);
expect r0 <==> (0 < 0 && -100 > 0) || (0 > 0 && -100 < 0);
}
method {:test} Test20() {
var r0 := HasOppositeSign(0, 100);
expect r0 <==> (0 < 0 && 100 > 0) || (0 > 0 && 100 < 0);
}
method {:test} Test25() {
var r0 := HasOppositeSign(1, 0);
expect r0 <==> (1 < 0 && 0 > 0) || (1 > 0 && 0 < 0);
}
method {:test} Test26() {
var r0 := HasOppositeSign(100, 0);
expect r0 <==> (100 < 0 && 0 > 0) || (100 > 0 && 0 < 0);
}
method {:test} Test28() {
var r0 := HasOppositeSign(1, 100);
expect r0 <==> (1 < 0 && 100 > 0) || (1 > 0 && 100 < 0);
}
method {:test} Test33() {
var r0 := HasOppositeSign(-1, 0);
expect r0 <==> (-1 < 0 && 0 > 0) || (-1 > 0 && 0 < 0);
}
method {:test} Test34() {
var r0 := HasOppositeSign(-100, 0);
expect r0 <==> (-100 < 0 && 0 > 0) || (-100 > 0 && 0 < 0);
}
method {:test} Test35() {
var r0 := HasOppositeSign(-1, -100);
expect r0 <==> (-1 < 0 && -100 > 0) || (-1 > 0 && -100 < 0);
}

// REPEAT 1 - TIME: 19.8378034 s

method {:test} Test41() {
var r0 := HasOppositeSign(-2, 101);
expect r0 <==> (-2 < 0 && 101 > 0) || (-2 > 0 && 101 < 0);
}
method {:test} Test42() {
var r0 := HasOppositeSign(101, -2);
expect r0 <==> (101 < 0 && -2 > 0) || (101 > 0 && -2 < 0);
}
method {:test} Test43() {
var r0 := HasOppositeSign(101, 101);
expect r0 <==> (101 < 0 && 101 > 0) || (101 > 0 && 101 < 0);
}
method {:test} Test44() {
var r0 := HasOppositeSign(-2, -2);
expect r0 <==> (-2 < 0 && -2 > 0) || (-2 > 0 && -2 < 0);
}

// REPEAT 2 - TIME: 21.8515071 s

method {:test} Test45() {
var r0 := HasOppositeSign(-3, 102);
expect r0 <==> (-3 < 0 && 102 > 0) || (-3 > 0 && 102 < 0);
}
method {:test} Test46() {
var r0 := HasOppositeSign(102, -3);
expect r0 <==> (102 < 0 && -3 > 0) || (102 > 0 && -3 < 0);
}
method {:test} Test47() {
var r0 := HasOppositeSign(102, 102);
expect r0 <==> (102 < 0 && 102 > 0) || (102 > 0 && 102 < 0);
}
method {:test} Test48() {
var r0 := HasOppositeSign(-3, -3);
expect r0 <==> (-3 < 0 && -3 > 0) || (-3 > 0 && -3 < 0);
}

// REPEAT 3 - TIME: 23.867366 s

method {:test} Test49() {
var r0 := HasOppositeSign(-4, 103);
expect r0 <==> (-4 < 0 && 103 > 0) || (-4 > 0 && 103 < 0);
}
method {:test} Test50() {
var r0 := HasOppositeSign(103, -4);
expect r0 <==> (103 < 0 && -4 > 0) || (103 > 0 && -4 < 0);
}
method {:test} Test51() {
var r0 := HasOppositeSign(103, 103);
expect r0 <==> (103 < 0 && 103 > 0) || (103 > 0 && 103 < 0);
}
method {:test} Test52() {
var r0 := HasOppositeSign(-4, -4);
expect r0 <==> (-4 < 0 && -4 > 0) || (-4 > 0 && -4 < 0);
}

// REPEAT 4 - TIME: 25.9504936 s

method {:test} Test53() {
var r0 := HasOppositeSign(-5, 104);
expect r0 <==> (-5 < 0 && 104 > 0) || (-5 > 0 && 104 < 0);
}
method {:test} Test54() {
var r0 := HasOppositeSign(104, -5);
expect r0 <==> (104 < 0 && -5 > 0) || (104 > 0 && -5 < 0);
}
method {:test} Test55() {
var r0 := HasOppositeSign(104, 104);
expect r0 <==> (104 < 0 && 104 > 0) || (104 > 0 && 104 < 0);
}
method {:test} Test56() {
var r0 := HasOppositeSign(-5, -5);
expect r0 <==> (-5 < 0 && -5 > 0) || (-5 > 0 && -5 < 0);
}

// REPEAT 5 - TIME: 27.9692732 s
