// dafny-synthesis_task_id_586.dfy

method {:testEntry} SplitAndAppend(l: seq<int>, n: int) returns (r: seq<int>)
  requires n >= 0 && n < |l|
  ensures |r| == |l|
  ensures forall i :: 0 <= i < |l| ==> r[i] == l[(i + n) % |l|]
{
  var firstPart: seq<int> := l[..n];
  var secondPart: seq<int> := l[n..];
  r := secondPart;
}

method {:test} Test0() {
var seqint0 : seq<int> := [0];
expect 0 >= 0 && 0 < |seqint0|, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SplitAndAppend(seqint0, 0);
expect |r0| == |seqint0|;
expect forall i :: 0 <= i < |seqint0| ==> r0[i] == seqint0[(i + 0) % |seqint0|];
}
method {:test} Test2() {
var seqint0 : seq<int> := [0, 0];
expect 0 >= 0 && 0 < |seqint0|, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SplitAndAppend(seqint0, 0);
expect |r0| == |seqint0|;
expect forall i :: 0 <= i < |seqint0| ==> r0[i] == seqint0[(i + 0) % |seqint0|];
}

// REPEAT 1 - TIME: 7.3783942 s

method {:test} Test9() {
var seqint0 : seq<int> := [0, 1, 0];
expect 1 >= 0 && 1 < |seqint0|, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SplitAndAppend(seqint0, 1);
expect |r0| == |seqint0|;
expect forall i :: 0 <= i < |seqint0| ==> r0[i] == seqint0[(i + 1) % |seqint0|];
}

// REPEAT 2 - TIME: 8.1297942 s

method {:test} Test10() {
var seqint0 : seq<int> := [4, 0, 0, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 0, 6];
expect 2 >= 0 && 2 < |seqint0|, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SplitAndAppend(seqint0, 2);
expect |r0| == |seqint0|;
expect forall i :: 0 <= i < |seqint0| ==> r0[i] == seqint0[(i + 2) % |seqint0|];
}

// REPEAT 3 - TIME: 8.9076072 s

method {:test} Test11() {
var seqint0 : seq<int> := [3, 0, 0, 0];
expect 3 >= 0 && 3 < |seqint0|, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SplitAndAppend(seqint0, 3);
expect |r0| == |seqint0|;
expect forall i :: 0 <= i < |seqint0| ==> r0[i] == seqint0[(i + 3) % |seqint0|];
}

// REPEAT 4 - TIME: 9.6772555 s

method {:test} Test12() {
var seqint0 : seq<int> := [5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
expect 4 >= 0 && 4 < |seqint0|, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SplitAndAppend(seqint0, 4);
expect |r0| == |seqint0|;
expect forall i :: 0 <= i < |seqint0| ==> r0[i] == seqint0[(i + 4) % |seqint0|];
}

// REPEAT 5 - TIME: 10.2693249 s
