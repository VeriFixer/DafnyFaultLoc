// dafny-synthesis_task_id_430.dfy

method {:testEntry} ParabolaDirectrix(a: real, h: real, k: real)
    returns (directrix: real)
  requires a != 0.0
  ensures directrix == k - 1.0 / (4.0 * a)
{
  directrix := k - 1.0;
}

method {:test} Test0() {
expect 1.0 != 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ParabolaDirectrix(1.0, 0.0, 1.0);
expect r0 == 1.0 - 1.0 / (4.0 * 1.0);
}
method {:test} Test1() {
expect -100.0 != 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ParabolaDirectrix(-100.0, 0.0, 0.0);
expect r0 == 0.0 - 1.0 / (4.0 * -100.0);
}
method {:test} Test2() {
expect 100.0 != 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ParabolaDirectrix(100.0, 0.0, 0.0);
expect r0 == 0.0 - 1.0 / (4.0 * 100.0);
}
method {:test} Test3() {
expect 1.0 != 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ParabolaDirectrix(1.0, -100.0, 1.0);
expect r0 == 1.0 - 1.0 / (4.0 * 1.0);
}
method {:test} Test4() {
expect 1.0 != 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ParabolaDirectrix(1.0, 100.0, 1.0);
expect r0 == 1.0 - 1.0 / (4.0 * 1.0);
}
method {:test} Test5() {
expect 1.0 != 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ParabolaDirectrix(1.0, 0.0, -100.0);
expect r0 == -100.0 - 1.0 / (4.0 * 1.0);
}
method {:test} Test6() {
expect 1.0 != 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ParabolaDirectrix(1.0, 0.0, 100.0);
expect r0 == 100.0 - 1.0 / (4.0 * 1.0);
}
method {:test} Test8() {
expect 1.0 != 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ParabolaDirectrix(1.0, 0.0, -99.0);
expect r0 == -99.0 - 1.0 / (4.0 * 1.0);
}
method {:test} Test9() {
expect 1.0 != 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ParabolaDirectrix(1.0, 0.0, 101.0);
expect r0 == 101.0 - 1.0 / (4.0 * 1.0);
}

// REPEAT 1 - TIME: 7.4037448 s

method {:test} Test12() {
expect 80001.0/800.0 != 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ParabolaDirectrix(80001.0/800.0, 2.0, 80801.0/800.0);
expect r0 == 80801.0/800.0 - 1.0 / (4.0 * 80001.0/800.0);
}

// REPEAT 2 - TIME: 8.2061532 s

method {:test} Test13() {
expect 6400240001.0/64000800.0 != 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ParabolaDirectrix(6400240001.0/64000800.0, 3.0, 6464240801.0/64000800.0);
expect r0 == 6464240801.0/64000800.0 - 1.0 / (4.0 * 6400240001.0/64000800.0);
}

// REPEAT 3 - TIME: 8.8926627 s

method {:test} Test14() {
expect 40963584083200560001.0/409620480256000800.0 != 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ParabolaDirectrix(40963584083200560001.0/409620480256000800.0, 5.0, 41373204563456560801.0/409620480256000800.0);
expect r0 == 41373204563456560801.0/409620480256000800.0 - 1.0 / (4.0 * 40963584083200560001.0/409620480256000800.0);
}

// REPEAT 4 - TIME: 9.6369167 s

method {:test} Test15() {
expect 1678036194558672908410992640531201200001.0/16779522985167683620045030400704000800.0 != 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ParabolaDirectrix(1678036194558672908410992640531201200001.0/16779522985167683620045030400704000800.0, 6.0, 1694815717543840592031037670931905200801.0/16779522985167683620045030400704000800.0);
expect r0 == 1694815717543840592031037670931905200801.0/16779522985167683620045030400704000800.0 - 1.0 / (4.0 * 1678036194558672908410992640531201200001.0/16779522985167683620045030400704000800.0);
}

// REPEAT 5 - TIME: 10.3588223 s
