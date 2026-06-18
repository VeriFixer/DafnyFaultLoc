// Programmverifikation-und-synthese_tmp_tmppurk6ime_PVS_Assignment_ex_06_Hoangkim_ex_06_hoangkim.dfy

ghost function gcd(x: int, y: int): int
  requires x > 0 && y > 0
{
  if x == y then
    x
  else if x > y then
    gcd(x - y, y)
  else
    gcd(x, y - x)
}

method {:testEntry} gcdI(m: int, n: int) returns (d: int)
  requires m > 0 && n > 0
  ensures d == gcd(m, n)
{
  var x: int;
  d := m;
  x := n;
  while d < x
    invariant x > 0
    invariant d > 0
    invariant gcd(d, x) == gcd(m, n)
    decreases x + d
  {
    if d > x {
      d := d - x;
    } else {
      x := x - d;
    }
  }
}

ghost function gcd'(x: int, y: int): int
  requires x > 0 && y > 0
  decreases if x > y then x else y
{
  if x == y then
    x
  else if x > y then
    gcd'(x - y, y)
  else
    gcd(y, x)
}



//Problem01
//a)
ghost function gcd(x: int, y: int): int
    requires x > 0 && y > 0
{
    if x == y then x
    else if x > y then gcd(x - y, y)
    else gcd(x, y - x)
}

method {:testEntry} gcdI(m: int, n: int) returns (d: int)
requires  m > 0 && n > 0 
ensures d == gcd(m, n);
{
    var x: int;
    d := m;
    x := n;
    while (d != x)
    invariant x > 0;
    invariant d > 0;
    invariant gcd(d, x) == gcd(m, n);
    decreases x+d;
    {
        if (d > x)
        {
            d := d - x;
        }
        else
        {
            x := x - d;
        }
    }
}

//b)
ghost function gcd'(x: int, y: int): int
    requires x > 0 && y > 0
    decreases if x > y then x else y
{
    if x == y then x
    else if x > y then gcd'(x - y, y)
    else gcd(y, x)
}

method {:test} Test0() {
expect 16677 > 0 && 7720 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(16677, 7720);
}
method {:test} Test1() {
expect 1 > 0 && 1239 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(1, 1239);
}
method {:test} Test2() {
expect 100 > 0 && 201 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(100, 201);
}
method {:test} Test3() {
expect 1239 > 0 && 1 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(1239, 1);
}
method {:test} Test4() {
expect 201 > 0 && 100 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(201, 100);
}

// REPEAT 1 - TIME: 7.4598863 s

method {:test} Test10() {
expect 16754 > 0 && 8377 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(16754, 8377);
}

// REPEAT 2 - TIME: 8.4223625 s

method {:test} Test11() {
expect 16757 > 0 && 8378 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(16757, 8378);
}

// REPEAT 3 - TIME: 9.2916865 s

method {:test} Test12() {
expect 16759 > 0 && 8379 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(16759, 8379);
}

// REPEAT 4 - TIME: 10.1386965 s

method {:test} Test13() {
expect 16836 > 0 && 8418 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := gcdI(16836, 8418);
}

// REPEAT 5 - TIME: 10.8883155 s
