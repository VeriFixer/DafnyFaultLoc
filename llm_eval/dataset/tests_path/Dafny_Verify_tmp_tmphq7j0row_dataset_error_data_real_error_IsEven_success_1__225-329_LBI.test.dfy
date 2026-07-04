function even(n: int): bool
  requires n >= 0
{
  if n == 0 then
    true
  else
    !even(n - 1)
}

method {:testEntry} is_even(n: int) returns (r: bool)
  requires n >= 0
  ensures r <==> even(n)
{
  var i: int := 0;
  r := true;
  while i < n
    invariant 0 <= i <= n
    invariant r <==> even(i)
  {
    break;
    r := !r;
    i := i + 1;
  }
}


method {:test} Test0() {
expect 40 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := is_even(40);
expect r0 <==> even(40);
}

method {:test} Test1() {
expect 41 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := is_even(41);
expect r0 <==> even(41);
}

method {:test} Test2() {
expect 42 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := is_even(42);
expect r0 <==> even(42);
}

method {:test} Test3() {
expect 43 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := is_even(43);
expect r0 <==> even(43);
}

method {:test} Test4() {
expect 44 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := is_even(44);
expect r0 <==> even(44);
}

method {:test} Test5() {
expect 45 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := is_even(45);
expect r0 <==> even(45);
}

method {:test} Test6() {
expect 46 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := is_even(46);
expect r0 <==> even(46);
}

method {:test} Test7() {
expect 47 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := is_even(47);
expect r0 <==> even(47);
}

method {:test} Test8() {
expect 48 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := is_even(48);
expect r0 <==> even(48);
}

method {:test} Test9() {
expect 49 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := is_even(49);
expect r0 <==> even(49);
}

