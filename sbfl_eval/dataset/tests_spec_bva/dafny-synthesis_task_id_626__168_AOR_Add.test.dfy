// dafny-synthesis_task_id_626.dfy

method {:testEntry} AreaOfLargestTriangleInSemicircle(radius: int) returns (area: int)
  requires radius > 0
  ensures area == radius * radius
{
  area := radius + radius;
}


method {:test} Test0() {
expect 1 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := AreaOfLargestTriangleInSemicircle(1);
expect r0 == 1 * 1;
}
method {:test} Test2() {
expect 100 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := AreaOfLargestTriangleInSemicircle(100);
expect r0 == 100 * 100;
}
method {:test} Test4() {
expect 10 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := AreaOfLargestTriangleInSemicircle(10);
expect r0 == 10 * 10;
}

// REPEAT 1 - TIME: 5.8318038 s

method {:test} Test7() {
expect 101 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := AreaOfLargestTriangleInSemicircle(101);
expect r0 == 101 * 101;
}

// REPEAT 2 - TIME: 6.6509915 s

method {:test} Test8() {
expect 102 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := AreaOfLargestTriangleInSemicircle(102);
expect r0 == 102 * 102;
}

// REPEAT 3 - TIME: 7.5334496 s

method {:test} Test9() {
expect 103 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := AreaOfLargestTriangleInSemicircle(103);
expect r0 == 103 * 103;
}

// REPEAT 4 - TIME: 8.2725874 s

method {:test} Test10() {
expect 104 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := AreaOfLargestTriangleInSemicircle(104);
expect r0 == 104 * 104;
}

// REPEAT 5 - TIME: 8.841345 s
