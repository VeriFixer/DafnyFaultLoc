// dafny-synthesis_task_id_304.dfy

method {:testEntry} ElementAtIndexAfterRotation(l: seq<int>, n: int, index: int)
    returns (element: int)
  requires n >= 0
  requires 0 <= index < |l|
  ensures element == l[(index - n + |l|) % |l|]
{
  element := l[|l| % |l|];
}

method {:test} Test0() {
var seqint0 : seq<int> := [26];
expect 2282 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 0 <= 0 < |seqint0|, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ElementAtIndexAfterRotation(seqint0, 2282, 0);
expect r0 == seqint0[(0 - 2282 + |seqint0|) % |seqint0|];
}
method {:test} Test1() {
var seqint0 : seq<int> := [26];
expect 38 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 0 <= 0 < |seqint0|, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ElementAtIndexAfterRotation(seqint0, 38, 0);
expect r0 == seqint0[(0 - 38 + |seqint0|) % |seqint0|];
}
method {:test} Test2() {
var seqint0 : seq<int> := [26, 0];
expect 1218 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 0 <= 0 < |seqint0|, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ElementAtIndexAfterRotation(seqint0, 1218, 0);
expect r0 == seqint0[(0 - 1218 + |seqint0|) % |seqint0|];
}
method {:test} Test3() {
var seqint0 : seq<int> := [25];
expect 0 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 0 <= 0 < |seqint0|, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ElementAtIndexAfterRotation(seqint0, 0, 0);
expect r0 == seqint0[(0 - 0 + |seqint0|) % |seqint0|];
}
method {:test} Test4() {
var seqint0 : seq<int> := [25];
expect 100 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 0 <= 0 < |seqint0|, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ElementAtIndexAfterRotation(seqint0, 100, 0);
expect r0 == seqint0[(0 - 100 + |seqint0|) % |seqint0|];
}
method {:test} Test5() {
var seqint0 : seq<int> := [25];
expect 2282 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 0 <= 0 < |seqint0|, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ElementAtIndexAfterRotation(seqint0, 2282, 0);
expect r0 == seqint0[(0 - 2282 + |seqint0|) % |seqint0|];
}
method {:test} Test7() {
var seqint0 : seq<int> := [-100];
expect 2282 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 0 <= 0 < |seqint0|, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ElementAtIndexAfterRotation(seqint0, 2282, 0);
expect r0 == seqint0[(0 - 2282 + |seqint0|) % |seqint0|];
}
method {:test} Test8() {
var seqint0 : seq<int> := [100];
expect 2282 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 0 <= 0 < |seqint0|, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ElementAtIndexAfterRotation(seqint0, 2282, 0);
expect r0 == seqint0[(0 - 2282 + |seqint0|) % |seqint0|];
}

// REPEAT 1 - TIME: 7.7481469 s

method {:test} Test11() {
var seqint0 : seq<int> := [0, 2, 28];
expect 2283 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 0 <= 2 < |seqint0|, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ElementAtIndexAfterRotation(seqint0, 2283, 2);
expect r0 == seqint0[(2 - 2283 + |seqint0|) % |seqint0|];
}

// REPEAT 2 - TIME: 8.6314583 s

method {:test} Test12() {
var seqint0 : seq<int> := [5, 29, 0, 3];
expect 2286 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 0 <= 3 < |seqint0|, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ElementAtIndexAfterRotation(seqint0, 2286, 3);
expect r0 == seqint0[(3 - 2286 + |seqint0|) % |seqint0|];
}

// REPEAT 3 - TIME: 9.4562173 s

method {:test} Test13() {
var seqint0 : seq<int> := [7, 4, 0, 9, 0, 30];
expect 2292 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 0 <= 5 < |seqint0|, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ElementAtIndexAfterRotation(seqint0, 2292, 5);
expect r0 == seqint0[(5 - 2292 + |seqint0|) % |seqint0|];
}

// REPEAT 4 - TIME: 10.2816466 s

method {:test} Test14() {
var seqint0 : seq<int> := [6, 0, 0, 0, 0, 0, 31];
expect 2296 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 0 <= 6 < |seqint0|, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ElementAtIndexAfterRotation(seqint0, 2296, 6);
expect r0 == seqint0[(6 - 2296 + |seqint0|) % |seqint0|];
}

// REPEAT 5 - TIME: 10.9980693 s
