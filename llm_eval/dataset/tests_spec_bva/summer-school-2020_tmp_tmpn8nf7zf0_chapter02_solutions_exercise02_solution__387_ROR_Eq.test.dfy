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
  while f == i
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
expect 1 < 40, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(40);
expect r0 == IsPrime(40);
}
method {:test} Test1() {
expect 1 < 2, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(2);
expect r0 == IsPrime(2);
}
method {:test} Test2() {
expect 1 < 100, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(100);
expect r0 == IsPrime(100);
}
method {:test} Test7() {
expect 1 < 4, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(4);
expect r0 == IsPrime(4);
}
method {:test} Test13() {
Main();
}

method {:test} Test16() {
expect 1 < 101, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(101);
expect r0 == IsPrime(101);
}
method {:test} Test17() {
expect 1 < 102, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(102);
expect r0 == IsPrime(102);
}

method {:test} Test18() {
expect 1 < 103, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(103);
expect r0 == IsPrime(103);
}
method {:test} Test19() {
expect 1 < 104, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(104);
expect r0 == IsPrime(104);
}

method {:test} Test20() {
expect 1 < 105, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(105);
expect r0 == IsPrime(105);
}
method {:test} Test21() {
expect 1 < 106, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(106);
expect r0 == IsPrime(106);
}

method {:test} Test22() {
expect 1 < 107, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(107);
expect r0 == IsPrime(107);
}
method {:test} Test23() {
expect 1 < 108, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(108);
expect r0 == IsPrime(108);
}

method {:test} Test24() {
expect 1 < 109, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(109);
expect r0 == IsPrime(109);
}
method {:test} Test25() {
expect 1 < 110, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(110);
expect r0 == IsPrime(110);
}

method {:test} Test26() {
expect 1 < 111, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(111);
expect r0 == IsPrime(111);
}
method {:test} Test27() {
expect 1 < 112, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(112);
expect r0 == IsPrime(112);
}

method {:test} Test28() {
expect 1 < 113, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(113);
expect r0 == IsPrime(113);
}
method {:test} Test29() {
expect 1 < 114, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(114);
expect r0 == IsPrime(114);
}

method {:test} Test30() {
expect 1 < 115, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(115);
expect r0 == IsPrime(115);
}
method {:test} Test31() {
expect 1 < 116, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(116);
expect r0 == IsPrime(116);
}

method {:test} Test32() {
expect 1 < 117, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(117);
expect r0 == IsPrime(117);
}
method {:test} Test33() {
expect 1 < 118, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := test_prime(118);
expect r0 == IsPrime(118);
}

