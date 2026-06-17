method {:testEntry} AsciiValue(c: char) returns (ascii: int)
    ensures ascii == c as int
{
    ascii := c as int;
}

method {:test} Test0() {
var r0 := AsciiValue('&');
expect r0 == '&' as int;
}
method {:test} Test2() {
var r0 := AsciiValue('d');
expect r0 == 'd' as int;
}

// REPEAT 1 - TIME: 4.8890352 s

method {:test} Test5() {
var r0 := AsciiValue('%');
expect r0 == '%' as int;
}

// REPEAT 2 - TIME: 5.715257 s

method {:test} Test6() {
var r0 := AsciiValue('\U{0005}');
expect r0 == '\U{0005}' as int;
}

// REPEAT 3 - TIME: 6.5369853 s

method {:test} Test7() {
var r0 := AsciiValue('\U{0004}');
expect r0 == '\U{0004}' as int;
}

// REPEAT 4 - TIME: 7.2713054 s

method {:test} Test8() {
var r0 := AsciiValue('\U{0003}');
expect r0 == '\U{0003}' as int;
}

// REPEAT 5 - TIME: 7.9454014 s
