method {:testEntry} ReplaceBlanksWithChar(s: string, ch: char) returns (v: string)
  ensures |v| == |s|
  ensures forall i :: 0 <= i < |s| ==> (s[i] == ' ' ==> v[i] == ch) && (s[i] != ' ' ==> v[i] == s[i])
{
  var s': string := [];
  for i := 0 to |s|
    invariant 0 <= i <= |s|
    invariant |s'| == i
    invariant forall k :: 0 <= k < i ==> (s[k] == ' ' ==> s'[k] == ch) && (s[k] != ' ' ==> s'[k] == s[k])
  {
    if s[i] == ' ' {
    } else {
      s' := s' + [s[i]];
    }
  }
  return s';
}


method {:test} Test0() {
var r0 := ReplaceBlanksWithChar("a", '\0');
expect |r0| == |"a"|;
expect forall i :: 0 <= i < |"a"| ==> ("a"[i] == ' ' ==> r0[i] == '\0') && ("a"[i] != ' ' ==> r0[i] == "a"[i]);
}

method {:test} Test1() {
var r0 := ReplaceBlanksWithChar("a ", '\0');
expect |r0| == |"a "|;
expect forall i :: 0 <= i < |"a "| ==> ("a "[i] == ' ' ==> r0[i] == '\0') && ("a "[i] != ' ' ==> r0[i] == "a "[i]);
}

method {:test} Test2() {
var r0 := ReplaceBlanksWithChar("a\0aaaaaaaaaa ", '\0');
expect |r0| == |"a\0aaaaaaaaaa "|;
expect forall i :: 0 <= i < |"a\0aaaaaaaaaa "| ==> ("a\0aaaaaaaaaa "[i] == ' ' ==> r0[i] == '\0') && ("a\0aaaaaaaaaa "[i] != ' ' ==> r0[i] == "a\0aaaaaaaaaa "[i]);
}

method {:test} Test3() {
var r0 := ReplaceBlanksWithChar("a\0a", '\0');
expect |r0| == |"a\0a"|;
expect forall i :: 0 <= i < |"a\0a"| ==> ("a\0a"[i] == ' ' ==> r0[i] == '\0') && ("a\0a"[i] != ' ' ==> r0[i] == "a\0a"[i]);
}

method {:test} Test4() {
var r0 := ReplaceBlanksWithChar("\0\0", '\0');
expect |r0| == |"\0\0"|;
expect forall i :: 0 <= i < |"\0\0"| ==> ("\0\0"[i] == ' ' ==> r0[i] == '\0') && ("\0\0"[i] != ' ' ==> r0[i] == "\0\0"[i]);
}

method {:test} Test5() {
var r0 := ReplaceBlanksWithChar(" aa", '\0');
expect |r0| == |" aa"|;
expect forall i :: 0 <= i < |" aa"| ==> (" aa"[i] == ' ' ==> r0[i] == '\0') && (" aa"[i] != ' ' ==> r0[i] == " aa"[i]);
}

method {:test} Test6() {
var r0 := ReplaceBlanksWithChar("  aaaaaaaaaaa ", '\0');
expect |r0| == |"  aaaaaaaaaaa "|;
expect forall i :: 0 <= i < |"  aaaaaaaaaaa "| ==> ("  aaaaaaaaaaa "[i] == ' ' ==> r0[i] == '\0') && ("  aaaaaaaaaaa "[i] != ' ' ==> r0[i] == "  aaaaaaaaaaa "[i]);
}

method {:test} Test7() {
var r0 := ReplaceBlanksWithChar("\U{0003}\U{0001}aaaaaaaaaaa\U{0005}a", '\0');
expect |r0| == |"\U{0003}\U{0001}aaaaaaaaaaa\U{0005}a"|;
expect forall i :: 0 <= i < |"\U{0003}\U{0001}aaaaaaaaaaa\U{0005}a"| ==> ("\U{0003}\U{0001}aaaaaaaaaaa\U{0005}a"[i] == ' ' ==> r0[i] == '\0') && ("\U{0003}\U{0001}aaaaaaaaaaa\U{0005}a"[i] != ' ' ==> r0[i] == "\U{0003}\U{0001}aaaaaaaaaaa\U{0005}a"[i]);
}

method {:test} Test8() {
var r0 := ReplaceBlanksWithChar("\0a\0\0", '\0');
expect |r0| == |"\0a\0\0"|;
expect forall i :: 0 <= i < |"\0a\0\0"| ==> ("\0a\0\0"[i] == ' ' ==> r0[i] == '\0') && ("\0a\0\0"[i] != ' ' ==> r0[i] == "\0a\0\0"[i]);
}

method {:test} Test9() {
var r0 := ReplaceBlanksWithChar("\U{0001}aaa\U{0003}a\U{0007}aaaaaa\U{0005}a", '\0');
expect |r0| == |"\U{0001}aaa\U{0003}a\U{0007}aaaaaa\U{0005}a"|;
expect forall i :: 0 <= i < |"\U{0001}aaa\U{0003}a\U{0007}aaaaaa\U{0005}a"| ==> ("\U{0001}aaa\U{0003}a\U{0007}aaaaaa\U{0005}a"[i] == ' ' ==> r0[i] == '\0') && ("\U{0001}aaa\U{0003}a\U{0007}aaaaaa\U{0005}a"[i] != ' ' ==> r0[i] == "\U{0001}aaa\U{0003}a\U{0007}aaaaaa\U{0005}a"[i]);
}

