method {:testEntry} Main()
{
  var i := 2;
  var s := [0, i, 3, 4, 5];
  print |s|;
  assert s[|s| - 1] == 5;
  assert s[|s| - 1 .. |s|] == [5];
  assert s[1..] == [2, 3, 4, 5];
  assert s[..|s| - 1] == [1, 2, 3, 4];
  assert s == s[0..] == s[..|s|] == s[0 .. |s|] == s[..];
}

method {:testEntry} foo(s: seq<int>)
  requires |s| > 1
{
  print s[1];
}


method {:test} Test0() {
Main();
}
method {:test} Test3() {
var seqint0 : seq<int> := [0, 0];
expect |seqint0| > 1, "If this check fails at runtime, the test does not meet the preconditions";
foo(seqint0);
}

method {:test} Test7() {
var seqint0 : seq<int> := [1, 0];
expect |seqint0| > 1, "If this check fails at runtime, the test does not meet the preconditions";
foo(seqint0);
}

method {:test} Test8() {
var seqint0 : seq<int> := [4, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2];
expect |seqint0| > 1, "If this check fails at runtime, the test does not meet the preconditions";
foo(seqint0);
}

method {:test} Test9() {
var seqint0 : seq<int> := [3, 0];
expect |seqint0| > 1, "If this check fails at runtime, the test does not meet the preconditions";
foo(seqint0);
}

method {:test} Test10() {
var seqint0 : seq<int> := [5, 0, 0];
expect |seqint0| > 1, "If this check fails at runtime, the test does not meet the preconditions";
foo(seqint0);
}

method {:test} Test11() {
var seqint0 : seq<int> := [6, 0, 0, 0];
expect |seqint0| > 1, "If this check fails at runtime, the test does not meet the preconditions";
foo(seqint0);
}

method {:test} Test12() {
var seqint0 : seq<int> := [7, 0, 0, 0, 0, 9];
expect |seqint0| > 1, "If this check fails at runtime, the test does not meet the preconditions";
foo(seqint0);
}

method {:test} Test13() {
var seqint0 : seq<int> := [8, 0];
expect |seqint0| > 1, "If this check fails at runtime, the test does not meet the preconditions";
foo(seqint0);
}

method {:test} Test14() {
var seqint0 : seq<int> := [10, 0, 0, 0, 12];
expect |seqint0| > 1, "If this check fails at runtime, the test does not meet the preconditions";
foo(seqint0);
}

method {:test} Test15() {
var seqint0 : seq<int> := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 14, 11, 16];
expect |seqint0| > 1, "If this check fails at runtime, the test does not meet the preconditions";
foo(seqint0);
}

