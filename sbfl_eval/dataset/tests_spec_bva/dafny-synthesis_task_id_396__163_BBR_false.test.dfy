// dafny-synthesis_task_id_396.dfy

method {:testEntry} StartAndEndWithSameChar(s: string) returns (result: bool)
  requires |s| > 0
  ensures result <==> s[0] == s[|s| - 1]
{
  result := false;
}

method {:test} Test0() {
expect |"\0aaaaaaa\0"| > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := StartAndEndWithSameChar("\0aaaaaaa\0");
expect r0 <==> "\0aaaaaaa\0"[0] == "\0aaaaaaa\0"[|"\0aaaaaaa\0"| - 1];
}
method {:test} Test1() {
expect |"\0"| > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := StartAndEndWithSameChar("\0");
expect r0 <==> "\0"[0] == "\0"[|"\0"| - 1];
}
method {:test} Test2() {
expect |"\0\0"| > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := StartAndEndWithSameChar("\0\0");
expect r0 <==> "\0\0"[0] == "\0\0"[|"\0\0"| - 1];
}
method {:test} Test7() {
expect |"\0aaaaaaa\U{0002}"| > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := StartAndEndWithSameChar("\0aaaaaaa\U{0002}");
expect r0 <==> "\0aaaaaaa\U{0002}"[0] == "\0aaaaaaa\U{0002}"[|"\0aaaaaaa\U{0002}"| - 1];
}
method {:test} Test8() {
expect |"\0\U{0002}"| > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := StartAndEndWithSameChar("\0\U{0002}");
expect r0 <==> "\0\U{0002}"[0] == "\0\U{0002}"[|"\0\U{0002}"| - 1];
}

// REPEAT 1 - TIME: 9.1942203 s

method {:test} Test13() {
expect |"\U{0002}\U{0004}aaaaaaaaaaaaaaa\U{0006}\0\U{0002}"| > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := StartAndEndWithSameChar("\U{0002}\U{0004}aaaaaaaaaaaaaaa\U{0006}\0\U{0002}");
expect r0 <==> "\U{0002}\U{0004}aaaaaaaaaaaaaaa\U{0006}\0\U{0002}"[0] == "\U{0002}\U{0004}aaaaaaaaaaaaaaa\U{0006}\0\U{0002}"[|"\U{0002}\U{0004}aaaaaaaaaaaaaaa\U{0006}\0\U{0002}"| - 1];
}
method {:test} Test14() {
expect |"\0\U{0004}aaaaaaaa\U{0006}aaaaaaaaaaaaaaaa\U{0002}"| > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := StartAndEndWithSameChar("\0\U{0004}aaaaaaaa\U{0006}aaaaaaaaaaaaaaaa\U{0002}");
expect r0 <==> "\0\U{0004}aaaaaaaa\U{0006}aaaaaaaaaaaaaaaa\U{0002}"[0] == "\0\U{0004}aaaaaaaa\U{0006}aaaaaaaaaaaaaaaa\U{0002}"[|"\0\U{0004}aaaaaaaa\U{0006}aaaaaaaaaaaaaaaa\U{0002}"| - 1];
}

// REPEAT 2 - TIME: 10.2878052 s

method {:test} Test15() {
expect |"\0aaaaaaaaaa\0"| > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := StartAndEndWithSameChar("\0aaaaaaaaaa\0");
expect r0 <==> "\0aaaaaaaaaa\0"[0] == "\0aaaaaaaaaa\0"[|"\0aaaaaaaaaa\0"| - 1];
}
method {:test} Test16() {
expect |"\U{0006}\0aaaaaa\U{0002}\U{0004}"| > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := StartAndEndWithSameChar("\U{0006}\0aaaaaa\U{0002}\U{0004}");
expect r0 <==> "\U{0006}\0aaaaaa\U{0002}\U{0004}"[0] == "\U{0006}\0aaaaaa\U{0002}\U{0004}"[|"\U{0006}\0aaaaaa\U{0002}\U{0004}"| - 1];
}

// REPEAT 3 - TIME: 11.3526765 s

method {:test} Test17() {
expect |"\U{0008}\0aaaaa\U{0002}a\U{0006}aa\U{0004}aaaaaaaaaaaaaaa\U{0008}"| > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := StartAndEndWithSameChar("\U{0008}\0aaaaa\U{0002}a\U{0006}aa\U{0004}aaaaaaaaaaaaaaa\U{0008}");
expect r0 <==> "\U{0008}\0aaaaa\U{0002}a\U{0006}aa\U{0004}aaaaaaaaaaaaaaa\U{0008}"[0] == "\U{0008}\0aaaaa\U{0002}a\U{0006}aa\U{0004}aaaaaaaaaaaaaaa\U{0008}"[|"\U{0008}\0aaaaa\U{0002}a\U{0006}aa\U{0004}aaaaaaaaaaaaaaa\U{0008}"| - 1];
}
method {:test} Test18() {
expect |"\n\0aaaaa\U{0002}a\U{0006}\U{0004}aaaaaaaaaaaaaaaaa\U{0008}"| > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := StartAndEndWithSameChar("\n\0aaaaa\U{0002}a\U{0006}\U{0004}aaaaaaaaaaaaaaaaa\U{0008}");
expect r0 <==> "\n\0aaaaa\U{0002}a\U{0006}\U{0004}aaaaaaaaaaaaaaaaa\U{0008}"[0] == "\n\0aaaaa\U{0002}a\U{0006}\U{0004}aaaaaaaaaaaaaaaaa\U{0008}"[|"\n\0aaaaa\U{0002}a\U{0006}\U{0004}aaaaaaaaaaaaaaaaa\U{0008}"| - 1];
}

// REPEAT 4 - TIME: 12.3708732 s

method {:test} Test19() {
expect |"\U{0002}\0aaa\U{0002}"| > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := StartAndEndWithSameChar("\U{0002}\0aaa\U{0002}");
expect r0 <==> "\U{0002}\0aaa\U{0002}"[0] == "\U{0002}\0aaa\U{0002}"[|"\U{0002}\0aaa\U{0002}"| - 1];
}
method {:test} Test20() {
expect |"\U{0004}\U{0002}aaa\0"| > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := StartAndEndWithSameChar("\U{0004}\U{0002}aaa\0");
expect r0 <==> "\U{0004}\U{0002}aaa\0"[0] == "\U{0004}\U{0002}aaa\0"[|"\U{0004}\U{0002}aaa\0"| - 1];
}

// REPEAT 5 - TIME: 13.5684083 s
