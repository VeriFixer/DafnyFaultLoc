predicate divides(f: nat, i: nat)
  requires 1 <= f
{
  i % f == 0
}

predicate IsPrime(i: nat)
{
  1 < i &&
  forall f :: 
    1 < f < i ==>
      !divides(f, i)
}

method {:testEntry} test_prime(i: nat) returns (result: bool)
  requires 1 < i
  ensures result == IsPrime(i)
{
  var f := 2;
  while true
    invariant forall g :: 1 < g < f ==> !divides(g, i)
  {
    if i % f == 0 {
      assert divides(f, i);
      return false;
    }
    f := f + 1;
  }
  return true;
}

method {:testEntry} Main()
{
  var a := test_prime(3);
  assert a;
  var b := test_prime(4);
  assert divides(2, 4);
  assert !b;
  var c := test_prime(5);
  assert c;
}


method {:test} Test0() {
expect 1 < 2, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(2);
expect r0 == IsPrime(2);
}
method {:test} Test1() {
expect 1 < 4, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(4);
expect r0 == IsPrime(4);
}
method {:test} Test2() {
Main();
}

method {:test} Test3() {
expect 1 < 43, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(43);
expect r0 == IsPrime(43);
}
method {:test} Test4() {
expect 1 < 6, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(6);
expect r0 == IsPrime(6);
}

method {:test} Test5() {
expect 1 < 44, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(44);
expect r0 == IsPrime(44);
}

method {:test} Test7() {
expect 1 < 45, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(45);
expect r0 == IsPrime(45);
}
method {:test} Test8() {
expect 1 < 46, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(46);
expect r0 == IsPrime(46);
}

method {:test} Test9() {
expect 1 < 47, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(47);
expect r0 == IsPrime(47);
}
method {:test} Test10() {
expect 1 < 57, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(57);
expect r0 == IsPrime(57);
}

method {:test} Test11() {
expect 1 < 58, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(58);
expect r0 == IsPrime(58);
}

method {:test} Test13() {
expect 1 < 59, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(59);
expect r0 == IsPrime(59);
}
method {:test} Test14() {
expect 1 < 76, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(76);
expect r0 == IsPrime(76);
}

method {:test} Test15() {
expect 1 < 77, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(77);
expect r0 == IsPrime(77);
}
method {:test} Test16() {
expect 1 < 78, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(78);
expect r0 == IsPrime(78);
}

method {:test} Test17() {
expect 1 < 79, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(79);
expect r0 == IsPrime(79);
}
method {:test} Test18() {
expect 1 < 80, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(80);
expect r0 == IsPrime(80);
}

method {:test} Test19() {
expect 1 < 81, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(81);
expect r0 == IsPrime(81);
}
method {:test} Test20() {
expect 1 < 82, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(82);
expect r0 == IsPrime(82);
}

