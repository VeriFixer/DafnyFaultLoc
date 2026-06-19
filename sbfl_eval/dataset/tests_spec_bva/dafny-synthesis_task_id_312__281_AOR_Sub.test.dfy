// dafny-synthesis_task_id_312.dfy

method {:testEntry} ConeVolume(radius: real, height: real) returns (volume: real)
  requires radius > 0.0 && height > 0.0
  ensures volume == 1.0 / 3.0 * 3.14159265358979323846 * radius * radius * height
{
  volume := 1.0 / 3.0 * 3.14159265358979323846 * radius * radius - height;
}


method {:test} Test0() {
expect 1.0 > 0.0 && 1.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ConeVolume(1.0, 1.0);
expect r0 == 1.0 / 3.0 * 3.14159265358979323846 * 1.0 * 1.0 * 1.0;
}
method {:test} Test1() {
expect 1.0/10000.0 > 0.0 && 1.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ConeVolume(1.0/10000.0, 1.0);
expect r0 == 1.0 / 3.0 * 3.14159265358979323846 * 1.0/10000.0 * 1.0/10000.0 * 1.0;
}
method {:test} Test2() {
expect 100.0 > 0.0 && 1.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ConeVolume(100.0, 1.0);
expect r0 == 1.0 / 3.0 * 3.14159265358979323846 * 100.0 * 100.0 * 1.0;
}
method {:test} Test3() {
expect 1.0 > 0.0 && 1.0/10000.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ConeVolume(1.0, 1.0/10000.0);
expect r0 == 1.0 / 3.0 * 3.14159265358979323846 * 1.0 * 1.0 * 1.0/10000.0;
}
method {:test} Test4() {
expect 1.0 > 0.0 && 100.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ConeVolume(1.0, 100.0);
expect r0 == 1.0 / 3.0 * 3.14159265358979323846 * 1.0 * 1.0 * 100.0;
}

// REPEAT 1 - TIME: 6.5716305 s

method {:test} Test8() {
expect 101.0 > 0.0 && 101.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ConeVolume(101.0, 101.0);
expect r0 == 1.0 / 3.0 * 3.14159265358979323846 * 101.0 * 101.0 * 101.0;
}

// REPEAT 2 - TIME: 7.5903256 s

method {:test} Test9() {
expect 102.0 > 0.0 && 102.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ConeVolume(102.0, 102.0);
expect r0 == 1.0 / 3.0 * 3.14159265358979323846 * 102.0 * 102.0 * 102.0;
}

// REPEAT 3 - TIME: 8.373828 s

method {:test} Test10() {
expect 103.0 > 0.0 && 103.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ConeVolume(103.0, 103.0);
expect r0 == 1.0 / 3.0 * 3.14159265358979323846 * 103.0 * 103.0 * 103.0;
}

// REPEAT 4 - TIME: 9.0587017 s

method {:test} Test11() {
expect 104.0 > 0.0 && 104.0 > 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ConeVolume(104.0, 104.0);
expect r0 == 1.0 / 3.0 * 3.14159265358979323846 * 104.0 * 104.0 * 104.0;
}

// REPEAT 5 - TIME: 9.6627791 s
