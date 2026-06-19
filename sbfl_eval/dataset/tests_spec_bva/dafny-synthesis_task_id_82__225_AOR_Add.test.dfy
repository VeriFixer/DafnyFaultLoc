// dafny-synthesis_task_id_82.dfy

method {:testEntry} SphereVolume(radius: real) returns (volume: real)
  requires radius > 0.0
  ensures volume == 4.0 / 3.0 * 3.1415926535 * radius * radius * radius
{
  volume := 4.0 / 3.0 * 3.1415926535 * radius * radius + radius;
}


method {:test} Test0() {
expect 1.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SphereVolume(1.0);
expect r0 == 4.0 / 3.0 * 3.1415926535 * 1.0 * 1.0 * 1.0;
}
method {:test} Test1() {
expect 1.0/10000.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SphereVolume(1.0/10000.0);
expect r0 == 4.0 / 3.0 * 3.1415926535 * 1.0/10000.0 * 1.0/10000.0 * 1.0/10000.0;
}
method {:test} Test2() {
expect 100.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SphereVolume(100.0);
expect r0 == 4.0 / 3.0 * 3.1415926535 * 100.0 * 100.0 * 100.0;
}

// REPEAT 1 - TIME: 4.9052291 s

method {:test} Test6() {
expect 101.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SphereVolume(101.0);
expect r0 == 4.0 / 3.0 * 3.1415926535 * 101.0 * 101.0 * 101.0;
}

// REPEAT 2 - TIME: 5.9991805 s

method {:test} Test7() {
expect 102.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SphereVolume(102.0);
expect r0 == 4.0 / 3.0 * 3.1415926535 * 102.0 * 102.0 * 102.0;
}

// REPEAT 3 - TIME: 6.9629638 s

method {:test} Test8() {
expect 103.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SphereVolume(103.0);
expect r0 == 4.0 / 3.0 * 3.1415926535 * 103.0 * 103.0 * 103.0;
}

// REPEAT 4 - TIME: 7.773938 s

method {:test} Test9() {
expect 104.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SphereVolume(104.0);
expect r0 == 4.0 / 3.0 * 3.1415926535 * 104.0 * 104.0 * 104.0;
}

// REPEAT 5 - TIME: 8.4048455 s
