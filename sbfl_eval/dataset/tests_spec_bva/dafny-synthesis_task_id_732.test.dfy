predicate IsSpaceCommaDot(c: char)
{
    c == ' ' || c == ',' || c == '.'
}

method {:testEntry} ReplaceWithColon(s: string) returns (v: string)
    ensures |v| == |s|
    ensures forall i :: 0 <= i < |s| ==> (IsSpaceCommaDot(s[i]) ==> v[i] == ':') && (!IsSpaceCommaDot(s[i]) ==> v[i] == s[i])
{
    var s' : string := [];
    for i := 0 to |s|
    invariant 0 <= i <= |s|
    invariant |s'| == i
    invariant forall k :: 0 <= k < i ==> (IsSpaceCommaDot(s[k]) ==> s'[k] == ':') && (!IsSpaceCommaDot(s[k]) ==> s'[k] == s[k])
    {
        if IsSpaceCommaDot(s[i])
        {
            s' := s' + [':'];
        }
        else 
        {
            s' := s' + [s[i]];
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
var r0 := ReplaceWithColon("");
expect |r0| == |""|;
expect forall i :: 0 <= i < |""| ==> (IsSpaceCommaDot(""[i]) ==> r0[i] == ':') && (!IsSpaceCommaDot(""[i]) ==> r0[i] == ""[i]);
}
method {:test} Test3() {
var r0 := ReplaceWithColon("aa");
expect |r0| == |"aa"|;
expect forall i :: 0 <= i < |"aa"| ==> (IsSpaceCommaDot("aa"[i]) ==> r0[i] == ':') && (!IsSpaceCommaDot("aa"[i]) ==> r0[i] == "aa"[i]);
}

// REPEAT 1 - TIME: 6.8242815 s

method {:test} Test10() {
var r0 := ReplaceWithColon("a\0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\U{0001}");
expect |r0| == |"a\0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\U{0001}"|;
expect forall i :: 0 <= i < |"a\0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\U{0001}"| ==> (IsSpaceCommaDot("a\0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\U{0001}"[i]) ==> r0[i] == ':') && (!IsSpaceCommaDot("a\0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\U{0001}"[i]) ==> r0[i] == "a\0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\U{0001}"[i]);
}

// REPEAT 2 - TIME: 7.7076045 s

method {:test} Test11() {
var r0 := ReplaceWithColon(" a ");
expect |r0| == |" a "|;
expect forall i :: 0 <= i < |" a "| ==> (IsSpaceCommaDot(" a "[i]) ==> r0[i] == ':') && (!IsSpaceCommaDot(" a "[i]) ==> r0[i] == " a "[i]);
}

// REPEAT 3 - TIME: 8.5390791 s

method {:test} Test12() {
var r0 := ReplaceWithColon("aaa aaaaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaa ");
expect |r0| == |"aaa aaaaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaa "|;
expect forall i :: 0 <= i < |"aaa aaaaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaa "| ==> (IsSpaceCommaDot("aaa aaaaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaa "[i]) ==> r0[i] == ':') && (!IsSpaceCommaDot("aaa aaaaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaa "[i]) ==> r0[i] == "aaa aaaaaaaaaaaaaaaaaaaaa aaaaaaaaaaaaaaa "[i]);
}

// REPEAT 4 - TIME: 9.3997459 s

method {:test} Test13() {
var r0 := ReplaceWithColon("aaaa ");
expect |r0| == |"aaaa "|;
expect forall i :: 0 <= i < |"aaaa "| ==> (IsSpaceCommaDot("aaaa "[i]) ==> r0[i] == ':') && (!IsSpaceCommaDot("aaaa "[i]) ==> r0[i] == "aaaa "[i]);
}

// REPEAT 5 - TIME: 10.2829773 s
