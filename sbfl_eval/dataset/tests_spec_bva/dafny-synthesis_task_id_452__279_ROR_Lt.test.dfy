// dafny-synthesis_task_id_452.dfy

method {:testEntry} CalculateLoss(costPrice: int, sellingPrice: int) returns (loss: int)
  requires costPrice >= 0 && sellingPrice >= 0
  ensures (costPrice > sellingPrice ==> loss == costPrice - sellingPrice) && (costPrice <= sellingPrice ==> loss == 0)
{
  if costPrice < sellingPrice {
    loss := costPrice - sellingPrice;
  } else {
    loss := 0;
  }
}

method {:test} Test0() {
expect 0 >= 0 && 0 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CalculateLoss(0, 0);
expect (0 > 0 ==> r0 == 0 - 0) && (0 <= 0 ==> r0 == 0);
}
method {:test} Test2() {
expect 100 >= 0 && 100 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CalculateLoss(100, 100);
expect (100 > 100 ==> r0 == 100 - 100) && (100 <= 100 ==> r0 == 0);
}
method {:test} Test4() {
expect 0 >= 0 && 100 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CalculateLoss(0, 100);
expect (0 > 100 ==> r0 == 0 - 100) && (0 <= 100 ==> r0 == 0);
}
method {:test} Test8() {
expect 1 >= 0 && 0 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CalculateLoss(1, 0);
expect (1 > 0 ==> r0 == 1 - 0) && (1 <= 0 ==> r0 == 0);
}
method {:test} Test9() {
expect 100 >= 0 && 0 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CalculateLoss(100, 0);
expect (100 > 0 ==> r0 == 100 - 0) && (100 <= 0 ==> r0 == 0);
}
method {:test} Test11() {
expect 101 >= 0 && 100 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CalculateLoss(101, 100);
expect (101 > 100 ==> r0 == 101 - 100) && (101 <= 100 ==> r0 == 0);
}

// REPEAT 1 - TIME: 14.2516318 s

method {:test} Test16() {
expect 102 >= 0 && 102 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CalculateLoss(102, 102);
expect (102 > 102 ==> r0 == 102 - 102) && (102 <= 102 ==> r0 == 0);
}
method {:test} Test17() {
expect 102 >= 0 && 101 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CalculateLoss(102, 101);
expect (102 > 101 ==> r0 == 102 - 101) && (102 <= 101 ==> r0 == 0);
}

// REPEAT 2 - TIME: 15.6533753 s

method {:test} Test18() {
expect 103 >= 0 && 103 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CalculateLoss(103, 103);
expect (103 > 103 ==> r0 == 103 - 103) && (103 <= 103 ==> r0 == 0);
}
method {:test} Test19() {
expect 104 >= 0 && 103 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CalculateLoss(104, 103);
expect (104 > 103 ==> r0 == 104 - 103) && (104 <= 103 ==> r0 == 0);
}

// REPEAT 3 - TIME: 17.0650772 s

method {:test} Test20() {
expect 105 >= 0 && 105 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CalculateLoss(105, 105);
expect (105 > 105 ==> r0 == 105 - 105) && (105 <= 105 ==> r0 == 0);
}
method {:test} Test21() {
expect 105 >= 0 && 104 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CalculateLoss(105, 104);
expect (105 > 104 ==> r0 == 105 - 104) && (105 <= 104 ==> r0 == 0);
}

// REPEAT 4 - TIME: 18.4695339 s

method {:test} Test22() {
expect 106 >= 0 && 106 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CalculateLoss(106, 106);
expect (106 > 106 ==> r0 == 106 - 106) && (106 <= 106 ==> r0 == 0);
}
method {:test} Test23() {
expect 107 >= 0 && 106 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := CalculateLoss(107, 106);
expect (107 > 106 ==> r0 == 107 - 106) && (107 <= 106 ==> r0 == 0);
}

// REPEAT 5 - TIME: 19.9291789 s
