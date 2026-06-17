method {:testEntry} StartAndEndWithSameChar(s: string) returns (result: bool)
    requires |s| > 0
    ensures result <==> s[0] == s[|s| - 1]
{
    result := s[0] == s[|s| - 1];
}

method {:test} Test0() {
expect |"\0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\0"| > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := StartAndEndWithSameChar("\0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\0");
expect r0 <==> "\0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\0"[0] == "\0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\0"[|"\0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\0"| - 1];
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
expect |"\0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\U{0002}"| > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := StartAndEndWithSameChar("\0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\U{0002}");
expect r0 <==> "\0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\U{0002}"[0] == "\0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\U{0002}"[|"\0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\U{0002}"| - 1];
}
method {:test} Test8() {
expect |"\0\U{0002}"| > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := StartAndEndWithSameChar("\0\U{0002}");
expect r0 <==> "\0\U{0002}"[0] == "\0\U{0002}"[|"\0\U{0002}"| - 1];
}

// REPEAT 1 - TIME: 9.3031816 s

method {:test} Test13() {
expect |"\0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\U{0004}aaa\U{0002}aaaaaaaa\0"| > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := StartAndEndWithSameChar("\0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\U{0004}aaa\U{0002}aaaaaaaa\0");
expect r0 <==> "\0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\U{0004}aaa\U{0002}aaaaaaaa\0"[0] == "\0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\U{0004}aaa\U{0002}aaaaaaaa\0"[|"\0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\U{0004}aaa\U{0002}aaaaaaaa\0"| - 1];
}
method {:test} Test14() {
expect |"\U{0002}\0aaaaaaaaa\U{0004}"| > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := StartAndEndWithSameChar("\U{0002}\0aaaaaaaaa\U{0004}");
expect r0 <==> "\U{0002}\0aaaaaaaaa\U{0004}"[0] == "\U{0002}\0aaaaaaaaa\U{0004}"[|"\U{0002}\0aaaaaaaaa\U{0004}"| - 1];
}

// REPEAT 2 - TIME: 10.4056048 s

method {:test} Test15() {
expect |"\0\U{0002}a\U{0004}aaaaaaaaaaa\0"| > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := StartAndEndWithSameChar("\0\U{0002}a\U{0004}aaaaaaaaaaa\0");
expect r0 <==> "\0\U{0002}a\U{0004}aaaaaaaaaaa\0"[0] == "\0\U{0002}a\U{0004}aaaaaaaaaaa\0"[|"\0\U{0002}a\U{0004}aaaaaaaaaaa\0"| - 1];
}
method {:test} Test16() {
expect |"\U{0002}\0aa\U{0008}aa\U{0004}aaaaaaa\U{0006}\n"| > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := StartAndEndWithSameChar("\U{0002}\0aa\U{0008}aa\U{0004}aaaaaaa\U{0006}\n");
expect r0 <==> "\U{0002}\0aa\U{0008}aa\U{0004}aaaaaaa\U{0006}\n"[0] == "\U{0002}\0aa\U{0008}aa\U{0004}aaaaaaa\U{0006}\n"[|"\U{0002}\0aa\U{0008}aa\U{0004}aaaaaaa\U{0006}\n"| - 1];
}

// REPEAT 3 - TIME: 11.5388147 s

method {:test} Test17() {
expect |"\0aaaaaaaaaaa\0"| > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := StartAndEndWithSameChar("\0aaaaaaaaaaa\0");
expect r0 <==> "\0aaaaaaaaaaa\0"[0] == "\0aaaaaaaaaaa\0"[|"\0aaaaaaaaaaa\0"| - 1];
}
method {:test} Test18() {
expect |"\0\U{0004}a\U{000C}aaaaaaaa\U{0006}aaa\U{0008}\naa\U{0002}"| > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := StartAndEndWithSameChar("\0\U{0004}a\U{000C}aaaaaaaa\U{0006}aaa\U{0008}\naa\U{0002}");
expect r0 <==> "\0\U{0004}a\U{000C}aaaaaaaa\U{0006}aaa\U{0008}\naa\U{0002}"[0] == "\0\U{0004}a\U{000C}aaaaaaaa\U{0006}aaa\U{0008}\naa\U{0002}"[|"\0\U{0004}a\U{000C}aaaaaaaa\U{0006}aaa\U{0008}\naa\U{0002}"| - 1];
}

// REPEAT 4 - TIME: 12.7768444 s

method {:test} Test19() {
expect |"\0\U{0002}aaaaaaaaaaaaaa\U{0006}\U{0008}aaa\naaaaaaaaaaaaa\U{0004}aaaaaaaaaaaa\0"| > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := StartAndEndWithSameChar("\0\U{0002}aaaaaaaaaaaaaa\U{0006}\U{0008}aaa\naaaaaaaaaaaaa\U{0004}aaaaaaaaaaaa\0");
expect r0 <==> "\0\U{0002}aaaaaaaaaaaaaa\U{0006}\U{0008}aaa\naaaaaaaaaaaaa\U{0004}aaaaaaaaaaaa\0"[0] == "\0\U{0002}aaaaaaaaaaaaaa\U{0006}\U{0008}aaa\naaaaaaaaaaaaa\U{0004}aaaaaaaaaaaa\0"[|"\0\U{0002}aaaaaaaaaaaaaa\U{0006}\U{0008}aaa\naaaaaaaaaaaaa\U{0004}aaaaaaaaaaaa\0"| - 1];
}
method {:test} Test20() {
expect |"\U{0006}\U{0002}a\U{0004}\0"| > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := StartAndEndWithSameChar("\U{0006}\U{0002}a\U{0004}\0");
expect r0 <==> "\U{0006}\U{0002}a\U{0004}\0"[0] == "\U{0006}\U{0002}a\U{0004}\0"[|"\U{0006}\U{0002}a\U{0004}\0"| - 1];
}

// REPEAT 5 - TIME: 13.7746219 s
