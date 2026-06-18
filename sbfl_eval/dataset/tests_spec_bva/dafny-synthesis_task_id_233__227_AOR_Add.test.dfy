// dafny-synthesis_task_id_233.dfy

method {:testEntry} CylinderLateralSurfaceArea(radius: real, height: real) returns (area: real)
  requires radius > 0.0 && height > 0.0
  ensures area == 2.0 * (radius * height) * 3.14
{
  area := 2.0 * (radius * height) + 3.14;
}


method {:testEntry} CylinderLateralSurfaceArea(radius: real, height: real) returns (area: real)
    requires radius > 0.0 && height > 0.0
    ensures area == 2.0 * (radius * height) * 3.14
{
    area := 2.0 * (radius * height) * 3.14;
}

method {:test} Test0() {
expect 1.0 > 0.0 && 1.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CylinderLateralSurfaceArea(1.0, 1.0);
expect r0 == 2.0 * (1.0 * 1.0) * 3.14;
}
method {:test} Test1() {
expect 1.0/10000.0 > 0.0 && 1.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CylinderLateralSurfaceArea(1.0/10000.0, 1.0);
expect r0 == 2.0 * (1.0/10000.0 * 1.0) * 3.14;
}
method {:test} Test2() {
expect 100.0 > 0.0 && 1.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CylinderLateralSurfaceArea(100.0, 1.0);
expect r0 == 2.0 * (100.0 * 1.0) * 3.14;
}
method {:test} Test3() {
expect 1.0 > 0.0 && 1.0/10000.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CylinderLateralSurfaceArea(1.0, 1.0/10000.0);
expect r0 == 2.0 * (1.0 * 1.0/10000.0) * 3.14;
}
method {:test} Test4() {
expect 1.0 > 0.0 && 100.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CylinderLateralSurfaceArea(1.0, 100.0);
expect r0 == 2.0 * (1.0 * 100.0) * 3.14;
}

// REPEAT 1 - TIME: 5.9004317 s

method {:test} Test8() {
expect 101.0 > 0.0 && 101.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CylinderLateralSurfaceArea(101.0, 101.0);
expect r0 == 2.0 * (101.0 * 101.0) * 3.14;
}

// REPEAT 2 - TIME: 6.7682333 s

method {:test} Test9() {
expect 102.0 > 0.0 && 102.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CylinderLateralSurfaceArea(102.0, 102.0);
expect r0 == 2.0 * (102.0 * 102.0) * 3.14;
}

// REPEAT 3 - TIME: 7.781674 s

method {:test} Test10() {
expect 103.0 > 0.0 && 103.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CylinderLateralSurfaceArea(103.0, 103.0);
expect r0 == 2.0 * (103.0 * 103.0) * 3.14;
}

// REPEAT 4 - TIME: 8.6774246 s

method {:test} Test11() {
expect 104.0 > 0.0 && 104.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CylinderLateralSurfaceArea(104.0, 104.0);
expect r0 == 2.0 * (104.0 * 104.0) * 3.14;
}

// REPEAT 5 - TIME: 9.4347211 s
