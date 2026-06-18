// dafny-synthesis_task_id_454.dfy

method {:testEntry} ContainsZ(s: string) returns (result: bool)
  ensures result <==> exists i :: 0 <= i < |s| && (s[i] == 'z' || s[i] == 'Z')
{
  result := false;
  for i := 0 to |s|
    invariant 0 <= i <= |s|
    invariant result <==> exists k :: 0 <= k < i && (s[k] == 'z' || s[k] == 'Z')
  {
    if true {
      result := true;
      break;
    }
  }
}

method {:test} Test0() {
var r0 := ContainsZ("a");
expect r0 <==> exists i :: 0 <= i < |"a"| && ("a"[i] == 'z' || "a"[i] == 'Z');
}
method {:test} Test1() {
var r0 := ContainsZ("aaaaaaaaZ");
expect r0 <==> exists i :: 0 <= i < |"aaaaaaaaZ"| && ("aaaaaaaaZ"[i] == 'z' || "aaaaaaaaZ"[i] == 'Z');
}

// REPEAT 1 - TIME: 26.4506927 s

method {:test} Test3() {
var r0 := ContainsZ("a\0aaaaaaa\U{0002}");
expect r0 <==> exists i :: 0 <= i < |"a\0aaaaaaa\U{0002}"| && ("a\0aaaaaaa\U{0002}"[i] == 'z' || "a\0aaaaaaa\U{0002}"[i] == 'Z');
}
method {:test} Test4() {
var r0 := ContainsZ("\U{0003}aaaaaaaaaaaaaaaaaaa\U{0001}Z");
expect r0 <==> exists i :: 0 <= i < |"\U{0003}aaaaaaaaaaaaaaaaaaa\U{0001}Z"| && ("\U{0003}aaaaaaaaaaaaaaaaaaa\U{0001}Z"[i] == 'z' || "\U{0003}aaaaaaaaaaaaaaaaaaa\U{0001}Z"[i] == 'Z');
}
method {:test} Test5() {
var r0 := ContainsZ("Z\U{0001}");
expect r0 <==> exists i :: 0 <= i < |"Z\U{0001}"| && ("Z\U{0001}"[i] == 'z' || "Z\U{0001}"[i] == 'Z');
}

// REPEAT 2 - TIME: 68.1405933 s

method {:test} Test6() {
var r0 := ContainsZ("\U{0002}a\0");
expect r0 <==> exists i :: 0 <= i < |"\U{0002}a\0"| && ("\U{0002}a\0"[i] == 'z' || "\U{0002}a\0"[i] == 'Z');
}
method {:test} Test7() {
var r0 := ContainsZ("aaZaaaaaaa\0aaaaaaaaa\U{0002}a\U{0004}");
expect r0 <==> exists i :: 0 <= i < |"aaZaaaaaaa\0aaaaaaaaa\U{0002}a\U{0004}"| && ("aaZaaaaaaa\0aaaaaaaaa\U{0002}a\U{0004}"[i] == 'z' || "aaZaaaaaaa\0aaaaaaaaa\U{0002}a\U{0004}"[i] == 'Z');
}
method {:test} Test8() {
var r0 := ContainsZ("Za\0aaaaaaaaaaaaaaa\U{0002}a\U{0004}a\U{0006}");
expect r0 <==> exists i :: 0 <= i < |"Za\0aaaaaaaaaaaaaaa\U{0002}a\U{0004}a\U{0006}"| && ("Za\0aaaaaaaaaaaaaaa\U{0002}a\U{0004}a\U{0006}"[i] == 'z' || "Za\0aaaaaaaaaaaaaaa\U{0002}a\U{0004}a\U{0006}"[i] == 'Z');
}

// REPEAT 3 - TIME: 126.4468097 s

method {:test} Test9() {
var r0 := ContainsZ("\U{0004}a\U{0002}\0");
expect r0 <==> exists i :: 0 <= i < |"\U{0004}a\U{0002}\0"| && ("\U{0004}a\U{0002}\0"[i] == 'z' || "\U{0004}a\U{0002}\0"[i] == 'Z');
}
method {:test} Test10() {
var r0 := ContainsZ("\U{0005}\U{0001}Z\U{0003}");
expect r0 <==> exists i :: 0 <= i < |"\U{0005}\U{0001}Z\U{0003}"| && ("\U{0005}\U{0001}Z\U{0003}"[i] == 'z' || "\U{0005}\U{0001}Z\U{0003}"[i] == 'Z');
}
method {:test} Test11() {
var r0 := ContainsZ("aaaaaaa\U{0001}aa\U{0003}a\U{0007}aZ\taa\U{0005}aaa\U{000B}a");
expect r0 <==> exists i :: 0 <= i < |"aaaaaaa\U{0001}aa\U{0003}a\U{0007}aZ\taa\U{0005}aaa\U{000B}a"| && ("aaaaaaa\U{0001}aa\U{0003}a\U{0007}aZ\taa\U{0005}aaa\U{000B}a"[i] == 'z' || "aaaaaaa\U{0001}aa\U{0003}a\U{0007}aZ\taa\U{0005}aaa\U{000B}a"[i] == 'Z');
}

