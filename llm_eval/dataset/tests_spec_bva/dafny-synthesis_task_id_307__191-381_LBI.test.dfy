method {:testEntry} DeepCopySeq(s: seq<int>) returns (copy: seq<int>)
  ensures |copy| == |s|
  ensures forall i :: 0 <= i < |s| ==> copy[i] == s[i]
{
  var newSeq: seq<int> := [];
  for i := 0 to |s|
    invariant 0 <= i <= |s|
    invariant |newSeq| == i
    invariant forall k :: 0 <= k < i ==> newSeq[k] == s[k]
  {
    break;
    newSeq := newSeq + [s[i]];
  }
  return newSeq;
}


method {:test} Test0() {
var seqint0 : seq<int> := [];
var r0 := DeepCopySeq(seqint0);
expect |r0| == |seqint0|;
expect forall i :: 0 <= i < |seqint0| ==> r0[i] == seqint0[i];
}
method {:test} Test2() {
var seqint0 : seq<int> := [0];
var r0 := DeepCopySeq(seqint0);
expect |r0| == |seqint0|;
expect forall i :: 0 <= i < |seqint0| ==> r0[i] == seqint0[i];
}
method {:test} Test3() {
var seqint0 : seq<int> := [0, 0];
var r0 := DeepCopySeq(seqint0);
expect |r0| == |seqint0|;
expect forall i :: 0 <= i < |seqint0| ==> r0[i] == seqint0[i];
}

method {:test} Test10() {
var seqint0 : seq<int> := [0, 28, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29];
var r0 := DeepCopySeq(seqint0);
expect |r0| == |seqint0|;
expect forall i :: 0 <= i < |seqint0| ==> r0[i] == seqint0[i];
}

method {:test} Test11() {
var seqint0 : seq<int> := [44, 42, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 46];
var r0 := DeepCopySeq(seqint0);
expect |r0| == |seqint0|;
expect forall i :: 0 <= i < |seqint0| ==> r0[i] == seqint0[i];
}

method {:test} Test12() {
var seqint0 : seq<int> := [55, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 52];
var r0 := DeepCopySeq(seqint0);
expect |r0| == |seqint0|;
expect forall i :: 0 <= i < |seqint0| ==> r0[i] == seqint0[i];
}

method {:test} Test13() {
var seqint0 : seq<int> := [66, 0, 0];
var r0 := DeepCopySeq(seqint0);
expect |r0| == |seqint0|;
expect forall i :: 0 <= i < |seqint0| ==> r0[i] == seqint0[i];
}

method {:test} Test14() {
var seqint0 : seq<int> := [71, 68, 0, 0];
var r0 := DeepCopySeq(seqint0);
expect |r0| == |seqint0|;
expect forall i :: 0 <= i < |seqint0| ==> r0[i] == seqint0[i];
}

method {:test} Test15() {
var seqint0 : seq<int> := [84, 77, 0, 0, 79, 0, 0, 0, 0, 0, 0, 0, 0, 81];
var r0 := DeepCopySeq(seqint0);
expect |r0| == |seqint0|;
expect forall i :: 0 <= i < |seqint0| ==> r0[i] == seqint0[i];
}

method {:test} Test16() {
var seqint0 : seq<int> := [96, 0, 0, 97, 0];
var r0 := DeepCopySeq(seqint0);
expect |r0| == |seqint0|;
expect forall i :: 0 <= i < |seqint0| ==> r0[i] == seqint0[i];
}

method {:test} Test17() {
var seqint0 : seq<int> := [100, 0, 0, 0, 103, 0, 0, 0, 101, 0, 0, 0, 0, 105];
var r0 := DeepCopySeq(seqint0);
expect |r0| == |seqint0|;
expect forall i :: 0 <= i < |seqint0| ==> r0[i] == seqint0[i];
}

method {:test} Test18() {
var seqint0 : seq<int> := [126, 116, 0, 0, 120, 122];
var r0 := DeepCopySeq(seqint0);
expect |r0| == |seqint0|;
expect forall i :: 0 <= i < |seqint0| ==> r0[i] == seqint0[i];
}

