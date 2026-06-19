// dafny-synthesis_task_id_637.dfy

method {:testEntry} IsBreakEven(costPrice: int, sellingPrice: int) returns (result: bool)
  requires costPrice >= 0 && sellingPrice >= 0
  ensures result <==> costPrice == sellingPrice
{
  result := costPrice > sellingPrice;
}


method {:test} Test0() {
expect 0 >= 0 && 0 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := IsBreakEven(0, 0);
expect r0 <==> 0 == 0;
}
method {:test} Test2() {
expect 100 >= 0 && 100 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := IsBreakEven(100, 100);
expect r0 <==> 100 == 100;
}
method {:test} Test9() {
expect 1 >= 0 && 0 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := IsBreakEven(1, 0);
expect r0 <==> 1 == 0;
}
method {:test} Test10() {
expect 0 >= 0 && 1 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := IsBreakEven(0, 1);
expect r0 <==> 0 == 1;
}
method {:test} Test11() {
expect 100 >= 0 && 101 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := IsBreakEven(100, 101);
expect r0 <==> 100 == 101;
}
method {:test} Test13() {
expect 101 >= 0 && 100 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := IsBreakEven(101, 100);
expect r0 <==> 101 == 100;
}

// REPEAT 1 - TIME: 9.800477 s

method {:test} Test18() {
expect 102 >= 0 && 102 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := IsBreakEven(102, 102);
expect r0 <==> 102 == 102;
}
method {:test} Test19() {
expect 103 >= 0 && 102 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := IsBreakEven(103, 102);
expect r0 <==> 103 == 102;
}

// REPEAT 2 - TIME: 10.7799332 s

method {:test} Test20() {
expect 104 >= 0 && 104 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := IsBreakEven(104, 104);
expect r0 <==> 104 == 104;
}
method {:test} Test21() {
expect 104 >= 0 && 103 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := IsBreakEven(104, 103);
expect r0 <==> 104 == 103;
}

// REPEAT 3 - TIME: 11.903811 s

method {:test} Test22() {
expect 105 >= 0 && 105 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := IsBreakEven(105, 105);
expect r0 <==> 105 == 105;
}
method {:test} Test23() {
expect 106 >= 0 && 105 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := IsBreakEven(106, 105);
expect r0 <==> 106 == 105;
}

// REPEAT 4 - TIME: 12.6951814 s

method {:test} Test24() {
expect 107 >= 0 && 107 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := IsBreakEven(107, 107);
expect r0 <==> 107 == 107;
}
method {:test} Test25() {
expect 107 >= 0 && 106 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := IsBreakEven(107, 106);
expect r0 <==> 107 == 106;
}

// REPEAT 5 - TIME: 13.3959834 s
