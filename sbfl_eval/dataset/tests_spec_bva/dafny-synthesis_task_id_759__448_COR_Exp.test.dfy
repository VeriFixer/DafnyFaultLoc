// dafny-synthesis_task_id_759.dfy

method {:testEntry} IsDecimalWithTwoPrecision(s: string) returns (result: bool)
  ensures result ==> exists i :: 0 <= i < |s| && s[i] == '.' && |s| - i - 1 == 2
  ensures !result ==> !exists i :: 0 <= i < |s| && s[i] == '.' && |s| - i - 1 == 2
{
  result := false;
  for i := 0 to |s|
    invariant 0 <= i <= |s|
    invariant result <==> exists k :: 0 <= k < i && s[k] == '.' && |s| - k - 1 == 2
  {
    if s[i] == '.' <== |s| - i - 1 == 2 {
      result := true;
      break;
    }
  }
}


method {:test} Test0() {
var r0 := IsDecimalWithTwoPrecision("");
expect r0 ==> exists i :: 0 <= i < |""| && ""[i] == '.' && |""| - i - 1 == 2;
expect !r0 ==> !exists i :: 0 <= i < |""| && ""[i] == '.' && |""| - i - 1 == 2;
}
method {:test} Test2() {
var r0 := IsDecimalWithTwoPrecision("a");
expect r0 ==> exists i :: 0 <= i < |"a"| && "a"[i] == '.' && |"a"| - i - 1 == 2;
expect !r0 ==> !exists i :: 0 <= i < |"a"| && "a"[i] == '.' && |"a"| - i - 1 == 2;
}
method {:test} Test3() {
var r0 := IsDecimalWithTwoPrecision("aa");
expect r0 ==> exists i :: 0 <= i < |"aa"| && "aa"[i] == '.' && |"aa"| - i - 1 == 2;
expect !r0 ==> !exists i :: 0 <= i < |"aa"| && "aa"[i] == '.' && |"aa"| - i - 1 == 2;
}
method {:test} Test8() {
var r0 := IsDecimalWithTwoPrecision("aaaaaaaaaaaaaaaaaaa.aa");
expect r0 ==> exists i :: 0 <= i < |"aaaaaaaaaaaaaaaaaaa.aa"| && "aaaaaaaaaaaaaaaaaaa.aa"[i] == '.' && |"aaaaaaaaaaaaaaaaaaa.aa"| - i - 1 == 2;
expect !r0 ==> !exists i :: 0 <= i < |"aaaaaaaaaaaaaaaaaaa.aa"| && "aaaaaaaaaaaaaaaaaaa.aa"[i] == '.' && |"aaaaaaaaaaaaaaaaaaa.aa"| - i - 1 == 2;
}
method {:test} Test9() {
var r0 := IsDecimalWithTwoPrecision("aaaaaaaaaaaaaaaaa.aa");
expect r0 ==> exists i :: 0 <= i < |"aaaaaaaaaaaaaaaaa.aa"| && "aaaaaaaaaaaaaaaaa.aa"[i] == '.' && |"aaaaaaaaaaaaaaaaa.aa"| - i - 1 == 2;
expect !r0 ==> !exists i :: 0 <= i < |"aaaaaaaaaaaaaaaaa.aa"| && "aaaaaaaaaaaaaaaaa.aa"[i] == '.' && |"aaaaaaaaaaaaaaaaa.aa"| - i - 1 == 2;
}
method {:test} Test10() {
var r0 := IsDecimalWithTwoPrecision("aaaaaaaaaa.aa");
expect r0 ==> exists i :: 0 <= i < |"aaaaaaaaaa.aa"| && "aaaaaaaaaa.aa"[i] == '.' && |"aaaaaaaaaa.aa"| - i - 1 == 2;
expect !r0 ==> !exists i :: 0 <= i < |"aaaaaaaaaa.aa"| && "aaaaaaaaaa.aa"[i] == '.' && |"aaaaaaaaaa.aa"| - i - 1 == 2;
}

// REPEAT 1 - TIME: 9.8612415 s

method {:test} Test14() {
var r0 := IsDecimalWithTwoPrecision("\0a");
expect r0 ==> exists i :: 0 <= i < |"\0a"| && "\0a"[i] == '.' && |"\0a"| - i - 1 == 2;
expect !r0 ==> !exists i :: 0 <= i < |"\0a"| && "\0a"[i] == '.' && |"\0a"| - i - 1 == 2;
}
method {:test} Test15() {
var r0 := IsDecimalWithTwoPrecision("\U{0007}\U{0001}aa\U{0003}aaaaaa.a\U{0005}");
expect r0 ==> exists i :: 0 <= i < |"\U{0007}\U{0001}aa\U{0003}aaaaaa.a\U{0005}"| && "\U{0007}\U{0001}aa\U{0003}aaaaaa.a\U{0005}"[i] == '.' && |"\U{0007}\U{0001}aa\U{0003}aaaaaa.a\U{0005}"| - i - 1 == 2;
expect !r0 ==> !exists i :: 0 <= i < |"\U{0007}\U{0001}aa\U{0003}aaaaaa.a\U{0005}"| && "\U{0007}\U{0001}aa\U{0003}aaaaaa.a\U{0005}"[i] == '.' && |"\U{0007}\U{0001}aa\U{0003}aaaaaa.a\U{0005}"| - i - 1 == 2;
}

