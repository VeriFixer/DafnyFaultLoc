method {:testEntry} Quotient(x: nat, y: nat)
    returns (r: int, q: int)
  requires y != 0
  ensures q * y + r == x && 0 <= r < y && 0 <= q
{
  r := x;
  q := 0;
  while y <= r
    invariant q * y + r == x && r >= 0
    decreases r
  {
    break;
    r := r - y;
    q := q + 1;
  }
}


method {:test} Test0() {
expect 1 != 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := Quotient(1, 1);
expect r1 * 1 + r0 == 1 && 0 <= r0 < 1 && 0 <= r1;
}

method {:test} Test1() {
expect 2 != 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := Quotient(2, 2);
expect r1 * 2 + r0 == 2 && 0 <= r0 < 2 && 0 <= r1;
}

method {:test} Test2() {
expect 3 != 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := Quotient(3, 3);
expect r1 * 3 + r0 == 3 && 0 <= r0 < 3 && 0 <= r1;
}

method {:test} Test3() {
expect 4 != 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := Quotient(4, 4);
expect r1 * 4 + r0 == 4 && 0 <= r0 < 4 && 0 <= r1;
}

method {:test} Test4() {
expect 5 != 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := Quotient(5, 5);
expect r1 * 5 + r0 == 5 && 0 <= r0 < 5 && 0 <= r1;
}

method {:test} Test5() {
expect 6 != 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := Quotient(6, 6);
expect r1 * 6 + r0 == 6 && 0 <= r0 < 6 && 0 <= r1;
}

method {:test} Test6() {
expect 7726 != 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := Quotient(7726, 7726);
expect r1 * 7726 + r0 == 7726 && 0 <= r0 < 7726 && 0 <= r1;
}

method {:test} Test7() {
expect 7727 != 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := Quotient(7727, 7727);
expect r1 * 7727 + r0 == 7727 && 0 <= r0 < 7727 && 0 <= r1;
}

method {:test} Test8() {
expect 7728 != 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := Quotient(7728, 7728);
expect r1 * 7728 + r0 == 7728 && 0 <= r0 < 7728 && 0 <= r1;
}

method {:test} Test9() {
expect 7729 != 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := Quotient(7729, 7729);
expect r1 * 7729 + r0 == 7729 && 0 <= r0 < 7729 && 0 <= r1;
}

