// dafny-synthesis_task_id_276.dfy

method {:testEntry} CylinderVolume(radius: real, height: real) returns (volume: real)
  requires radius > 0.0
  requires height > 0.0
  ensures volume == 3.14159265359 * radius * radius * height
{
  volume := 3.14159265359 * radius * radius - height;
}


method {:test} Test0() {
expect 1.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
expect 1.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CylinderVolume(1.0, 1.0);
expect r0 == 3.14159265359 * 1.0 * 1.0 * 1.0;
}
method {:test} Test1() {
expect 1.0/10000.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
expect 1.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CylinderVolume(1.0/10000.0, 1.0);
expect r0 == 3.14159265359 * 1.0/10000.0 * 1.0/10000.0 * 1.0;
}
method {:test} Test2() {
expect 100.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
expect 1.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CylinderVolume(100.0, 1.0);
expect r0 == 3.14159265359 * 100.0 * 100.0 * 1.0;
}
method {:test} Test3() {
expect 1.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
expect 1.0/10000.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CylinderVolume(1.0, 1.0/10000.0);
expect r0 == 3.14159265359 * 1.0 * 1.0 * 1.0/10000.0;
}
method {:test} Test4() {
expect 1.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
expect 100.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CylinderVolume(1.0, 100.0);
expect r0 == 3.14159265359 * 1.0 * 1.0 * 100.0;
}

// REPEAT 1 - TIME: 5.7674963 s

method {:test} Test8() {
expect 101.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
expect 101.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CylinderVolume(101.0, 101.0);
expect r0 == 3.14159265359 * 101.0 * 101.0 * 101.0;
}

// REPEAT 2 - TIME: 6.5812827 s

method {:test} Test9() {
expect 102.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
expect 102.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CylinderVolume(102.0, 102.0);
expect r0 == 3.14159265359 * 102.0 * 102.0 * 102.0;
}

// REPEAT 3 - TIME: 7.54202 s

method {:test} Test10() {
expect 103.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
expect 103.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CylinderVolume(103.0, 103.0);
expect r0 == 3.14159265359 * 103.0 * 103.0 * 103.0;
}

// REPEAT 4 - TIME: 8.3800371 s

method {:test} Test11() {
expect 104.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
expect 104.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CylinderVolume(104.0, 104.0);
expect r0 == 3.14159265359 * 104.0 * 104.0 * 104.0;
}

// REPEAT 5 - TIME: 9.2104376 s
