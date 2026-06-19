// dafny-synthesis_task_id_637.dfy

method {:testEntry} IsBreakEven(costPrice: int, sellingPrice: int) returns (result: bool)
  requires costPrice >= 0 && sellingPrice >= 0
  ensures result <==> costPrice == sellingPrice
{
  result := sellingPrice == sellingPrice;
}


method {:test} Test0() {
expect 0 >= 0 && 0 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := IsBreakEven(0, 0);
expect r0 <==> 0 == 0;
}
method {:test} Test1() {
expect 1 >= 0 && 0 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := IsBreakEven(1, 0);
expect r0 <==> 1 == 0;
}

// REPEAT 1 - TIME: 2.8306534 s

method {:test} Test2() {
expect 2 >= 0 && 2 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := IsBreakEven(2, 2);
expect r0 <==> 2 == 2;
}
method {:test} Test3() {
expect 2 >= 0 && 1 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := IsBreakEven(2, 1);
expect r0 <==> 2 == 1;
}

// REPEAT 2 - TIME: 4.1186016 s

method {:test} Test4() {
expect 3 >= 0 && 3 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := IsBreakEven(3, 3);
expect r0 <==> 3 == 3;
}
method {:test} Test5() {
expect 4 >= 0 && 3 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := IsBreakEven(4, 3);
expect r0 <==> 4 == 3;
}

// REPEAT 3 - TIME: 5.5402247 s

method {:test} Test6() {
expect 5 >= 0 && 5 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := IsBreakEven(5, 5);
expect r0 <==> 5 == 5;
}
method {:test} Test7() {
expect 5 >= 0 && 4 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := IsBreakEven(5, 4);
expect r0 <==> 5 == 4;
}

// REPEAT 4 - TIME: 6.8524724 s

method {:test} Test8() {
expect 6 >= 0 && 6 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := IsBreakEven(6, 6);
expect r0 <==> 6 == 6;
}
method {:test} Test9() {
expect 7 >= 0 && 6 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := IsBreakEven(7, 6);
expect r0 <==> 7 == 6;
}

// REPEAT 5 - TIME: 7.8537967 s

method {:test} Test10() {
expect 8 >= 0 && 8 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := IsBreakEven(8, 8);
expect r0 <==> 8 == 8;
}
method {:test} Test11() {
expect 8 >= 0 && 7 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := IsBreakEven(8, 7);
expect r0 <==> 8 == 7;
}

// REPEAT 6 - TIME: 8.8850785 s

method {:test} Test12() {
expect 9 >= 0 && 9 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := IsBreakEven(9, 9);
expect r0 <==> 9 == 9;
}
method {:test} Test13() {
expect 10 >= 0 && 9 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := IsBreakEven(10, 9);
expect r0 <==> 10 == 9;
}

// REPEAT 7 - TIME: 10.0833312 s

method {:test} Test14() {
expect 11 >= 0 && 11 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := IsBreakEven(11, 11);
expect r0 <==> 11 == 11;
}
method {:test} Test15() {
expect 11 >= 0 && 10 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := IsBreakEven(11, 10);
expect r0 <==> 11 == 10;
}

// REPEAT 8 - TIME: 11.2299799 s
