method {:testEntry} CountCharacters(s: string) returns (count: int)
    ensures count >= 0
    ensures count == |s|
{
    count := |s|;
}

method {:test} Test0() {
var r0 := CountCharacters("a");
expect r0 >= 0;
expect r0 == |"a"|;
}
method {:test} Test1() {
var r0 := CountCharacters("");
expect r0 >= 0;
expect r0 == |""|;
}
method {:test} Test3() {
var r0 := CountCharacters("aa");
expect r0 >= 0;
expect r0 == |"aa"|;
}

// REPEAT 1 - TIME: 6.4094561 s

method {:test} Test8() {
var r0 := CountCharacters("a\0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\U{0002}");
expect r0 >= 0;
expect r0 == |"a\0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\U{0002}"|;
}

// REPEAT 2 - TIME: 7.251343 s

method {:test} Test9() {
var r0 := CountCharacters("\U{0002}\0");
expect r0 >= 0;
expect r0 == |"\U{0002}\0"|;
}

// REPEAT 3 - TIME: 8.151903 s

method {:test} Test10() {
var r0 := CountCharacters("\U{0004}\0\U{0002}");
expect r0 >= 0;
expect r0 == |"\U{0004}\0\U{0002}"|;
}

// REPEAT 4 - TIME: 8.8578554 s

method {:test} Test11() {
var r0 := CountCharacters("\0");
expect r0 >= 0;
expect r0 == |"\0"|;
}

// REPEAT 5 - TIME: 9.6264412 s
