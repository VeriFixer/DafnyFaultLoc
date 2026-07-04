method {:testEntry} Maximum(values: seq<int>) returns (max: int)
  requires values != []
  ensures max in values
  ensures forall i | 0 <= i < |values| :: values[i] <= max
{
  max := values[0];
  var idx := 0;
  while idx <= |values|
    invariant max in values
    invariant idx <= |values|
    invariant forall j | 0 <= j < idx :: values[j] <= max
  {
    if values[idx] > max {
      max := values[idx];
    }
    idx := idx + 1;
  }
}

lemma MaximumIsUnique(values: seq<int>, m1: int, m2: int)
  requires m1 in values && forall i | 0 <= i < |values| :: values[i] <= m1
  requires m2 in values && forall i | 0 <= i < |values| :: values[i] <= m2
  ensures m1 == m2
{
}


method {:test} Test0() {
var seqint0 : seq<int> := [1198];
expect seqint0 != [], "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Maximum(seqint0);
expect r0 in seqint0;
expect forall i | 0 <= i < |seqint0| :: seqint0[i] <= r0;
}

method {:test} Test1() {
var seqint0 : seq<int> := [-7719, 1136];
expect seqint0 != [], "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Maximum(seqint0);
expect r0 in seqint0;
expect forall i | 0 <= i < |seqint0| :: seqint0[i] <= r0;
}

method {:test} Test2() {
var seqint0 : seq<int> := [-7719, 1136, 0];
expect seqint0 != [], "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Maximum(seqint0);
expect r0 in seqint0;
expect forall i | 0 <= i < |seqint0| :: seqint0[i] <= r0;
}

method {:test} Test3() {
var seqint0 : seq<int> := [-1236, 0, 7059, 8855];
expect seqint0 != [], "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Maximum(seqint0);
expect r0 in seqint0;
expect forall i | 0 <= i < |seqint0| :: seqint0[i] <= r0;
}

method {:test} Test4() {
var seqint0 : seq<int> := [641, -6418, 0, 2437, 0];
expect seqint0 != [], "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Maximum(seqint0);
expect r0 in seqint0;
expect forall i | 0 <= i < |seqint0| :: seqint0[i] <= r0;
}

method {:test} Test5() {
var seqint0 : seq<int> := [-6343, -490];
expect seqint0 != [], "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Maximum(seqint0);
expect r0 in seqint0;
expect forall i | 0 <= i < |seqint0| :: seqint0[i] <= r0;
}

method {:test} Test6() {
var seqint0 : seq<int> := [1988, 2437, -6418];
expect seqint0 != [], "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Maximum(seqint0);
expect r0 in seqint0;
expect forall i | 0 <= i < |seqint0| :: seqint0[i] <= r0;
}

method {:test} Test7() {
var seqint0 : seq<int> := [155, -6418, 2437, 0];
expect seqint0 != [], "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Maximum(seqint0);
expect r0 in seqint0;
expect forall i | 0 <= i < |seqint0| :: seqint0[i] <= r0;
}

method {:test} Test8() {
var seqint0 : seq<int> := [-5661, 155, -5928, 0, 2437, 0];
expect seqint0 != [], "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Maximum(seqint0);
expect r0 in seqint0;
expect forall i | 0 <= i < |seqint0| :: seqint0[i] <= r0;
}

method {:test} Test9() {
var seqint0 : seq<int> := [1988, 2437, -5928, -6418, 155, 0, 0];
expect seqint0 != [], "If this check fails at runtime, the test does not meet the preconditions";
var r0 := Maximum(seqint0);
expect r0 in seqint0;
expect forall i | 0 <= i < |seqint0| :: seqint0[i] <= r0;
}

