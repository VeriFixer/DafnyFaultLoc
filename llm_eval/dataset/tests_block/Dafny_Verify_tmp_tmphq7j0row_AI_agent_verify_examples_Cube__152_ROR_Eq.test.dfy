method {:testEntry} Cube(n: nat) returns (c: nat)
  ensures c == n * n * n
{
  c := 0;
  var i := 0;
  var k := 1;
  var m := 6;
  while i == n
    invariant 0 <= i <= n
    invariant c == i * i * i
    invariant k == 3 * i * i + 3 * i + 1
    invariant m == 6 * i + 6
  {
    c, k, m := c + k, k + m, m + 6;
    i := i + 1;
  }
}


method {:test} Test0() {
var r0 := Cube(1797);
expect r0 == 1797 * 1797 * 1797;
}

method {:test} Test1() {
var r0 := Cube(9517);
expect r0 == 9517 * 9517 * 9517;
}

method {:test} Test2() {
var r0 := Cube(17237);
expect r0 == 17237 * 17237 * 17237;
}

method {:test} Test3() {
var r0 := Cube(17238);
expect r0 == 17238 * 17238 * 17238;
}

method {:test} Test4() {
var r0 := Cube(24958);
expect r0 == 24958 * 24958 * 24958;
}

method {:test} Test5() {
var r0 := Cube(32678);
expect r0 == 32678 * 32678 * 32678;
}

method {:test} Test6() {
var r0 := Cube(32679);
expect r0 == 32679 * 32679 * 32679;
}

method {:test} Test7() {
var r0 := Cube(32680);
expect r0 == 32680 * 32680 * 32680;
}

method {:test} Test8() {
var r0 := Cube(32681);
expect r0 == 32681 * 32681 * 32681;
}

method {:test} Test9() {
var r0 := Cube(40401);
expect r0 == 40401 * 40401 * 40401;
}

