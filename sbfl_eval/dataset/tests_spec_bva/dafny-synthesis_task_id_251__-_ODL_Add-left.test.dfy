// dafny-synthesis_task_id_251.dfy

method {:testEntry} InsertBeforeEach(s: seq<string>, x: string) returns (v: seq<string>)
  ensures |v| == 2 * |s|
  ensures forall i :: 0 <= i < |s| ==> v[2 * i] == x && v[2 * i + 1] == s[i]
{
  v := [];
  for i := 0 to |s|
    invariant 0 <= i <= |s|
    invariant |v| == 2 * i
    invariant forall j :: 0 <= j < i ==> v[2 * j] == x && v[2 * j + 1] == s[j]
  {
    v := [x, s[i]];
  }
}


method {:testEntry} InsertBeforeEach(s: seq<string>, x: string) returns (v: seq<string>)
        ensures |v| == 2 * |s|
        ensures forall i :: 0 <= i < |s| ==> v[2*i] == x && v[2*i + 1] == s[i]
    {
        v := [];
        for i := 0 to |s|
            invariant 0 <= i <= |s|
            invariant |v| == 2 * i
            invariant forall j :: 0 <= j < i ==> v[2*j] == x && v[2*j + 1] == s[j]
        {
            v := v + [x, s[i]];
        }
    }

method {:test} Test0() {
var seqstring0 : seq<string> := [""];
var r0 := InsertBeforeEach(seqstring0, "");
expect |r0| == 2 * |seqstring0|;
expect forall i :: 0 <= i < |seqstring0| ==> r0[2 * i] == "" && r0[2 * i + 1] == seqstring0[i];
}
method {:test} Test1() {
var seqstring0 : seq<string> := [];
var r0 := InsertBeforeEach(seqstring0, "");
expect |r0| == 2 * |seqstring0|;
expect forall i :: 0 <= i < |seqstring0| ==> r0[2 * i] == "" && r0[2 * i + 1] == seqstring0[i];
}
method {:test} Test3() {
var seqstring0 : seq<string> := ["", "", "", "", "", "", "", "", "", "", "", ""];
var r0 := InsertBeforeEach(seqstring0, "");
expect |r0| == 2 * |seqstring0|;
expect forall i :: 0 <= i < |seqstring0| ==> r0[2 * i] == "" && r0[2 * i + 1] == seqstring0[i];
}
method {:test} Test5() {
var seqstring0 : seq<string> := [""];
var r0 := InsertBeforeEach(seqstring0, "a");
expect |r0| == 2 * |seqstring0|;
expect forall i :: 0 <= i < |seqstring0| ==> r0[2 * i] == "a" && r0[2 * i + 1] == seqstring0[i];
}
method {:test} Test6() {
var seqstring0 : seq<string> := [""];
var r0 := InsertBeforeEach(seqstring0, "aa");
expect |r0| == 2 * |seqstring0|;
expect forall i :: 0 <= i < |seqstring0| ==> r0[2 * i] == "aa" && r0[2 * i + 1] == seqstring0[i];
}

// REPEAT 1 - TIME: 7.1822067 s

method {:test} Test10() {
var seqstring0 : seq<string> := ["", "", "", "", "", "", "", "", "", "", "", "", ""];
var r0 := InsertBeforeEach(seqstring0, "\0\U{0002}a");
expect |r0| == 2 * |seqstring0|;
expect forall i :: 0 <= i < |seqstring0| ==> r0[2 * i] == "\0\U{0002}a" && r0[2 * i + 1] == seqstring0[i];
}

// REPEAT 2 - TIME: 8.0674666 s

method {:test} Test11() {
var seqstring0 : seq<string> := ["", "", "", "", "", "", "", "", "", "", "", "", "", ""];
var r0 := InsertBeforeEach(seqstring0, "\U{0004}\0aaaaaaaaaa\U{0002}");
expect |r0| == 2 * |seqstring0|;
expect forall i :: 0 <= i < |seqstring0| ==> r0[2 * i] == "\U{0004}\0aaaaaaaaaa\U{0002}" && r0[2 * i + 1] == seqstring0[i];
}

// REPEAT 3 - TIME: 8.9004514 s

method {:test} Test12() {
var seqstring0 : seq<string> := ["", "", "", "", "", "", "", "", "", "", "", "", "", "", ""];
var r0 := InsertBeforeEach(seqstring0, "\U{0006}\0\U{0002}\U{0004}");
expect |r0| == 2 * |seqstring0|;
expect forall i :: 0 <= i < |seqstring0| ==> r0[2 * i] == "\U{0006}\0\U{0002}\U{0004}" && r0[2 * i + 1] == seqstring0[i];
}

// REPEAT 4 - TIME: 9.8587974 s

method {:test} Test13() {
var seqstring0 : seq<string> := ["", "", "", "", "", "", "", "", "", "", ""];
var r0 := InsertBeforeEach(seqstring0, "\U{0002}aa\0aaaaaaaaa\U{0004}");
expect |r0| == 2 * |seqstring0|;
expect forall i :: 0 <= i < |seqstring0| ==> r0[2 * i] == "\U{0002}aa\0aaaaaaaaa\U{0004}" && r0[2 * i + 1] == seqstring0[i];
}

// REPEAT 5 - TIME: 10.6787062 s
