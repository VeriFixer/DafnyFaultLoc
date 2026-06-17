method {:testEntry} SphereSurfaceArea(radius: real) returns (area: real)
    requires radius > 0.0
    ensures area == 4.0 * 3.14159265358979323846 * radius * radius
{
    area := 4.0 * 3.14159265358979323846 * radius * radius;
}

method {:test} Test0() {
expect 1.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SphereSurfaceArea(1.0);
expect r0 == 4.0 * 3.14159265358979323846 * 1.0 * 1.0;
}

// REPEAT 1 - TIME: 2.2307209 s

method {:test} Test1() {
expect 2.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SphereSurfaceArea(2.0);
expect r0 == 4.0 * 3.14159265358979323846 * 2.0 * 2.0;
}

// REPEAT 2 - TIME: 3.0005148 s

method {:test} Test2() {
expect 3.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SphereSurfaceArea(3.0);
expect r0 == 4.0 * 3.14159265358979323846 * 3.0 * 3.0;
}

// REPEAT 3 - TIME: 3.769847 s

method {:test} Test3() {
expect 4.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SphereSurfaceArea(4.0);
expect r0 == 4.0 * 3.14159265358979323846 * 4.0 * 4.0;
}

// REPEAT 4 - TIME: 4.59749 s

method {:test} Test4() {
expect 5.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SphereSurfaceArea(5.0);
expect r0 == 4.0 * 3.14159265358979323846 * 5.0 * 5.0;
}

// REPEAT 5 - TIME: 5.4734943 s

method {:test} Test5() {
expect 6.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SphereSurfaceArea(6.0);
expect r0 == 4.0 * 3.14159265358979323846 * 6.0 * 6.0;
}

// REPEAT 6 - TIME: 6.4231398 s

method {:test} Test6() {
expect 7.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SphereSurfaceArea(7.0);
expect r0 == 4.0 * 3.14159265358979323846 * 7.0 * 7.0;
}

// REPEAT 7 - TIME: 7.3803693 s

method {:test} Test7() {
expect 8.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SphereSurfaceArea(8.0);
expect r0 == 4.0 * 3.14159265358979323846 * 8.0 * 8.0;
}

// REPEAT 8 - TIME: 8.0574198 s
