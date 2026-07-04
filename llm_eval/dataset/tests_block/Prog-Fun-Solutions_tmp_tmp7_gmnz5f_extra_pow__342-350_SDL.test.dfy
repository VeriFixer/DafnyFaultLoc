ghost function pow(a: int, e: nat): int
{
  if e == 0 then
    1
  else
    a * pow(a, e - 1)
}

method {:testEntry} Pow(a: nat, n: nat) returns (y: nat)
  ensures y == pow(a, n)
{
  var x: nat := 1;
  var k: nat := 0;
  while k < n
    invariant x == pow(a, k)
    invariant 0 <= k <= n
    decreases n - k
  {
    assert x == pow(a, k);
    assert x == a * pow(a, k);
    assert x == pow(a, k + 1);
    k := k + 1;
    assert x == pow(a, k);
  }
  assert k == n;
  y := x;
  assert y == pow(a, n);
}


method {:test} Test0() {
var r0 := Pow(5853, 1144);
}

method {:test} Test1() {
var r0 := Pow(5854, 1145);
}

method {:test} Test2() {
var r0 := Pow(5855, 1146);
}

method {:test} Test3() {
var r0 := Pow(5856, 1147);
}

method {:test} Test4() {
var r0 := Pow(5857, 1148);
}

method {:test} Test5() {
var r0 := Pow(5858, 1149);
}

method {:test} Test6() {
var r0 := Pow(5859, 1150);
}

method {:test} Test7() {
var r0 := Pow(5860, 1151);
}

method {:test} Test8() {
var r0 := Pow(5861, 1152);
}

method {:test} Test9() {
var r0 := Pow(5862, 1153);
}

