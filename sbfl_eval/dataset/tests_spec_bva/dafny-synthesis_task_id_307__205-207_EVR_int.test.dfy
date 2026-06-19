// dafny-synthesis_task_id_307.dfy

method {:testEntry} DeepCopySeq(s: seq<int>) returns (copy: seq<int>)
  ensures |copy| == |s|
  ensures forall i :: 0 <= i < |s| ==> copy[i] == s[i]
{
  var newSeq: seq<int> := [];
  for i := 0 to 0
    invariant 0 <= i <= |s|
    invariant |newSeq| == i
    invariant forall k :: 0 <= k < i ==> newSeq[k] == s[k]
  {
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

// REPEAT 1 - TIME: 7.2243239 s

method {:test} Test10() {
var seqint0 : seq<int> := [0, 28, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29];
var r0 := DeepCopySeq(seqint0);
expect |r0| == |seqint0|;
expect forall i :: 0 <= i < |seqint0| ==> r0[i] == seqint0[i];
}

// REPEAT 2 - TIME: 8.1568411 s

method {:test} Test11() {
var seqint0 : seq<int> := [44, 42, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 46];
var r0 := DeepCopySeq(seqint0);
expect |r0| == |seqint0|;
expect forall i :: 0 <= i < |seqint0| ==> r0[i] == seqint0[i];
}

// REPEAT 3 - TIME: 8.8582393 s

method {:test} Test12() {
var seqint0 : seq<int> := [55, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 52];
var r0 := DeepCopySeq(seqint0);
expect |r0| == |seqint0|;
expect forall i :: 0 <= i < |seqint0| ==> r0[i] == seqint0[i];
}

// REPEAT 4 - TIME: 9.5802358 s

method {:test} Test13() {
var seqint0 : seq<int> := [66, 0, 0];
var r0 := DeepCopySeq(seqint0);
expect |r0| == |seqint0|;
expect forall i :: 0 <= i < |seqint0| ==> r0[i] == seqint0[i];
}

// REPEAT 5 - TIME: 10.3070086 s
