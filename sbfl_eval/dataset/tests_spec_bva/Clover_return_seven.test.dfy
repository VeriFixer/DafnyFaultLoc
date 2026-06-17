method {:testEntry} M(x: int) returns (seven: int)
  ensures seven==7
{
  seven := 7;
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

// REPEAT 1 - TIME: 5.0966157 s

method {:test} Test6() {
var r0 := M(24);
expect r0 == 7;
}

// REPEAT 2 - TIME: 5.9757524 s

method {:test} Test7() {
var r0 := M(25);
expect r0 == 7;
}

// REPEAT 3 - TIME: 7.0540823 s

method {:test} Test8() {
var r0 := M(26);
expect r0 == 7;
}

// REPEAT 4 - TIME: 8.0187341 s

method {:test} Test9() {
var r0 := M(27);
expect r0 == 7;
}

// REPEAT 5 - TIME: 9.0665782 s
