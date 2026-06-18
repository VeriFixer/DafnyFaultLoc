// dafny-synthesis_task_id_581.dfy

method {:testEntry} SquarePyramidSurfaceArea(baseEdge: int, height: int) returns (area: int)
  requires baseEdge > 0
  requires height > 0
  ensures area == baseEdge * baseEdge + 2 * baseEdge * height
{
  area := baseEdge - baseEdge + 2 * baseEdge * height;
}


method {:testEntry} SquarePyramidSurfaceArea(baseEdge: int, height: int) returns (area: int)
    requires baseEdge > 0
    requires height > 0
    ensures area == baseEdge * baseEdge + 2 * baseEdge * height
{
    area := baseEdge * baseEdge + 2 * baseEdge * height;
}

method {:test} Test0() {
expect 1 > 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 1 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SquarePyramidSurfaceArea(1, 1);
expect r0 == 1 * 1 + 2 * 1 * 1;
}
method {:test} Test1() {
expect 1 > 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 7720 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SquarePyramidSurfaceArea(1, 7720);
expect r0 == 1 * 1 + 2 * 1 * 7720;
}
method {:test} Test2() {
expect 100 > 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 1 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SquarePyramidSurfaceArea(100, 1);
expect r0 == 100 * 100 + 2 * 100 * 1;
}
method {:test} Test4() {
expect 1 > 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 100 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SquarePyramidSurfaceArea(1, 100);
expect r0 == 1 * 1 + 2 * 1 * 100;
}
method {:test} Test6() {
expect 2 > 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 24 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SquarePyramidSurfaceArea(2, 24);
expect r0 == 2 * 2 + 2 * 2 * 24;
}

// REPEAT 1 - TIME: 6.836694 s

method {:test} Test9() {
expect 101 > 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 7721 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SquarePyramidSurfaceArea(101, 7721);
expect r0 == 101 * 101 + 2 * 101 * 7721;
}

// REPEAT 2 - TIME: 7.6408616 s

method {:test} Test10() {
expect 102 > 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 7722 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SquarePyramidSurfaceArea(102, 7722);
expect r0 == 102 * 102 + 2 * 102 * 7722;
}

// REPEAT 3 - TIME: 8.272929 s

method {:test} Test11() {
expect 103 > 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 7723 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SquarePyramidSurfaceArea(103, 7723);
expect r0 == 103 * 103 + 2 * 103 * 7723;
}

// REPEAT 4 - TIME: 8.9459521 s

method {:test} Test12() {
expect 104 > 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 7724 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SquarePyramidSurfaceArea(104, 7724);
expect r0 == 104 * 104 + 2 * 104 * 7724;
}

// REPEAT 5 - TIME: 9.548378 s
