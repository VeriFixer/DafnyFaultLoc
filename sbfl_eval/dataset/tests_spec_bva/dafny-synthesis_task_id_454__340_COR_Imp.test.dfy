// dafny-synthesis_task_id_454.dfy

method {:testEntry} ContainsZ(s: string) returns (result: bool)
  ensures result <==> exists i :: 0 <= i < |s| && (s[i] == 'z' || s[i] == 'Z')
{
  result := false;
  for i := 0 to |s|
    invariant 0 <= i <= |s|
    invariant result <==> exists k :: 0 <= k < i && (s[k] == 'z' || s[k] == 'Z')
  {
    if s[i] == 'z' ==> s[i] == 'Z' {
      result := true;
      break;
    }
  }
}


method {:testEntry} ContainsZ(s: string) returns (result: bool)
    ensures result <==> (exists i :: 0 <= i < |s| && (s[i] == 'z' || s[i] == 'Z'))
{
    result := false;
    for i := 0 to |s|
        invariant 0 <= i <= |s|
        invariant result <==> (exists k :: 0 <= k < i && (s[k] == 'z' || s[k] == 'Z'))
    {
        if s[i] == 'z' || s[i] == 'Z' {
            result := true;
            break;
        }
    }
}

method {:test} Test0() {
var r0 := ContainsZ("aaaaaaaaz");
expect r0 <==> exists i :: 0 <= i < |"aaaaaaaaz"| && ("aaaaaaaaz"[i] == 'z' || "aaaaaaaaz"[i] == 'Z');
}
method {:test} Test1() {
var r0 := ContainsZ("z");
expect r0 <==> exists i :: 0 <= i < |"z"| && ("z"[i] == 'z' || "z"[i] == 'Z');
}
method {:test} Test2() {
var r0 := ContainsZ("za");
expect r0 <==> exists i :: 0 <= i < |"za"| && ("za"[i] == 'z' || "za"[i] == 'Z');
}
method {:test} Test7() {
var r0 := ContainsZ("aaaaaaaaZ");
expect r0 <==> exists i :: 0 <= i < |"aaaaaaaaZ"| && ("aaaaaaaaZ"[i] == 'z' || "aaaaaaaaZ"[i] == 'Z');
}
method {:test} Test8() {
var r0 := ContainsZ("Z");
expect r0 <==> exists i :: 0 <= i < |"Z"| && ("Z"[i] == 'z' || "Z"[i] == 'Z');
}
method {:test} Test9() {
var r0 := ContainsZ("Za");
expect r0 <==> exists i :: 0 <= i < |"Za"| && ("Za"[i] == 'z' || "Za"[i] == 'Z');
}
method {:test} Test14() {
var r0 := ContainsZ("");
expect r0 <==> exists i :: 0 <= i < |""| && (""[i] == 'z' || ""[i] == 'Z');
}
method {:test} Test16() {
var r0 := ContainsZ("a");
expect r0 <==> exists i :: 0 <= i < |"a"| && ("a"[i] == 'z' || "a"[i] == 'Z');
}
method {:test} Test17() {
var r0 := ContainsZ("aa");
expect r0 <==> exists i :: 0 <= i < |"aa"| && ("aa"[i] == 'z' || "aa"[i] == 'Z');
}

// REPEAT 1 - TIME: 12.1779241 s

method {:test} Test22() {
var r0 := ContainsZ("\0aaaaaaaz\U{0003}");
expect r0 <==> exists i :: 0 <= i < |"\0aaaaaaaz\U{0003}"| && ("\0aaaaaaaz\U{0003}"[i] == 'z' || "\0aaaaaaaz\U{0003}"[i] == 'Z');
}
method {:test} Test23() {
var r0 := ContainsZ("\0aaaaaaaZ\U{0004}\U{0002}");
expect r0 <==> exists i :: 0 <= i < |"\0aaaaaaaZ\U{0004}\U{0002}"| && ("\0aaaaaaaZ\U{0004}\U{0002}"[i] == 'z' || "\0aaaaaaaZ\U{0004}\U{0002}"[i] == 'Z');
}
method {:test} Test24() {
var r0 := ContainsZ("\U{0006}\0\U{0002}aaaa\U{0004}a\U{0008}");
expect r0 <==> exists i :: 0 <= i < |"\U{0006}\0\U{0002}aaaa\U{0004}a\U{0008}"| && ("\U{0006}\0\U{0002}aaaa\U{0004}a\U{0008}"[i] == 'z' || "\U{0006}\0\U{0002}aaaa\U{0004}a\U{0008}"[i] == 'Z');
}

