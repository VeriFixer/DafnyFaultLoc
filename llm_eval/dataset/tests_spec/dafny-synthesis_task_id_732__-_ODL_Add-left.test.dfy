predicate IsSpaceCommaDot(c: char)
{
  c == ' ' || c == ',' || c == '.'
}

method {:testEntry} ReplaceWithColon(s: string) returns (v: string)
  ensures |v| == |s|
  ensures forall i :: 0 <= i < |s| ==> (IsSpaceCommaDot(s[i]) ==> v[i] == ':') && (!IsSpaceCommaDot(s[i]) ==> v[i] == s[i])
{
  var s': string := [];
  for i := 0 to |s|
    invariant 0 <= i <= |s|
    invariant |s'| == i
    invariant forall k :: 0 <= k < i ==> (IsSpaceCommaDot(s[k]) ==> s'[k] == ':') && (!IsSpaceCommaDot(s[k]) ==> s'[k] == s[k])
  {
    if IsSpaceCommaDot(s[i]) {
      s' := [':'];
    } else {
      s' := [s[i]];
    }
  }
  return s';
}


method {:test} Test0() {
var r0 := ReplaceWithColon("a");
expect |r0| == |"a"|;
expect forall i :: 0 <= i < |"a"| ==> (IsSpaceCommaDot("a"[i]) ==> r0[i] == ':') && (!IsSpaceCommaDot("a"[i]) ==> r0[i] == "a"[i]);
}

method {:test} Test1() {
var r0 := ReplaceWithColon("a:");
expect |r0| == |"a:"|;
expect forall i :: 0 <= i < |"a:"| ==> (IsSpaceCommaDot("a:"[i]) ==> r0[i] == ':') && (!IsSpaceCommaDot("a:"[i]) ==> r0[i] == "a:"[i]);
}

method {:test} Test2() {
var r0 := ReplaceWithColon("");
expect |r0| == |""|;
expect forall i :: 0 <= i < |""| ==> (IsSpaceCommaDot(""[i]) ==> r0[i] == ':') && (!IsSpaceCommaDot(""[i]) ==> r0[i] == ""[i]);
}

method {:test} Test3() {
var r0 := ReplaceWithColon("\U{0001}\0");
expect |r0| == |"\U{0001}\0"|;
expect forall i :: 0 <= i < |"\U{0001}\0"| ==> (IsSpaceCommaDot("\U{0001}\0"[i]) ==> r0[i] == ':') && (!IsSpaceCommaDot("\U{0001}\0"[i]) ==> r0[i] == "\U{0001}\0"[i]);
}

method {:test} Test4() {
var r0 := ReplaceWithColon("aaaaaaaaaaaaaaaaaa\0a");
expect |r0| == |"aaaaaaaaaaaaaaaaaa\0a"|;
expect forall i :: 0 <= i < |"aaaaaaaaaaaaaaaaaa\0a"| ==> (IsSpaceCommaDot("aaaaaaaaaaaaaaaaaa\0a"[i]) ==> r0[i] == ':') && (!IsSpaceCommaDot("aaaaaaaaaaaaaaaaaa\0a"[i]) ==> r0[i] == "aaaaaaaaaaaaaaaaaa\0a"[i]);
}

method {:test} Test5() {
var r0 := ReplaceWithColon("aaaaaaaaaaaaaaaaaaaa ");
expect |r0| == |"aaaaaaaaaaaaaaaaaaaa "|;
expect forall i :: 0 <= i < |"aaaaaaaaaaaaaaaaaaaa "| ==> (IsSpaceCommaDot("aaaaaaaaaaaaaaaaaaaa "[i]) ==> r0[i] == ':') && (!IsSpaceCommaDot("aaaaaaaaaaaaaaaaaaaa "[i]) ==> r0[i] == "aaaaaaaaaaaaaaaaaaaa "[i]);
}

method {:test} Test6() {
var r0 := ReplaceWithColon(" a aaaaaaaaaaaaaaaaa ");
expect |r0| == |" a aaaaaaaaaaaaaaaaa "|;
expect forall i :: 0 <= i < |" a aaaaaaaaaaaaaaaaa "| ==> (IsSpaceCommaDot(" a aaaaaaaaaaaaaaaaa "[i]) ==> r0[i] == ':') && (!IsSpaceCommaDot(" a aaaaaaaaaaaaaaaaa "[i]) ==> r0[i] == " a aaaaaaaaaaaaaaaaa "[i]);
}

method {:test} Test7() {
var r0 := ReplaceWithColon("\U{0002}aa\0aa\U{0001}");
expect |r0| == |"\U{0002}aa\0aa\U{0001}"|;
expect forall i :: 0 <= i < |"\U{0002}aa\0aa\U{0001}"| ==> (IsSpaceCommaDot("\U{0002}aa\0aa\U{0001}"[i]) ==> r0[i] == ':') && (!IsSpaceCommaDot("\U{0002}aa\0aa\U{0001}"[i]) ==> r0[i] == "\U{0002}aa\0aa\U{0001}"[i]);
}

method {:test} Test8() {
var r0 := ReplaceWithColon("  aa aa aaaaaaaaaaaa  ");
expect |r0| == |"  aa aa aaaaaaaaaaaa  "|;
expect forall i :: 0 <= i < |"  aa aa aaaaaaaaaaaa  "| ==> (IsSpaceCommaDot("  aa aa aaaaaaaaaaaa  "[i]) ==> r0[i] == ':') && (!IsSpaceCommaDot("  aa aa aaaaaaaaaaaa  "[i]) ==> r0[i] == "  aa aa aaaaaaaaaaaa  "[i]);
}

method {:test} Test9() {
var r0 := ReplaceWithColon("   a");
expect |r0| == |"   a"|;
expect forall i :: 0 <= i < |"   a"| ==> (IsSpaceCommaDot("   a"[i]) ==> r0[i] == ':') && (!IsSpaceCommaDot("   a"[i]) ==> r0[i] == "   a"[i]);
}