// REPEAT 4 - TIME: 219.4035754 s

method {:test} Test12() {
var r0 := ContainsZ("\U{0004}\U{0006}a\0\U{0002}");
expect r0 <==> exists i :: 0 <= i < |"\U{0004}\U{0006}a\0\U{0002}"| && ("\U{0004}\U{0006}a\0\U{0002}"[i] == 'z' || "\U{0004}\U{0006}a\0\U{0002}"[i] == 'Z');
}
method {:test} Test13() {
var r0 := ContainsZ("aaaaaaaaaaaaaaaaaaaaaaaaZ");
expect r0 <==> exists i :: 0 <= i < |"aaaaaaaaaaaaaaaaaaaaaaaaZ"| && ("aaaaaaaaaaaaaaaaaaaaaaaaZ"[i] == 'z' || "aaaaaaaaaaaaaaaaaaaaaaaaZ"[i] == 'Z');
}

// REPEAT 5 - TIME: 302.2112877 s

method {:test} Test15() {
var r0 := ContainsZ("\n\U{0008}\0a\U{0006}\U{0002}\U{0004}");
expect r0 <==> exists i :: 0 <= i < |"\n\U{0008}\0a\U{0006}\U{0002}\U{0004}"| && ("\n\U{0008}\0a\U{0006}\U{0002}\U{0004}"[i] == 'z' || "\n\U{0008}\0a\U{0006}\U{0002}\U{0004}"[i] == 'Z');
}
method {:test} Test16() {
var r0 := ContainsZ("aaaaaaaaaaaaaaaaaaaaaaaaaZ");
expect r0 <==> exists i :: 0 <= i < |"aaaaaaaaaaaaaaaaaaaaaaaaaZ"| && ("aaaaaaaaaaaaaaaaaaaaaaaaaZ"[i] == 'z' || "aaaaaaaaaaaaaaaaaaaaaaaaaZ"[i] == 'Z');
}

// REPEAT 6 - TIME: 377.22965 s

method {:test} Test18() {
var r0 := ContainsZ("\U{0008}\0aaa\U{0002}\U{0004}\U{0006}");
expect r0 <==> exists i :: 0 <= i < |"\U{0008}\0aaa\U{0002}\U{0004}\U{0006}"| && ("\U{0008}\0aaa\U{0002}\U{0004}\U{0006}"[i] == 'z' || "\U{0008}\0aaa\U{0002}\U{0004}\U{0006}"[i] == 'Z');
}
method {:test} Test19() {
var r0 := ContainsZ("aaaaaaaaaaaZaaaaaaaaaaaaaaa");
expect r0 <==> exists i :: 0 <= i < |"aaaaaaaaaaaZaaaaaaaaaaaaaaa"| && ("aaaaaaaaaaaZaaaaaaaaaaaaaaa"[i] == 'z' || "aaaaaaaaaaaZaaaaaaaaaaaaaaa"[i] == 'Z');
}

// REPEAT 7 - TIME: 469.5552503 s

method {:test} Test21() {
var r0 := ContainsZ("\U{000C}aaa\U{0002}\U{0004}aaaaaaaaaa\U{0006}\0aaaa\U{0008}\n");
expect r0 <==> exists i :: 0 <= i < |"\U{000C}aaa\U{0002}\U{0004}aaaaaaaaaa\U{0006}\0aaaa\U{0008}\n"| && ("\U{000C}aaa\U{0002}\U{0004}aaaaaaaaaa\U{0006}\0aaaa\U{0008}\n"[i] == 'z' || "\U{000C}aaa\U{0002}\U{0004}aaaaaaaaaa\U{0006}\0aaaa\U{0008}\n"[i] == 'Z');
}
method {:test} Test22() {
var r0 := ContainsZ("aaaaaaaaaaaaaaaaaaaZaaaaaaaa");
expect r0 <==> exists i :: 0 <= i < |"aaaaaaaaaaaaaaaaaaaZaaaaaaaa"| && ("aaaaaaaaaaaaaaaaaaaZaaaaaaaa"[i] == 'z' || "aaaaaaaaaaaaaaaaaaaZaaaaaaaa"[i] == 'Z');
}

// REPEAT 8 - TIME: 557.8271066 s
