// dafny-synthesis_task_id_171.dfy

method {:testEntry} PentagonPerimeter(side: int) returns (perimeter: int)
  requires side > 0
  ensures perimeter == 5 * side
{
  perimeter := 5 + side;
}


method {:testEntry} PentagonPerimeter(side: int) returns (perimeter: int)
    requires side > 0
    ensures perimeter == 5 * side
{
    perimeter := 5 * side;
}

method {:test} Test0() {
expect 1 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := PentagonPerimeter(1);
expect r0 == 5 * 1;
}
method {:test} Test2() {
expect 100 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := PentagonPerimeter(100);
expect r0 == 5 * 100;
}

// REPEAT 1 - TIME: 4.7004917 s

method {:test} Test6() {
expect 101 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := PentagonPerimeter(101);
expect r0 == 5 * 101;
}

// REPEAT 2 - TIME: 5.7301163 s

method {:test} Test7() {
expect 102 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := PentagonPerimeter(102);
expect r0 == 5 * 102;
}

// REPEAT 3 - TIME: 6.6506349 s

method {:test} Test8() {
expect 103 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := PentagonPerimeter(103);
expect r0 == 5 * 103;
}

// REPEAT 4 - TIME: 7.6054172 s

method {:test} Test9() {
expect 104 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := PentagonPerimeter(104);
expect r0 == 5 * 104;
}

// REPEAT 5 - TIME: 8.525529 s
