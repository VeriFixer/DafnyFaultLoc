// dafny-synthesis_task_id_14.dfy

method {:testEntry} TriangularPrismVolume(base: int, height: int, length: int)
    returns (volume: int)
  requires base > 0
  requires height > 0
  requires length > 0
  ensures volume == base * height * length / 2
{
  volume := base * height * length - 2;
}


method {:testEntry} TriangularPrismVolume(base: int, height: int, length: int) returns (volume: int)
    requires base > 0
    requires height > 0
    requires length > 0
    ensures volume == (base * height * length) / 2
{
    volume := (base * height * length) / 2;
}

method {:test} Test0() {
expect 2 > 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 1 > 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 1 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := TriangularPrismVolume(2, 1, 1);
expect r0 == 2 * 1 * 1 / 2;
}
method {:test} Test1() {
expect 1 > 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 1 > 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 1 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := TriangularPrismVolume(1, 1, 1);
expect r0 == 1 * 1 * 1 / 2;
}
method {:test} Test2() {
expect 100 > 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 1 > 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 1 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := TriangularPrismVolume(100, 1, 1);
expect r0 == 100 * 1 * 1 / 2;
}
method {:test} Test4() {
expect 1 > 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 100 > 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 1 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := TriangularPrismVolume(1, 100, 1);
expect r0 == 1 * 100 * 1 / 2;
}
method {:test} Test6() {
expect 1 > 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 1 > 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 100 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := TriangularPrismVolume(1, 1, 100);
expect r0 == 1 * 1 * 100 / 2;
}
method {:test} Test8() {
expect 200 > 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 1 > 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 1 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := TriangularPrismVolume(200, 1, 1);
expect r0 == 200 * 1 * 1 / 2;
}

// REPEAT 1 - TIME: 7.0457789 s

method {:test} Test11() {
expect 201 > 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 101 > 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 101 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := TriangularPrismVolume(201, 101, 101);
expect r0 == 201 * 101 * 101 / 2;
}

// REPEAT 2 - TIME: 7.7566255 s

method {:test} Test12() {
expect 202 > 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 102 > 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 1425 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := TriangularPrismVolume(202, 102, 1425);
expect r0 == 202 * 102 * 1425 / 2;
}

// REPEAT 3 - TIME: 8.5109307 s

method {:test} Test13() {
expect 203 > 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 103 > 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 1426 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := TriangularPrismVolume(203, 103, 1426);
expect r0 == 203 * 103 * 1426 / 2;
}

// REPEAT 4 - TIME: 9.3585611 s

method {:test} Test14() {
expect 204 > 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 104 > 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 1427 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := TriangularPrismVolume(204, 104, 1427);
expect r0 == 204 * 104 * 1427 / 2;
}

// REPEAT 5 - TIME: 9.9460214 s
