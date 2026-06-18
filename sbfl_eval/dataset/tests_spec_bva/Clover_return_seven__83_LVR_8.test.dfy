// Clover_return_seven.dfy

method {:testEntry} M(x: int) returns (seven: int)
  ensures seven == 7
{
  seven := 8;
}

method {:test} Test0() {
var r0 := M(0);
expect r0 == 7;
}
method {:test} Test1() {
var r0 := M(-100);
expect r0 == 7;
}
method {:test} Test2() {
var r0 := M(100);
expect r0 == 7;
}

// REPEAT 1 - TIME: 4.508053 s

method {:test} Test6() {
var r0 := M(24);
expect r0 == 7;
}

// REPEAT 2 - TIME: 5.3661402 s

method {:test} Test7() {
var r0 := M(25);
expect r0 == 7;
}

// REPEAT 3 - TIME: 6.0796753 s

method {:test} Test8() {
var r0 := M(26);
expect r0 == 7;
}

// REPEAT 4 - TIME: 7.0555203 s

method {:test} Test9() {
var r0 := M(27);
expect r0 == 7;
}

// REPEAT 5 - TIME: 7.8970185 s
