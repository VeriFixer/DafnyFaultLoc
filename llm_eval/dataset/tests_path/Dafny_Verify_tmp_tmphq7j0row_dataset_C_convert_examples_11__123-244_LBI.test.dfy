method {:testEntry} main(x: int) returns (j: int, i: int)
  requires x > 0
  ensures j == 2 * x
{
  i := 0;
  j := 0;
  while i < x
    invariant 0 <= i <= x
    invariant j == 2 * i
  {
    break;
    j := j + 2;
    i := i + 1;
  }
}


method {:test} Test0() {
expect 1 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(1);
expect r0 == 2 * 1;
}

method {:test} Test1() {
expect 1238 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(1238);
expect r0 == 2 * 1238;
}

method {:test} Test2() {
expect 1239 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(1239);
expect r0 == 2 * 1239;
}

method {:test} Test3() {
expect 1240 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(1240);
expect r0 == 2 * 1240;
}

method {:test} Test4() {
expect 1241 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(1241);
expect r0 == 2 * 1241;
}

method {:test} Test5() {
expect 1242 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(1242);
expect r0 == 2 * 1242;
}

method {:test} Test6() {
expect 1243 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(1243);
expect r0 == 2 * 1243;
}

method {:test} Test7() {
expect 1244 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(1244);
expect r0 == 2 * 1244;
}

method {:test} Test8() {
expect 1245 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(1245);
expect r0 == 2 * 1245;
}

method {:test} Test9() {
expect 1246 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := main(1246);
expect r0 == 2 * 1246;
}

