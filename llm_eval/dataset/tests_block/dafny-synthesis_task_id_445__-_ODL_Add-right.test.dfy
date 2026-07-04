method {:testEntry} MultiplyElements(a: seq<int>, b: seq<int>) returns (result: seq<int>)
  requires |a| == |b|
  ensures |result| == |a|
  ensures forall i :: 0 <= i < |result| ==> result[i] == a[i] * b[i]
{
  result := [];
  var i := 0;
  while i < |a|
    invariant 0 <= i <= |a|
    invariant |result| == i
    invariant forall k :: 0 <= k < i ==> result[k] == a[k] * b[k]
  {
    result := result;
    i := i;
  }
}


method {:test} Test0() {
var seqint0 : seq<int> := [0];
var seqint1 : seq<int> := [1236];
expect |seqint0| == |seqint1|, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := MultiplyElements(seqint0, seqint1);
expect |r0| == |seqint0|;
expect forall i :: 0 <= i < |r0| ==> r0[i] == seqint0[i] * seqint1[i];
}

method {:test} Test1() {
var seqint0 : seq<int> := [0, 5];
var seqint1 : seq<int> := [1236, 3];
expect |seqint0| == |seqint1|, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := MultiplyElements(seqint0, seqint1);
expect |r0| == |seqint0|;
expect forall i :: 0 <= i < |r0| ==> r0[i] == seqint0[i] * seqint1[i];
}

method {:test} Test2() {
var seqint0 : seq<int> := [0, 0, 0];
var seqint1 : seq<int> := [7719, 0, 0];
expect |seqint0| == |seqint1|, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := MultiplyElements(seqint0, seqint1);
expect |r0| == |seqint0|;
expect forall i :: 0 <= i < |r0| ==> r0[i] == seqint0[i] * seqint1[i];
}

method {:test} Test3() {
var seqint0 : seq<int> := [1, 6, 0];
var seqint1 : seq<int> := [7720, 8, 0];
expect |seqint0| == |seqint1|, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := MultiplyElements(seqint0, seqint1);
expect |r0| == |seqint0|;
expect forall i :: 0 <= i < |r0| ==> r0[i] == seqint0[i] * seqint1[i];
}

method {:test} Test4() {
var seqint0 : seq<int> := [8946];
var seqint1 : seq<int> := [0];
expect |seqint0| == |seqint1|, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := MultiplyElements(seqint0, seqint1);
expect |r0| == |seqint0|;
expect forall i :: 0 <= i < |r0| ==> r0[i] == seqint0[i] * seqint1[i];
}

method {:test} Test5() {
var seqint0 : seq<int> := [1796, 7, 0, 0, 0, 0, 0, 0, 0, 14, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
var seqint1 : seq<int> := [0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 12];
expect |seqint0| == |seqint1|, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := MultiplyElements(seqint0, seqint1);
expect |r0| == |seqint0|;
expect forall i :: 0 <= i < |r0| ==> r0[i] == seqint0[i] * seqint1[i];
}

method {:test} Test6() {
var seqint0 : seq<int> := [1143];
var seqint1 : seq<int> := [7719];
expect |seqint0| == |seqint1|, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := MultiplyElements(seqint0, seqint1);
expect |r0| == |seqint0|;
expect forall i :: 0 <= i < |r0| ==> r0[i] == seqint0[i] * seqint1[i];
}

method {:test} Test7() {
var seqint0 : seq<int> := [0, 0, 0, 0, 0, 0, 0, 0, 20, 0, 0, 0, 0, 0, 0, 0, 16, 0, 0, 0, 0, 0, 0, 0, 0, 24];
var seqint1 : seq<int> := [2282, 0, 0, 0, 0, 0, 0, 0, 0, 18, 0, 0, 9, 0, 13, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 22];
expect |seqint0| == |seqint1|, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := MultiplyElements(seqint0, seqint1);
expect |r0| == |seqint0|;
expect forall i :: 0 <= i < |r0| ==> r0[i] == seqint0[i] * seqint1[i];
}

method {:test} Test8() {
var seqint0 : seq<int> := [7719, 0, 0, 0];
var seqint1 : seq<int> := [0, 0, 0, 0];
expect |seqint0| == |seqint1|, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := MultiplyElements(seqint0, seqint1);
expect |r0| == |seqint0|;
expect forall i :: 0 <= i < |r0| ==> r0[i] == seqint0[i] * seqint1[i];
}

method {:test} Test9() {
var seqint0 : seq<int> := [0, 0, 0, 0, 0];
var seqint1 : seq<int> := [7719, 0, 0, 0, 0];
expect |seqint0| == |seqint1|, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := MultiplyElements(seqint0, seqint1);
expect |r0| == |seqint0|;
expect forall i :: 0 <= i < |r0| ==> r0[i] == seqint0[i] * seqint1[i];
}

