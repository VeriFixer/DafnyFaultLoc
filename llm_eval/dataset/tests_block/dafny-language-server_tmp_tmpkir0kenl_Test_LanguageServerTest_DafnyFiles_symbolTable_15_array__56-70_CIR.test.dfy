method {:testEntry} Main()
{
  var i := 2;
  var s := [];
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
method {:test} Test1() {
var seqint0 : seq<int> := [0, 0];
expect |seqint0| > 1, "If this check fails at runtime, the test does not meet the preconditions";
foo(seqint0);
}

method {:test} Test2() {
var seqint0 : seq<int> := [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1];
expect |seqint0| > 1, "If this check fails at runtime, the test does not meet the preconditions";
foo(seqint0);
}

method {:test} Test3() {
var seqint0 : seq<int> := [2, 0];
expect |seqint0| > 1, "If this check fails at runtime, the test does not meet the preconditions";
foo(seqint0);
}

method {:test} Test4() {
var seqint0 : seq<int> := [3, 0, 0];
expect |seqint0| > 1, "If this check fails at runtime, the test does not meet the preconditions";
foo(seqint0);
}

method {:test} Test5() {
var seqint0 : seq<int> := [4, 0, 0];
expect |seqint0| > 1, "If this check fails at runtime, the test does not meet the preconditions";
foo(seqint0);
}

method {:test} Test6() {
var seqint0 : seq<int> := [5, 0, 0];
expect |seqint0| > 1, "If this check fails at runtime, the test does not meet the preconditions";
foo(seqint0);
}

method {:test} Test7() {
var seqint0 : seq<int> := [6, 0];
expect |seqint0| > 1, "If this check fails at runtime, the test does not meet the preconditions";
foo(seqint0);
}

method {:test} Test8() {
var seqint0 : seq<int> := [7, 0];
expect |seqint0| > 1, "If this check fails at runtime, the test does not meet the preconditions";
foo(seqint0);
}

method {:test} Test9() {
var seqint0 : seq<int> := [10, 0, 8, 0];
expect |seqint0| > 1, "If this check fails at runtime, the test does not meet the preconditions";
foo(seqint0);
}

method {:test} Test10() {
var seqint0 : seq<int> := [9, 0, 12, 14];
expect |seqint0| > 1, "If this check fails at runtime, the test does not meet the preconditions";
foo(seqint0);
}

