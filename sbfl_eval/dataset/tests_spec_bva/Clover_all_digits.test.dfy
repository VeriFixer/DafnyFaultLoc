  method {:testEntry} allDigits(s: string) returns (result: bool)
  ensures  result <==> (forall i :: 0 <= i < |s| ==> s[i] in "0123456789")
{
  result:=true ;
  for i := 0 to |s|
    invariant result <==> (forall ii :: 0 <= ii < i ==> s[ii] in "0123456789")
  {
    if ! (s[i] in "0123456789"){
      return false;
    }
  }
}

method {:test} Test0() {
var r0 := allDigits("");
expect r0 <==> forall i :: 0 <= i < |""| ==> ""[i] in "0123456789";
}
method {:test} Test2() {
var r0 := allDigits("a");
expect r0 <==> forall i :: 0 <= i < |"a"| ==> "a"[i] in "0123456789";
}
method {:test} Test3() {
var r0 := allDigits("aa");
expect r0 <==> forall i :: 0 <= i < |"aa"| ==> "aa"[i] in "0123456789";
}
method {:test} Test8() {
var r0 := allDigits("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\0");
expect r0 <==> forall i :: 0 <= i < |"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\0"| ==> "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\0"[i] in "0123456789";
}
method {:test} Test9() {
var r0 := allDigits("\0");
expect r0 <==> forall i :: 0 <= i < |"\0"| ==> "\0"[i] in "0123456789";
}
method {:test} Test10() {
var r0 := allDigits("\0a");
expect r0 <==> forall i :: 0 <= i < |"\0a"| ==> "\0a"[i] in "0123456789";
}

// REPEAT 1 - TIME: 9.8555926 s

method {:test} Test15() {
var r0 := allDigits("09aa");
expect r0 <==> forall i :: 0 <= i < |"09aa"| ==> "09aa"[i] in "0123456789";
}
method {:test} Test16() {
var r0 := allDigits("\U{0002}\0");
expect r0 <==> forall i :: 0 <= i < |"\U{0002}\0"| ==> "\U{0002}\0"[i] in "0123456789";
}

// REPEAT 2 - TIME: 11.191086 s

method {:test} Test17() {
var r0 := allDigits("13aaaaaa0aaaaaaaaaaaaaaaaaa2");
expect r0 <==> forall i :: 0 <= i < |"13aaaaaa0aaaaaaaaaaaaaaaaaa2"| ==> "13aaaaaa0aaaaaaaaaaaaaaaaaa2"[i] in "0123456789";
}
method {:test} Test18() {
var r0 := allDigits("a\0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\U{0004}\U{0002}");
expect r0 <==> forall i :: 0 <= i < |"a\0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\U{0004}\U{0002}"| ==> "a\0aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa\U{0004}\U{0002}"[i] in "0123456789";
}

// REPEAT 3 - TIME: 12.6624877 s

method {:test} Test19() {
var r0 := allDigits("235a4aaaaaaaaaaa1aaaaaaaa0");
expect r0 <==> forall i :: 0 <= i < |"235a4aaaaaaaaaaa1aaaaaaaa0"| ==> "235a4aaaaaaaaaaa1aaaaaaaa0"[i] in "0123456789";
}
method {:test} Test20() {
var r0 := allDigits("\U{0002}\0\U{0004}");
expect r0 <==> forall i :: 0 <= i < |"\U{0002}\0\U{0004}"| ==> "\U{0002}\0\U{0004}"[i] in "0123456789";
}

// REPEAT 4 - TIME: 14.5212827 s

method {:test} Test21() {
var r0 := allDigits("10");
expect r0 <==> forall i :: 0 <= i < |"10"| ==> "10"[i] in "0123456789";
}
method {:test} Test22() {
var r0 := allDigits("\U{0002}\0\U{0004}\U{0008}\U{0006}");
expect r0 <==> forall i :: 0 <= i < |"\U{0002}\0\U{0004}\U{0008}\U{0006}"| ==> "\U{0002}\0\U{0004}\U{0008}\U{0006}"[i] in "0123456789";
}

// REPEAT 5 - TIME: 15.9062413 s
