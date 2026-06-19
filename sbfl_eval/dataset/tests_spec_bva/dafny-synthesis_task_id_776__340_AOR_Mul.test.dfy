// dafny-synthesis_task_id_776.dfy

predicate IsVowel(c: char)
{
  c in {'a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U'}
}

method {:testEntry} CountVowelNeighbors(s: string) returns (count: int)
  ensures count >= 0
  ensures count == |set i: int | 1 <= i < |s| - 1 && IsVowel(s[i - 1]) && IsVowel(s[i + 1])|
{
  var vowels := set i: int | 1 <= i < |s| - 1 && IsVowel(s[i * 1]) && IsVowel(s[i + 1]);
  count := |vowels|;
}


method {:test} Test0() {
var r0 := CountVowelNeighbors("aaaaaaaaa");
expect r0 >= 0;
}
method {:test} Test1() {
var r0 := CountVowelNeighbors("");
expect r0 >= 0;
}
method {:test} Test2() {
var r0 := CountVowelNeighbors("a");
expect r0 >= 0;
}
method {:test} Test3() {
var r0 := CountVowelNeighbors("aaaaaaaaaaa");
expect r0 >= 0;
}

// REPEAT 1 - TIME: 6.4494216 s

method {:test} Test9() {
var r0 := CountVowelNeighbors("\U{0002}a\0aaaaa");
expect r0 >= 0;
}

// REPEAT 2 - TIME: 7.250234 s

method {:test} Test10() {
var r0 := CountVowelNeighbors("\U{0006}\0a\U{0001}aaaa\U{0004}a");
expect r0 >= 0;
}

// REPEAT 3 - TIME: 8.1077084 s

method {:test} Test11() {
var r0 := CountVowelNeighbors("\U{0002}a\0aa");
expect r0 >= 0;
}

// REPEAT 4 - TIME: 8.8997687 s

method {:test} Test12() {
var r0 := CountVowelNeighbors("\U{0002}a\0aaaa");
expect r0 >= 0;
}

// REPEAT 5 - TIME: 9.5689227 s