// REPEAT 2 - TIME: 10.9064898 s

method {:test} Test16() {
var r0 := IsDecimalWithTwoPrecision("\U{0002}aaa\0aaaaaaaa\U{0004}\U{0006}");
expect r0 ==> exists i :: 0 <= i < |"\U{0002}aaa\0aaaaaaaa\U{0004}\U{0006}"| && "\U{0002}aaa\0aaaaaaaa\U{0004}\U{0006}"[i] == '.' && |"\U{0002}aaa\0aaaaaaaa\U{0004}\U{0006}"| - i - 1 == 2;
expect !r0 ==> !exists i :: 0 <= i < |"\U{0002}aaa\0aaaaaaaa\U{0004}\U{0006}"| && "\U{0002}aaa\0aaaaaaaa\U{0004}\U{0006}"[i] == '.' && |"\U{0002}aaa\0aaaaaaaa\U{0004}\U{0006}"| - i - 1 == 2;
}
method {:test} Test17() {
var r0 := IsDecimalWithTwoPrecision("\U{0003}\U{0001}aaaaaaaaaaa\U{0005}\U{0007}aaa.a\t");
expect r0 ==> exists i :: 0 <= i < |"\U{0003}\U{0001}aaaaaaaaaaa\U{0005}\U{0007}aaa.a\t"| && "\U{0003}\U{0001}aaaaaaaaaaa\U{0005}\U{0007}aaa.a\t"[i] == '.' && |"\U{0003}\U{0001}aaaaaaaaaaa\U{0005}\U{0007}aaa.a\t"| - i - 1 == 2;
expect !r0 ==> !exists i :: 0 <= i < |"\U{0003}\U{0001}aaaaaaaaaaa\U{0005}\U{0007}aaa.a\t"| && "\U{0003}\U{0001}aaaaaaaaaaa\U{0005}\U{0007}aaa.a\t"[i] == '.' && |"\U{0003}\U{0001}aaaaaaaaaaa\U{0005}\U{0007}aaa.a\t"| - i - 1 == 2;
}

// REPEAT 3 - TIME: 12.023929 s

method {:test} Test18() {
var r0 := IsDecimalWithTwoPrecision("\U{0002}a\0");
expect r0 ==> exists i :: 0 <= i < |"\U{0002}a\0"| && "\U{0002}a\0"[i] == '.' && |"\U{0002}a\0"| - i - 1 == 2;
expect !r0 ==> !exists i :: 0 <= i < |"\U{0002}a\0"| && "\U{0002}a\0"[i] == '.' && |"\U{0002}a\0"| - i - 1 == 2;
}
method {:test} Test19() {
var r0 := IsDecimalWithTwoPrecision("\U{0003}aaaaa\U{0001}aaaaaa.\U{0005}\U{0007}");
expect r0 ==> exists i :: 0 <= i < |"\U{0003}aaaaa\U{0001}aaaaaa.\U{0005}\U{0007}"| && "\U{0003}aaaaa\U{0001}aaaaaa.\U{0005}\U{0007}"[i] == '.' && |"\U{0003}aaaaa\U{0001}aaaaaa.\U{0005}\U{0007}"| - i - 1 == 2;
expect !r0 ==> !exists i :: 0 <= i < |"\U{0003}aaaaa\U{0001}aaaaaa.\U{0005}\U{0007}"| && "\U{0003}aaaaa\U{0001}aaaaaa.\U{0005}\U{0007}"[i] == '.' && |"\U{0003}aaaaa\U{0001}aaaaaa.\U{0005}\U{0007}"| - i - 1 == 2;
}

// REPEAT 4 - TIME: 13.2367094 s

method {:test} Test20() {
var r0 := IsDecimalWithTwoPrecision("\0aaaaaaaaaaaa\U{0002}a\U{0006}\U{0004}");
expect r0 ==> exists i :: 0 <= i < |"\0aaaaaaaaaaaa\U{0002}a\U{0006}\U{0004}"| && "\0aaaaaaaaaaaa\U{0002}a\U{0006}\U{0004}"[i] == '.' && |"\0aaaaaaaaaaaa\U{0002}a\U{0006}\U{0004}"| - i - 1 == 2;
expect !r0 ==> !exists i :: 0 <= i < |"\0aaaaaaaaaaaa\U{0002}a\U{0006}\U{0004}"| && "\0aaaaaaaaaaaa\U{0002}a\U{0006}\U{0004}"[i] == '.' && |"\0aaaaaaaaaaaa\U{0002}a\U{0006}\U{0004}"| - i - 1 == 2;
}
method {:test} Test21() {
var r0 := IsDecimalWithTwoPrecision("\U{0004}aaaaa\0aaaaaa.\U{0002}a");
expect r0 ==> exists i :: 0 <= i < |"\U{0004}aaaaa\0aaaaaa.\U{0002}a"| && "\U{0004}aaaaa\0aaaaaa.\U{0002}a"[i] == '.' && |"\U{0004}aaaaa\0aaaaaa.\U{0002}a"| - i - 1 == 2;
expect !r0 ==> !exists i :: 0 <= i < |"\U{0004}aaaaa\0aaaaaa.\U{0002}a"| && "\U{0004}aaaaa\0aaaaaa.\U{0002}a"[i] == '.' && |"\U{0004}aaaaa\0aaaaaa.\U{0002}a"| - i - 1 == 2;
}

// REPEAT 5 - TIME: 14.259175 s