// REPEAT 2 - TIME: 13.4446936 s

method {:test} Test25() {
var r0 := ContainsZ("\U{0002}\0z");
expect r0 <==> exists i :: 0 <= i < |"\U{0002}\0z"| && ("\U{0002}\0z"[i] == 'z' || "\U{0002}\0z"[i] == 'Z');
}
method {:test} Test26() {
var r0 := ContainsZ("\U{0003}Zaa\U{0001}aaa\U{0005}\U{0007}a");
expect r0 <==> exists i :: 0 <= i < |"\U{0003}Zaa\U{0001}aaa\U{0005}\U{0007}a"| && ("\U{0003}Zaa\U{0001}aaa\U{0005}\U{0007}a"[i] == 'z' || "\U{0003}Zaa\U{0001}aaa\U{0005}\U{0007}a"[i] == 'Z');
}
method {:test} Test27() {
var r0 := ContainsZ("\U{0002}\0");
expect r0 <==> exists i :: 0 <= i < |"\U{0002}\0"| && ("\U{0002}\0"[i] == 'z' || "\U{0002}\0"[i] == 'Z');
}

// REPEAT 3 - TIME: 14.9684936 s

method {:test} Test28() {
var r0 := ContainsZ("\U{0006}az\0a\U{0004}aaa\U{0008}\n\U{0002}");
expect r0 <==> exists i :: 0 <= i < |"\U{0006}az\0a\U{0004}aaa\U{0008}\n\U{0002}"| && ("\U{0006}az\0a\U{0004}aaa\U{0008}\n\U{0002}"[i] == 'z' || "\U{0006}az\0a\U{0004}aaa\U{0008}\n\U{0002}"[i] == 'Z');
}
method {:test} Test29() {
var r0 := ContainsZ("\U{0002}aZ\0");
expect r0 <==> exists i :: 0 <= i < |"\U{0002}aZ\0"| && ("\U{0002}aZ\0"[i] == 'z' || "\U{0002}aZ\0"[i] == 'Z');
}
method {:test} Test30() {
var r0 := ContainsZ("\U{0002}a\0");
expect r0 <==> exists i :: 0 <= i < |"\U{0002}a\0"| && ("\U{0002}a\0"[i] == 'z' || "\U{0002}a\0"[i] == 'Z');
}

// REPEAT 4 - TIME: 16.4220947 s

method {:test} Test31() {
var r0 := ContainsZ("\U{0001}az");
expect r0 <==> exists i :: 0 <= i < |"\U{0001}az"| && ("\U{0001}az"[i] == 'z' || "\U{0001}az"[i] == 'Z');
}
method {:test} Test32() {
var r0 := ContainsZ("\U{0005}a\U{0001}aaa\U{0003}\U{0007}Z\t");
expect r0 <==> exists i :: 0 <= i < |"\U{0005}a\U{0001}aaa\U{0003}\U{0007}Z\t"| && ("\U{0005}a\U{0001}aaa\U{0003}\U{0007}Z\t"[i] == 'z' || "\U{0005}a\U{0001}aaa\U{0003}\U{0007}Z\t"[i] == 'Z');
}
method {:test} Test33() {
var r0 := ContainsZ("\U{0008}\U{0002}\0\U{0004}\U{0006}");
expect r0 <==> exists i :: 0 <= i < |"\U{0008}\U{0002}\0\U{0004}\U{0006}"| && ("\U{0008}\U{0002}\0\U{0004}\U{0006}"[i] == 'z' || "\U{0008}\U{0002}\0\U{0004}\U{0006}"[i] == 'Z');
}

// REPEAT 5 - TIME: 17.9974089 s
