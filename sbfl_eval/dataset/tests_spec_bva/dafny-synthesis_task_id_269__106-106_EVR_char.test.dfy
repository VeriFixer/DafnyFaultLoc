// dafny-synthesis_task_id_269.dfy

method {:testEntry} AsciiValue(c: char) returns (ascii: int)
  ensures ascii == c as int
{
  ascii := '0' as int;
}

method {:test} Test0() {
var r0 := AsciiValue('&');
expect r0 == '&' as int;
}
method {:test} Test2() {
var r0 := AsciiValue('d');
expect r0 == 'd' as int;
}

// REPEAT 1 - TIME: 4.6121526 s

method {:test} Test5() {
var r0 := AsciiValue('%');
expect r0 == '%' as int;
}

// REPEAT 2 - TIME: 5.4905236 s

method {:test} Test6() {
var r0 := AsciiValue('\U{0005}');
expect r0 == '\U{0005}' as int;
}

// REPEAT 3 - TIME: 6.4446764 s

method {:test} Test7() {
var r0 := AsciiValue('\U{0004}');
expect r0 == '\U{0004}' as int;
}

// REPEAT 4 - TIME: 7.2258261 s

method {:test} Test8() {
var r0 := AsciiValue('\U{0003}');
expect r0 == '\U{0003}' as int;
}

// REPEAT 5 - TIME: 8.0637147 s
