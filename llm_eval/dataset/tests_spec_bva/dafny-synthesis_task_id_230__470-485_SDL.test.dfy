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
var r0 := ReplaceBlanksWithChar("", '\0');
expect |r0| == |""|;
expect forall i :: 0 <= i < |""| ==> (""[i] == ' ' ==> r0[i] == '\0') && (""[i] != ' ' ==> r0[i] == ""[i]);
}
method {:test} Test3() {
var r0 := ReplaceBlanksWithChar("aa", '\0');
expect |r0| == |"aa"|;
expect forall i :: 0 <= i < |"aa"| ==> ("aa"[i] == ' ' ==> r0[i] == '\0') && ("aa"[i] != ' ' ==> r0[i] == "aa"[i]);
}

method {:test} Test10() {
var r0 := ReplaceBlanksWithChar("aaa", '\0');
expect |r0| == |"aaa"|;
expect forall i :: 0 <= i < |"aaa"| ==> ("aaa"[i] == ' ' ==> r0[i] == '\0') && ("aaa"[i] != ' ' ==> r0[i] == "aaa"[i]);
}

method {:test} Test11() {
var r0 := ReplaceBlanksWithChar("\0 aaaaaaaaaaaa ", '\0');
expect |r0| == |"\0 aaaaaaaaaaaa "|;
expect forall i :: 0 <= i < |"\0 aaaaaaaaaaaa "| ==> ("\0 aaaaaaaaaaaa "[i] == ' ' ==> r0[i] == '\0') && ("\0 aaaaaaaaaaaa "[i] != ' ' ==> r0[i] == "\0 aaaaaaaaaaaa "[i]);
}

method {:test} Test12() {
var r0 := ReplaceBlanksWithChar("  a", '\0');
expect |r0| == |"  a"|;
expect forall i :: 0 <= i < |"  a"| ==> ("  a"[i] == ' ' ==> r0[i] == '\0') && ("  a"[i] != ' ' ==> r0[i] == "  a"[i]);
}

method {:test} Test13() {
var r0 := ReplaceBlanksWithChar(" aaa", '\0');
expect |r0| == |" aaa"|;
expect forall i :: 0 <= i < |" aaa"| ==> (" aaa"[i] == ' ' ==> r0[i] == '\0') && (" aaa"[i] != ' ' ==> r0[i] == " aaa"[i]);
}

method {:test} Test14() {
var r0 := ReplaceBlanksWithChar("a\U{0001}\U{0003}\U{0005}a", '\0');
expect |r0| == |"a\U{0001}\U{0003}\U{0005}a"|;
expect forall i :: 0 <= i < |"a\U{0001}\U{0003}\U{0005}a"| ==> ("a\U{0001}\U{0003}\U{0005}a"[i] == ' ' ==> r0[i] == '\0') && ("a\U{0001}\U{0003}\U{0005}a"[i] != ' ' ==> r0[i] == "a\U{0001}\U{0003}\U{0005}a"[i]);
}

method {:test} Test15() {
var r0 := ReplaceBlanksWithChar(" aaaaa", '\0');
expect |r0| == |" aaaaa"|;
expect forall i :: 0 <= i < |" aaaaa"| ==> (" aaaaa"[i] == ' ' ==> r0[i] == '\0') && (" aaaaa"[i] != ' ' ==> r0[i] == " aaaaa"[i]);
}

method {:test} Test16() {
var r0 := ReplaceBlanksWithChar("  aa", '\0');
expect |r0| == |"  aa"|;
expect forall i :: 0 <= i < |"  aa"| ==> ("  aa"[i] == ' ' ==> r0[i] == '\0') && ("  aa"[i] != ' ' ==> r0[i] == "  aa"[i]);
}

method {:test} Test17() {
var r0 := ReplaceBlanksWithChar("\U{0003}aaa\U{0001}aaaaaaaaaaa", '\0');
expect |r0| == |"\U{0003}aaa\U{0001}aaaaaaaaaaa"|;
expect forall i :: 0 <= i < |"\U{0003}aaa\U{0001}aaaaaaaaaaa"| ==> ("\U{0003}aaa\U{0001}aaaaaaaaaaa"[i] == ' ' ==> r0[i] == '\0') && ("\U{0003}aaa\U{0001}aaaaaaaaaaa"[i] != ' ' ==> r0[i] == "\U{0003}aaa\U{0001}aaaaaaaaaaa"[i]);
}

method {:test} Test18() {
var r0 := ReplaceBlanksWithChar("\U{0001}   a", '\0');
expect |r0| == |"\U{0001}   a"|;
expect forall i :: 0 <= i < |"\U{0001}   a"| ==> ("\U{0001}   a"[i] == ' ' ==> r0[i] == '\0') && ("\U{0001}   a"[i] != ' ' ==> r0[i] == "\U{0001}   a"[i]);
}

