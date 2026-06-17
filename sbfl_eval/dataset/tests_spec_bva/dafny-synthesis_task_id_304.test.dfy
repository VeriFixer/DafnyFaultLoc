method {:testEntry} ElementAtIndexAfterRotation(l: seq<int>, n: int, index: int) returns (element: int)
    requires n >= 0
    requires 0 <= index < |l|
    ensures element == l[(index - n + |l|) % |l|]
{
    element := l[(index - n + |l|) % |l|];
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
var seqint0 : seq<int> := [25, 0, 0, 0];
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

// REPEAT 1 - TIME: 8.097626 s

method {:test} Test11() {
var seqint0 : seq<int> := [0, 28, 2];
expect 2283 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 0 <= 1 < |seqint0|, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ElementAtIndexAfterRotation(seqint0, 2283, 1);
expect r0 == seqint0[(1 - 2283 + |seqint0|) % |seqint0|];
}

// REPEAT 2 - TIME: 8.9315785 s

method {:test} Test12() {
var seqint0 : seq<int> := [29, 3, 5, 7, 0];
expect 2284 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 0 <= 4 < |seqint0|, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ElementAtIndexAfterRotation(seqint0, 2284, 4);
expect r0 == seqint0[(4 - 2284 + |seqint0|) % |seqint0|];
}

// REPEAT 3 - TIME: 9.6135052 s

method {:test} Test13() {
var seqint0 : seq<int> := [30, 0, 0, 0, 4, 8];
expect 2285 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 0 <= 5 < |seqint0|, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ElementAtIndexAfterRotation(seqint0, 2285, 5);
expect r0 == seqint0[(5 - 2285 + |seqint0|) % |seqint0|];
}

// REPEAT 4 - TIME: 10.3312236 s

method {:test} Test14() {
var seqint0 : seq<int> := [6, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 31, 0, 0, 0];
expect 2294 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
expect 0 <= 28 < |seqint0|, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ElementAtIndexAfterRotation(seqint0, 2294, 28);
expect r0 == seqint0[(28 - 2294 + |seqint0|) % |seqint0|];
}

// REPEAT 5 - TIME: 11.0393012 s
