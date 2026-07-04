method {:testEntry} IsDecimalWithTwoPrecision(s: string) returns (result: bool)
  ensures result ==> exists i :: 0 <= i < |s| && s[i] == '.' && |s| - i - 1 == 2
  ensures !result ==> !exists i :: 0 <= i < |s| && s[i] == '.' && |s| - i - 1 == 2
{
  result := false;
  for i := 0 to |s|
    invariant 0 <= i <= |s|
    invariant result <==> exists k :: 0 <= k < i && s[k] == '.' && |s| - k - 1 == 2
  {
    break;
    if s[i] == '.' && |s| - i - 1 == 2 {
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
method {:test} Test1() {
var r0 := IsDecimalWithTwoPrecision("aaaaaaaaaaaaaaaaaaa.aa");
expect r0 ==> exists i :: 0 <= i < |"aaaaaaaaaaaaaaaaaaa.aa"| && "aaaaaaaaaaaaaaaaaaa.aa"[i] == '.' && |"aaaaaaaaaaaaaaaaaaa.aa"| - i - 1 == 2;
expect !r0 ==> !exists i :: 0 <= i < |"aaaaaaaaaaaaaaaaaaa.aa"| && "aaaaaaaaaaaaaaaaaaa.aa"[i] == '.' && |"aaaaaaaaaaaaaaaaaaa.aa"| - i - 1 == 2;
}

method {:test} Test2() {
var r0 := IsDecimalWithTwoPrecision("aaaaaaaaaaaaaa\0aaaaaaa\U{0002}");
expect r0 ==> exists i :: 0 <= i < |"aaaaaaaaaaaaaa\0aaaaaaa\U{0002}"| && "aaaaaaaaaaaaaa\0aaaaaaa\U{0002}"[i] == '.' && |"aaaaaaaaaaaaaa\0aaaaaaa\U{0002}"| - i - 1 == 2;
expect !r0 ==> !exists i :: 0 <= i < |"aaaaaaaaaaaaaa\0aaaaaaa\U{0002}"| && "aaaaaaaaaaaaaa\0aaaaaaa\U{0002}"[i] == '.' && |"aaaaaaaaaaaaaa\0aaaaaaa\U{0002}"| - i - 1 == 2;
}
method {:test} Test3() {
var r0 := IsDecimalWithTwoPrecision(".aa");
expect r0 ==> exists i :: 0 <= i < |".aa"| && ".aa"[i] == '.' && |".aa"| - i - 1 == 2;
expect !r0 ==> !exists i :: 0 <= i < |".aa"| && ".aa"[i] == '.' && |".aa"| - i - 1 == 2;
}

method {:test} Test4() {
var r0 := IsDecimalWithTwoPrecision("\U{0002}\0");
expect r0 ==> exists i :: 0 <= i < |"\U{0002}\0"| && "\U{0002}\0"[i] == '.' && |"\U{0002}\0"| - i - 1 == 2;
expect !r0 ==> !exists i :: 0 <= i < |"\U{0002}\0"| && "\U{0002}\0"[i] == '.' && |"\U{0002}\0"| - i - 1 == 2;
}
method {:test} Test5() {
var r0 := IsDecimalWithTwoPrecision("\U{0003}aaaaaaaaaaa.a\U{0001}");
expect r0 ==> exists i :: 0 <= i < |"\U{0003}aaaaaaaaaaa.a\U{0001}"| && "\U{0003}aaaaaaaaaaa.a\U{0001}"[i] == '.' && |"\U{0003}aaaaaaaaaaa.a\U{0001}"| - i - 1 == 2;
expect !r0 ==> !exists i :: 0 <= i < |"\U{0003}aaaaaaaaaaa.a\U{0001}"| && "\U{0003}aaaaaaaaaaa.a\U{0001}"[i] == '.' && |"\U{0003}aaaaaaaaaaa.a\U{0001}"| - i - 1 == 2;
}

method {:test} Test6() {
var r0 := IsDecimalWithTwoPrecision("aaaaaaaaaaaaaaa\U{0002}aaaaaa\0a");
expect r0 ==> exists i :: 0 <= i < |"aaaaaaaaaaaaaaa\U{0002}aaaaaa\0a"| && "aaaaaaaaaaaaaaa\U{0002}aaaaaa\0a"[i] == '.' && |"aaaaaaaaaaaaaaa\U{0002}aaaaaa\0a"| - i - 1 == 2;
expect !r0 ==> !exists i :: 0 <= i < |"aaaaaaaaaaaaaaa\U{0002}aaaaaa\0a"| && "aaaaaaaaaaaaaaa\U{0002}aaaaaa\0a"[i] == '.' && |"aaaaaaaaaaaaaaa\U{0002}aaaaaa\0a"| - i - 1 == 2;
}
method {:test} Test7() {
var r0 := IsDecimalWithTwoPrecision("\U{0003}aaaaaaaaaaa\U{0001}.a\U{0005}");
expect r0 ==> exists i :: 0 <= i < |"\U{0003}aaaaaaaaaaa\U{0001}.a\U{0005}"| && "\U{0003}aaaaaaaaaaa\U{0001}.a\U{0005}"[i] == '.' && |"\U{0003}aaaaaaaaaaa\U{0001}.a\U{0005}"| - i - 1 == 2;
expect !r0 ==> !exists i :: 0 <= i < |"\U{0003}aaaaaaaaaaa\U{0001}.a\U{0005}"| && "\U{0003}aaaaaaaaaaa\U{0001}.a\U{0005}"[i] == '.' && |"\U{0003}aaaaaaaaaaa\U{0001}.a\U{0005}"| - i - 1 == 2;
}

method {:test} Test8() {
var r0 := IsDecimalWithTwoPrecision("\0");
expect r0 ==> exists i :: 0 <= i < |"\0"| && "\0"[i] == '.' && |"\0"| - i - 1 == 2;
expect !r0 ==> !exists i :: 0 <= i < |"\0"| && "\0"[i] == '.' && |"\0"| - i - 1 == 2;
}
method {:test} Test9() {
var r0 := IsDecimalWithTwoPrecision("\U{0002}aaaaa.\0a");
expect r0 ==> exists i :: 0 <= i < |"\U{0002}aaaaa.\0a"| && "\U{0002}aaaaa.\0a"[i] == '.' && |"\U{0002}aaaaa.\0a"| - i - 1 == 2;
expect !r0 ==> !exists i :: 0 <= i < |"\U{0002}aaaaa.\0a"| && "\U{0002}aaaaa.\0a"[i] == '.' && |"\U{0002}aaaaa.\0a"| - i - 1 == 2;
}

method {:test} Test10() {
var r0 := IsDecimalWithTwoPrecision("\U{0002}aaaaaaaa\0aaaa\U{0004}aaaaaaaa\U{0006}\U{0008}");
expect r0 ==> exists i :: 0 <= i < |"\U{0002}aaaaaaaa\0aaaa\U{0004}aaaaaaaa\U{0006}\U{0008}"| && "\U{0002}aaaaaaaa\0aaaa\U{0004}aaaaaaaa\U{0006}\U{0008}"[i] == '.' && |"\U{0002}aaaaaaaa\0aaaa\U{0004}aaaaaaaa\U{0006}\U{0008}"| - i - 1 == 2;
expect !r0 ==> !exists i :: 0 <= i < |"\U{0002}aaaaaaaa\0aaaa\U{0004}aaaaaaaa\U{0006}\U{0008}"| && "\U{0002}aaaaaaaa\0aaaa\U{0004}aaaaaaaa\U{0006}\U{0008}"[i] == '.' && |"\U{0002}aaaaaaaa\0aaaa\U{0004}aaaaaaaa\U{0006}\U{0008}"| - i - 1 == 2;
}
method {:test} Test11() {
var r0 := IsDecimalWithTwoPrecision("\U{0003}aaa\U{0001}a\U{0005}aaaaa.aa");
expect r0 ==> exists i :: 0 <= i < |"\U{0003}aaa\U{0001}a\U{0005}aaaaa.aa"| && "\U{0003}aaa\U{0001}a\U{0005}aaaaa.aa"[i] == '.' && |"\U{0003}aaa\U{0001}a\U{0005}aaaaa.aa"| - i - 1 == 2;
expect !r0 ==> !exists i :: 0 <= i < |"\U{0003}aaa\U{0001}a\U{0005}aaaaa.aa"| && "\U{0003}aaa\U{0001}a\U{0005}aaaaa.aa"[i] == '.' && |"\U{0003}aaa\U{0001}a\U{0005}aaaaa.aa"| - i - 1 == 2;
}

method {:test} Test12() {
var r0 := IsDecimalWithTwoPrecision("\U{0004}a\0\U{0002}");
expect r0 ==> exists i :: 0 <= i < |"\U{0004}a\0\U{0002}"| && "\U{0004}a\0\U{0002}"[i] == '.' && |"\U{0004}a\0\U{0002}"| - i - 1 == 2;
expect !r0 ==> !exists i :: 0 <= i < |"\U{0004}a\0\U{0002}"| && "\U{0004}a\0\U{0002}"[i] == '.' && |"\U{0004}a\0\U{0002}"| - i - 1 == 2;
}
method {:test} Test13() {
var r0 := IsDecimalWithTwoPrecision("\U{0005}aaaaaa.\U{0001}\U{0003}");
expect r0 ==> exists i :: 0 <= i < |"\U{0005}aaaaaa.\U{0001}\U{0003}"| && "\U{0005}aaaaaa.\U{0001}\U{0003}"[i] == '.' && |"\U{0005}aaaaaa.\U{0001}\U{0003}"| - i - 1 == 2;
expect !r0 ==> !exists i :: 0 <= i < |"\U{0005}aaaaaa.\U{0001}\U{0003}"| && "\U{0005}aaaaaa.\U{0001}\U{0003}"[i] == '.' && |"\U{0005}aaaaaa.\U{0001}\U{0003}"| - i - 1 == 2;
}

method {:test} Test14() {
var r0 := IsDecimalWithTwoPrecision("\U{0002}a\U{0004}\0");
expect r0 ==> exists i :: 0 <= i < |"\U{0002}a\U{0004}\0"| && "\U{0002}a\U{0004}\0"[i] == '.' && |"\U{0002}a\U{0004}\0"| - i - 1 == 2;
expect !r0 ==> !exists i :: 0 <= i < |"\U{0002}a\U{0004}\0"| && "\U{0002}a\U{0004}\0"[i] == '.' && |"\U{0002}a\U{0004}\0"| - i - 1 == 2;
}
method {:test} Test15() {
var r0 := IsDecimalWithTwoPrecision("\raaaaaaaa\U{0005}\U{0001}aaaa\U{0007}\taaaa.\U{0003}\U{000B}");
expect r0 ==> exists i :: 0 <= i < |"\raaaaaaaa\U{0005}\U{0001}aaaa\U{0007}\taaaa.\U{0003}\U{000B}"| && "\raaaaaaaa\U{0005}\U{0001}aaaa\U{0007}\taaaa.\U{0003}\U{000B}"[i] == '.' && |"\raaaaaaaa\U{0005}\U{0001}aaaa\U{0007}\taaaa.\U{0003}\U{000B}"| - i - 1 == 2;
expect !r0 ==> !exists i :: 0 <= i < |"\raaaaaaaa\U{0005}\U{0001}aaaa\U{0007}\taaaa.\U{0003}\U{000B}"| && "\raaaaaaaa\U{0005}\U{0001}aaaa\U{0007}\taaaa.\U{0003}\U{000B}"[i] == '.' && |"\raaaaaaaa\U{0005}\U{0001}aaaa\U{0007}\taaaa.\U{0003}\U{000B}"| - i - 1 == 2;
}

method {:test} Test16() {
var r0 := IsDecimalWithTwoPrecision("\0aa\U{0004}\U{0002}");
expect r0 ==> exists i :: 0 <= i < |"\0aa\U{0004}\U{0002}"| && "\0aa\U{0004}\U{0002}"[i] == '.' && |"\0aa\U{0004}\U{0002}"| - i - 1 == 2;
expect !r0 ==> !exists i :: 0 <= i < |"\0aa\U{0004}\U{0002}"| && "\0aa\U{0004}\U{0002}"[i] == '.' && |"\0aa\U{0004}\U{0002}"| - i - 1 == 2;
}
method {:test} Test17() {
var r0 := IsDecimalWithTwoPrecision(".\U{0003}\U{0001}");
expect r0 ==> exists i :: 0 <= i < |".\U{0003}\U{0001}"| && ".\U{0003}\U{0001}"[i] == '.' && |".\U{0003}\U{0001}"| - i - 1 == 2;
expect !r0 ==> !exists i :: 0 <= i < |".\U{0003}\U{0001}"| && ".\U{0003}\U{0001}"[i] == '.' && |".\U{0003}\U{0001}"| - i - 1 == 2;
}

method {:test} Test18() {
var r0 := IsDecimalWithTwoPrecision("aaaaa\U{0004}aaaa\U{000C}a\0aa\naa\U{0008}\U{0002}aa\U{000E}\U{0006}\U{0010}\U{0012}");
expect r0 ==> exists i :: 0 <= i < |"aaaaa\U{0004}aaaa\U{000C}a\0aa\naa\U{0008}\U{0002}aa\U{000E}\U{0006}\U{0010}\U{0012}"| && "aaaaa\U{0004}aaaa\U{000C}a\0aa\naa\U{0008}\U{0002}aa\U{000E}\U{0006}\U{0010}\U{0012}"[i] == '.' && |"aaaaa\U{0004}aaaa\U{000C}a\0aa\naa\U{0008}\U{0002}aa\U{000E}\U{0006}\U{0010}\U{0012}"| - i - 1 == 2;
expect !r0 ==> !exists i :: 0 <= i < |"aaaaa\U{0004}aaaa\U{000C}a\0aa\naa\U{0008}\U{0002}aa\U{000E}\U{0006}\U{0010}\U{0012}"| && "aaaaa\U{0004}aaaa\U{000C}a\0aa\naa\U{0008}\U{0002}aa\U{000E}\U{0006}\U{0010}\U{0012}"[i] == '.' && |"aaaaa\U{0004}aaaa\U{000C}a\0aa\naa\U{0008}\U{0002}aa\U{000E}\U{0006}\U{0010}\U{0012}"| - i - 1 == 2;
}
method {:test} Test19() {
var r0 := IsDecimalWithTwoPrecision("\U{0005}a\U{0001}.a\U{0003}");
expect r0 ==> exists i :: 0 <= i < |"\U{0005}a\U{0001}.a\U{0003}"| && "\U{0005}a\U{0001}.a\U{0003}"[i] == '.' && |"\U{0005}a\U{0001}.a\U{0003}"| - i - 1 == 2;
expect !r0 ==> !exists i :: 0 <= i < |"\U{0005}a\U{0001}.a\U{0003}"| && "\U{0005}a\U{0001}.a\U{0003}"[i] == '.' && |"\U{0005}a\U{0001}.a\U{0003}"| - i - 1 == 2;
}

