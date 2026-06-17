method {:testEntry} CircleCircumference(radius: real) returns (circumference: real)
    requires radius > 0.0
    ensures circumference == 2.0 * 3.14159265358979323846 * radius
{
    circumference := 2.0 * 3.14159265358979323846 * radius;
}

method {:test} Test0() {
expect 1.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CircleCircumference(1.0);
expect r0 == 2.0 * 3.14159265358979323846 * 1.0;
}
method {:test} Test1() {
expect 1.0/10000.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CircleCircumference(1.0/10000.0);
expect r0 == 2.0 * 3.14159265358979323846 * 1.0/10000.0;
}
method {:test} Test2() {
expect 100.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CircleCircumference(100.0);
expect r0 == 2.0 * 3.14159265358979323846 * 100.0;
}

// REPEAT 1 - TIME: 4.8722036 s

method {:test} Test6() {
expect 101.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CircleCircumference(101.0);
expect r0 == 2.0 * 3.14159265358979323846 * 101.0;
}

// REPEAT 2 - TIME: 6.0715607 s

method {:test} Test7() {
expect 102.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CircleCircumference(102.0);
expect r0 == 2.0 * 3.14159265358979323846 * 102.0;
}

// REPEAT 3 - TIME: 6.9454359 s

method {:test} Test8() {
expect 103.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CircleCircumference(103.0);
expect r0 == 2.0 * 3.14159265358979323846 * 103.0;
}

// REPEAT 4 - TIME: 7.9019647 s

method {:test} Test9() {
expect 104.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CircleCircumference(104.0);
expect r0 == 2.0 * 3.14159265358979323846 * 104.0;
}

// REPEAT 5 - TIME: 8.6966684 s
