// dafny-synthesis_task_id_799.dfy

method {:testEntry} RotateLeftBits(n: bv32, d: int) returns (result: bv32)
  requires 0 <= d < 32
  ensures result == (n << d) | (n >> (32 - d))
{
  result := (n << d) | (n >> (32 + d));
}


method {:test} Test0() {
expect 0 <= 16 < 32, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := RotateLeftBits((0 as bv32), 16);
expect r0 == ((0 as bv32) << 16 as bv6) | ((0 as bv32) >> (32 - 16) as bv6);
}
method {:test} Test3() {
expect 0 <= 0 < 32, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := RotateLeftBits((0 as bv32), 0);
expect r0 == ((0 as bv32) << 0 as bv6) | ((0 as bv32) >> (32 - 0) as bv6);
}
method {:test} Test4() {
expect 0 <= 31 < 32, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := RotateLeftBits((0 as bv32), 31);
expect r0 == ((0 as bv32) << 31 as bv6) | ((0 as bv32) >> (32 - 31) as bv6);
}

// REPEAT 1 - TIME: 6.6882845 s

method {:test} Test10() {
expect 0 <= 30 < 32, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := RotateLeftBits((2147483648 as bv32), 30);
expect r0 == ((2147483648 as bv32) << 30 as bv6) | ((2147483648 as bv32) >> (32 - 30) as bv6);
}

// REPEAT 2 - TIME: 7.7242637 s

method {:test} Test11() {
expect 0 <= 1 < 32, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := RotateLeftBits((1073741824 as bv32), 1);
expect r0 == ((1073741824 as bv32) << 1 as bv6) | ((1073741824 as bv32) >> (32 - 1) as bv6);
}

// REPEAT 3 - TIME: 8.351544 s

method {:test} Test12() {
expect 0 <= 29 < 32, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := RotateLeftBits((3221225472 as bv32), 29);
expect r0 == ((3221225472 as bv32) << 29 as bv6) | ((3221225472 as bv32) >> (32 - 29) as bv6);
}

// REPEAT 4 - TIME: 8.9501594 s

method {:test} Test13() {
expect 0 <= 2 < 32, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := RotateLeftBits((536870912 as bv32), 2);
expect r0 == ((536870912 as bv32) << 2 as bv6) | ((536870912 as bv32) >> (32 - 2) as bv6);
}

// REPEAT 5 - TIME: 9.5876635 s
