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
    if s[i] > ' ' {
      s' := s' + [ch];
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

method {:test} Test2() {
var r0 := ReplaceBlanksWithChar("\U{0001}", '\0');
expect |r0| == |"\U{0001}"|;
expect forall i :: 0 <= i < |"\U{0001}"| ==> ("\U{0001}"[i] == ' ' ==> r0[i] == '\0') && ("\U{0001}"[i] != ' ' ==> r0[i] == "\U{0001}"[i]);
}

method {:test} Test3() {
var r0 := ReplaceBlanksWithChar("aa", '\0');
expect |r0| == |"aa"|;
expect forall i :: 0 <= i < |"aa"| ==> ("aa"[i] == ' ' ==> r0[i] == '\0') && ("aa"[i] != ' ' ==> r0[i] == "aa"[i]);
}

method {:test} Test4() {
var r0 := ReplaceBlanksWithChar(" ", '\0');
expect |r0| == |" "|;
expect forall i :: 0 <= i < |" "| ==> (" "[i] == ' ' ==> r0[i] == '\0') && (" "[i] != ' ' ==> r0[i] == " "[i]);
}

method {:test} Test5() {
var r0 := ReplaceBlanksWithChar("aaa", '\0');
expect |r0| == |"aaa"|;
expect forall i :: 0 <= i < |"aaa"| ==> ("aaa"[i] == ' ' ==> r0[i] == '\0') && ("aaa"[i] != ' ' ==> r0[i] == "aaa"[i]);
}

method {:test} Test6() {
var r0 := ReplaceBlanksWithChar(" aaa", '\0');
expect |r0| == |" aaa"|;
expect forall i :: 0 <= i < |" aaa"| ==> (" aaa"[i] == ' ' ==> r0[i] == '\0') && (" aaa"[i] != ' ' ==> r0[i] == " aaa"[i]);
}

method {:test} Test7() {
var r0 := ReplaceBlanksWithChar(" a aa", '\0');
expect |r0| == |" a aa"|;
expect forall i :: 0 <= i < |" a aa"| ==> (" a aa"[i] == ' ' ==> r0[i] == '\0') && (" a aa"[i] != ' ' ==> r0[i] == " a aa"[i]);
}

method {:test} Test8() {
var r0 := ReplaceBlanksWithChar("  aaa ", '\0');
expect |r0| == |"  aaa "|;
expect forall i :: 0 <= i < |"  aaa "| ==> ("  aaa "[i] == ' ' ==> r0[i] == '\0') && ("  aaa "[i] != ' ' ==> r0[i] == "  aaa "[i]);
}

method {:test} Test9() {
var r0 := ReplaceBlanksWithChar(" \U{0001} ", '\0');
expect |r0| == |" \U{0001} "|;
expect forall i :: 0 <= i < |" \U{0001} "| ==> (" \U{0001} "[i] == ' ' ==> r0[i] == '\0') && (" \U{0001} "[i] != ' ' ==> r0[i] == " \U{0001} "[i]);
}

