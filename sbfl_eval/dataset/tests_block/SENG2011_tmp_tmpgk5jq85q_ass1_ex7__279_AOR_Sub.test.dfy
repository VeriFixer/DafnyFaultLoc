// SENG2011_tmp_tmpgk5jq85q_ass1_ex7.dfy

method {:testEntry} BigFoot(step: nat)
  requires 0 < step <= 42
{
  var indx := 0;
  while indx <= 42
    invariant 0 <= indx <= step + 42 && indx % step == 0
    decreases 42 - indx
  {
    indx := indx - step;
  }
  assert 0 <= indx <= step + 42 && indx % step == 0 && indx > 42;
}

method {:test} Test0() {
expect 0 < 1 <= 42, "If this check fails at runtime, the test does not meet the preconditions";
BigFoot(1);
}

// REPEAT 1 - TIME: 2.2606222 s

method {:test} Test1() {
expect 0 < 2 <= 42, "If this check fails at runtime, the test does not meet the preconditions";
BigFoot(2);
}

// REPEAT 2 - TIME: 3.3632272 s

method {:test} Test2() {
expect 0 < 42 <= 42, "If this check fails at runtime, the test does not meet the preconditions";
BigFoot(42);
}

// REPEAT 3 - TIME: 4.4261334 s

method {:test} Test3() {
expect 0 < 3 <= 42, "If this check fails at runtime, the test does not meet the preconditions";
BigFoot(3);
}

// REPEAT 4 - TIME: 5.3439765 s

method {:test} Test4() {
expect 0 < 4 <= 42, "If this check fails at runtime, the test does not meet the preconditions";
BigFoot(4);
}

// REPEAT 5 - TIME: 6.3149321 s

method {:test} Test5() {
expect 0 < 5 <= 42, "If this check fails at runtime, the test does not meet the preconditions";
BigFoot(5);
}

// REPEAT 6 - TIME: 7.1293232 s

method {:test} Test6() {
expect 0 < 21 <= 42, "If this check fails at runtime, the test does not meet the preconditions";
BigFoot(21);
}

// REPEAT 7 - TIME: 7.8769715 s

method {:test} Test7() {
expect 0 < 22 <= 42, "If this check fails at runtime, the test does not meet the preconditions";
BigFoot(22);
}

// REPEAT 8 - TIME: 8.6836766 s
