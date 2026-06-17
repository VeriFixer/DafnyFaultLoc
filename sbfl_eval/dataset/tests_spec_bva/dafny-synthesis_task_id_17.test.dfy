method {:testEntry} SquarePerimeter(side: int) returns (perimeter: int)
    requires side > 0
    ensures perimeter == 4 * side
{
    perimeter := 4 * side;
}

method {:test} Test0() {
expect 1 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SquarePerimeter(1);
expect r0 == 4 * 1;
}
method {:test} Test2() {
expect 100 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SquarePerimeter(100);
expect r0 == 4 * 100;
}

// REPEAT 1 - TIME: 4.8208468 s

method {:test} Test6() {
expect 101 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SquarePerimeter(101);
expect r0 == 4 * 101;
}

// REPEAT 2 - TIME: 5.7239404 s

method {:test} Test7() {
expect 102 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SquarePerimeter(102);
expect r0 == 4 * 102;
}

// REPEAT 3 - TIME: 6.5486822 s

method {:test} Test8() {
expect 103 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SquarePerimeter(103);
expect r0 == 4 * 103;
}

// REPEAT 4 - TIME: 7.4069742 s

method {:test} Test9() {
expect 104 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SquarePerimeter(104);
expect r0 == 4 * 104;
}

// REPEAT 5 - TIME: 8.2229375 s
