method {:testEntry} Swap(a: int, b: int) returns (result: seq<int>)
    ensures |result| == 2
    ensures result[0] == b
    ensures result[1] == a
{
    result := [b, a];
}

method {:test} Test0() {
var r0 := Swap(25, 24);
expect |r0| == 2;
expect r0[0] == 24;
expect r0[1] == 25;
}
method {:test} Test1() {
var r0 := Swap(-100, 24);
expect |r0| == 2;
expect r0[0] == 24;
expect r0[1] == -100;
}
method {:test} Test2() {
var r0 := Swap(100, 24);
expect |r0| == 2;
expect r0[0] == 24;
expect r0[1] == 100;
}
method {:test} Test3() {
var r0 := Swap(24, -100);
expect |r0| == 2;
expect r0[0] == -100;
expect r0[1] == 24;
}
method {:test} Test4() {
var r0 := Swap(24, 100);
expect |r0| == 2;
expect r0[0] == 100;
expect r0[1] == 24;
}

// REPEAT 1 - TIME: 5.8903815 s

method {:test} Test8() {
var r0 := Swap(27, 26);
expect |r0| == 2;
expect r0[0] == 26;
expect r0[1] == 27;
}

// REPEAT 2 - TIME: 6.7465491 s

method {:test} Test9() {
var r0 := Swap(29, 28);
expect |r0| == 2;
expect r0[0] == 28;
expect r0[1] == 29;
}

// REPEAT 3 - TIME: 7.5266134 s

method {:test} Test10() {
var r0 := Swap(31, 30);
expect |r0| == 2;
expect r0[0] == 30;
expect r0[1] == 31;
}

// REPEAT 4 - TIME: 8.3758865 s

method {:test} Test11() {
var r0 := Swap(33, 32);
expect |r0| == 2;
expect r0[0] == 32;
expect r0[1] == 33;
}

// REPEAT 5 - TIME: 8.9555205 s
