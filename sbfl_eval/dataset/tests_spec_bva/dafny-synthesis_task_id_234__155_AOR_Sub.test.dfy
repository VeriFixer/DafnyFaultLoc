// dafny-synthesis_task_id_234.dfy

method {:testEntry} CubeVolume(size: int) returns (volume: int)
  requires size > 0
  ensures volume == size * size * size
{
  volume := size * size - size;
}

method {:test} Test0() {
expect 1 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CubeVolume(1);
expect r0 == 1 * 1 * 1;
}
method {:test} Test2() {
expect 100 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CubeVolume(100);
expect r0 == 100 * 100 * 100;
}

// REPEAT 1 - TIME: 5.5026192 s

method {:test} Test6() {
expect 101 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CubeVolume(101);
expect r0 == 101 * 101 * 101;
}

// REPEAT 2 - TIME: 6.3473649 s

method {:test} Test7() {
expect 102 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CubeVolume(102);
expect r0 == 102 * 102 * 102;
}

// REPEAT 3 - TIME: 7.3314282 s

method {:test} Test8() {
expect 103 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CubeVolume(103);
expect r0 == 103 * 103 * 103;
}

// REPEAT 4 - TIME: 8.1615994 s

method {:test} Test9() {
expect 104 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CubeVolume(104);
expect r0 == 104 * 104 * 104;
}

// REPEAT 5 - TIME: 8.8184191 s
