// Clover_all_digits.dfy

method {:testEntry} allDigits(s: string) returns (result: bool)
  ensures result <==> forall i :: 0 <= i < |s| ==> s[i] in "0123456789"
{
  result := true;
  for i := 0 to |""|
    invariant result <==> forall ii :: 0 <= ii < i ==> s[ii] in "0123456789"
  {
    if !(s[i] in "0123456789") {
      return false;
    }
  }
}


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
var r0 := allDigits("aaaaaaaa\0");
expect r0 <==> forall i :: 0 <= i < |"aaaaaaaa\0"| ==> "aaaaaaaa\0"[i] in "0123456789";
}
method {:test} Test9() {
var r0 := allDigits("\0");
expect r0 <==> forall i :: 0 <= i < |"\0"| ==> "\0"[i] in "0123456789";
}
method {:test} Test10() {
var r0 := allDigits("\0a");
expect r0 <==> forall i :: 0 <= i < |"\0a"| ==> "\0a"[i] in "0123456789";
}

// REPEAT 1 - TIME: 10.1302037 s

method {:test} Test15() {
var r0 := allDigits("0aaaaaaaaaaaa9aa");
expect r0 <==> forall i :: 0 <= i < |"0aaaaaaaaaaaa9aa"| ==> "0aaaaaaaaaaaa9aa"[i] in "0123456789";
}
method {:test} Test16() {
var r0 := allDigits("a\0\U{0002}");
expect r0 <==> forall i :: 0 <= i < |"a\0\U{0002}"| ==> "a\0\U{0002}"[i] in "0123456789";
}

// REPEAT 2 - TIME: 11.1770873 s

method {:test} Test17() {
var r0 := allDigits("1090aaaaaaa");
expect r0 <==> forall i :: 0 <= i < |"1090aaaaaaa"| ==> "1090aaaaaaa"[i] in "0123456789";
}
method {:test} Test18() {
var r0 := allDigits("\U{0004}\0\U{0002}");
expect r0 <==> forall i :: 0 <= i < |"\U{0004}\0\U{0002}"| ==> "\U{0004}\0\U{0002}"[i] in "0123456789";
}

// REPEAT 3 - TIME: 12.3482072 s

method {:test} Test19() {
var r0 := allDigits("1210");
expect r0 <==> forall i :: 0 <= i < |"1210"| ==> "1210"[i] in "0123456789";
}
method {:test} Test20() {
var r0 := allDigits("\U{0004}\0\U{0006}\U{0002}");
expect r0 <==> forall i :: 0 <= i < |"\U{0004}\0\U{0006}\U{0002}"| ==> "\U{0004}\0\U{0006}\U{0002}"[i] in "0123456789";
}

// REPEAT 4 - TIME: 13.703013 s

method {:test} Test21() {
var r0 := allDigits("210");
expect r0 <==> forall i :: 0 <= i < |"210"| ==> "210"[i] in "0123456789";
}
method {:test} Test22() {
var r0 := allDigits("\U{0004}a\U{0002}aaaaaaaaaaaaaaaaaaaaaaaa\0");
expect r0 <==> forall i :: 0 <= i < |"\U{0004}a\U{0002}aaaaaaaaaaaaaaaaaaaaaaaa\0"| ==> "\U{0004}a\U{0002}aaaaaaaaaaaaaaaaaaaaaaaa\0"[i] in "0123456789";
}

// REPEAT 5 - TIME: 15.3387151 s
