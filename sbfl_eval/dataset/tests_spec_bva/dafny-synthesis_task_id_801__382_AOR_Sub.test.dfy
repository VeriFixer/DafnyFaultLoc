// dafny-synthesis_task_id_801.dfy

method {:testEntry} CountEqualNumbers(a: int, b: int, c: int)
    returns (count: int)
  ensures count >= 0 && count <= 3
  ensures count == 3 <==> a == b && b == c
  ensures count == 2 <==> (a == b && b != c) || (a != b && b == c) || (a == c && b != c)
  ensures count == 1 <==> a != b && b != c && a != c
{
  count := 1;
  if a == b {
    count := count - 1;
  }
  if a == c {
    count := count + 1;
  }
  if a != b && b == c {
    count := count + 1;
  }
}

method {:test} Test0() {
var r0 := CountEqualNumbers(25, 25, 25);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 25 == 25 && 25 == 25;
expect r0 == 2 <==> (25 == 25 && 25 != 25) || (25 != 25 && 25 == 25) || (25 == 25 && 25 != 25);
expect r0 == 1 <==> 25 != 25 && 25 != 25 && 25 != 25;
}
method {:test} Test1() {
var r0 := CountEqualNumbers(-100, -100, -100);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> -100 == -100 && -100 == -100;
expect r0 == 2 <==> (-100 == -100 && -100 != -100) || (-100 != -100 && -100 == -100) || (-100 == -100 && -100 != -100);
expect r0 == 1 <==> -100 != -100 && -100 != -100 && -100 != -100;
}
method {:test} Test2() {
var r0 := CountEqualNumbers(100, 100, 100);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 100 == 100 && 100 == 100;
expect r0 == 2 <==> (100 == 100 && 100 != 100) || (100 != 100 && 100 == 100) || (100 == 100 && 100 != 100);
expect r0 == 1 <==> 100 != 100 && 100 != 100 && 100 != 100;
}
method {:test} Test10() {
var r0 := CountEqualNumbers(26, 27, 27);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 26 == 27 && 27 == 27;
expect r0 == 2 <==> (26 == 27 && 27 != 27) || (26 != 27 && 27 == 27) || (26 == 27 && 27 != 27);
expect r0 == 1 <==> 26 != 27 && 27 != 27 && 26 != 27;
}
method {:test} Test11() {
var r0 := CountEqualNumbers(-100, 26, 26);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> -100 == 26 && 26 == 26;
expect r0 == 2 <==> (-100 == 26 && 26 != 26) || (-100 != 26 && 26 == 26) || (-100 == 26 && 26 != 26);
expect r0 == 1 <==> -100 != 26 && 26 != 26 && -100 != 26;
}
method {:test} Test12() {
var r0 := CountEqualNumbers(100, 26, 26);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 100 == 26 && 26 == 26;
expect r0 == 2 <==> (100 == 26 && 26 != 26) || (100 != 26 && 26 == 26) || (100 == 26 && 26 != 26);
expect r0 == 1 <==> 100 != 26 && 26 != 26 && 100 != 26;
}
method {:test} Test13() {
var r0 := CountEqualNumbers(26, -100, -100);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 26 == -100 && -100 == -100;
expect r0 == 2 <==> (26 == -100 && -100 != -100) || (26 != -100 && -100 == -100) || (26 == -100 && -100 != -100);
expect r0 == 1 <==> 26 != -100 && -100 != -100 && 26 != -100;
}
method {:test} Test14() {
var r0 := CountEqualNumbers(26, 100, 100);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 26 == 100 && 100 == 100;
expect r0 == 2 <==> (26 == 100 && 100 != 100) || (26 != 100 && 100 == 100) || (26 == 100 && 100 != 100);
expect r0 == 1 <==> 26 != 100 && 100 != 100 && 26 != 100;
}
method {:test} Test20() {
var r0 := CountEqualNumbers(27, 26, 27);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 27 == 26 && 26 == 27;
expect r0 == 2 <==> (27 == 26 && 26 != 27) || (27 != 26 && 26 == 27) || (27 == 27 && 26 != 27);
expect r0 == 1 <==> 27 != 26 && 26 != 27 && 27 != 27;
}
method {:test} Test21() {
var r0 := CountEqualNumbers(-100, 26, -100);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> -100 == 26 && 26 == -100;
expect r0 == 2 <==> (-100 == 26 && 26 != -100) || (-100 != 26 && 26 == -100) || (-100 == -100 && 26 != -100);
expect r0 == 1 <==> -100 != 26 && 26 != -100 && -100 != -100;
}
method {:test} Test22() {
var r0 := CountEqualNumbers(100, 26, 100);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 100 == 26 && 26 == 100;
expect r0 == 2 <==> (100 == 26 && 26 != 100) || (100 != 26 && 26 == 100) || (100 == 100 && 26 != 100);
expect r0 == 1 <==> 100 != 26 && 26 != 100 && 100 != 100;
}
method {:test} Test23() {
var r0 := CountEqualNumbers(26, -100, 26);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 26 == -100 && -100 == 26;
expect r0 == 2 <==> (26 == -100 && -100 != 26) || (26 != -100 && -100 == 26) || (26 == 26 && -100 != 26);
expect r0 == 1 <==> 26 != -100 && -100 != 26 && 26 != 26;
}
method {:test} Test24() {
var r0 := CountEqualNumbers(26, 100, 26);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 26 == 100 && 100 == 26;
expect r0 == 2 <==> (26 == 100 && 100 != 26) || (26 != 100 && 100 == 26) || (26 == 26 && 100 != 26);
expect r0 == 1 <==> 26 != 100 && 100 != 26 && 26 != 26;
}
method {:test} Test30() {
var r0 := CountEqualNumbers(26, 27, 28);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 26 == 27 && 27 == 28;
expect r0 == 2 <==> (26 == 27 && 27 != 28) || (26 != 27 && 27 == 28) || (26 == 28 && 27 != 28);
expect r0 == 1 <==> 26 != 27 && 27 != 28 && 26 != 28;
}
method {:test} Test31() {
var r0 := CountEqualNumbers(-100, 26, 27);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> -100 == 26 && 26 == 27;
expect r0 == 2 <==> (-100 == 26 && 26 != 27) || (-100 != 26 && 26 == 27) || (-100 == 27 && 26 != 27);
expect r0 == 1 <==> -100 != 26 && 26 != 27 && -100 != 27;
}
method {:test} Test32() {
var r0 := CountEqualNumbers(100, 26, 27);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 100 == 26 && 26 == 27;
expect r0 == 2 <==> (100 == 26 && 26 != 27) || (100 != 26 && 26 == 27) || (100 == 27 && 26 != 27);
expect r0 == 1 <==> 100 != 26 && 26 != 27 && 100 != 27;
}
method {:test} Test33() {
var r0 := CountEqualNumbers(26, -100, 27);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 26 == -100 && -100 == 27;
expect r0 == 2 <==> (26 == -100 && -100 != 27) || (26 != -100 && -100 == 27) || (26 == 27 && -100 != 27);
expect r0 == 1 <==> 26 != -100 && -100 != 27 && 26 != 27;
}
method {:test} Test34() {
var r0 := CountEqualNumbers(26, 100, 27);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 26 == 100 && 100 == 27;
expect r0 == 2 <==> (26 == 100 && 100 != 27) || (26 != 100 && 100 == 27) || (26 == 27 && 100 != 27);
expect r0 == 1 <==> 26 != 100 && 100 != 27 && 26 != 27;
}
method {:test} Test35() {
var r0 := CountEqualNumbers(26, 27, -100);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 26 == 27 && 27 == -100;
expect r0 == 2 <==> (26 == 27 && 27 != -100) || (26 != 27 && 27 == -100) || (26 == -100 && 27 != -100);
expect r0 == 1 <==> 26 != 27 && 27 != -100 && 26 != -100;
}
method {:test} Test36() {
var r0 := CountEqualNumbers(26, 27, 100);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 26 == 27 && 27 == 100;
expect r0 == 2 <==> (26 == 27 && 27 != 100) || (26 != 27 && 27 == 100) || (26 == 100 && 27 != 100);
expect r0 == 1 <==> 26 != 27 && 27 != 100 && 26 != 100;
}
method {:test} Test40() {
var r0 := CountEqualNumbers(26, 26, 27);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 26 == 26 && 26 == 27;
expect r0 == 2 <==> (26 == 26 && 26 != 27) || (26 != 26 && 26 == 27) || (26 == 27 && 26 != 27);
expect r0 == 1 <==> 26 != 26 && 26 != 27 && 26 != 27;
}
method {:test} Test41() {
var r0 := CountEqualNumbers(-100, -100, 26);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> -100 == -100 && -100 == 26;
expect r0 == 2 <==> (-100 == -100 && -100 != 26) || (-100 != -100 && -100 == 26) || (-100 == 26 && -100 != 26);
expect r0 == 1 <==> -100 != -100 && -100 != 26 && -100 != 26;
}
method {:test} Test42() {
var r0 := CountEqualNumbers(100, 100, 26);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 100 == 100 && 100 == 26;
expect r0 == 2 <==> (100 == 100 && 100 != 26) || (100 != 100 && 100 == 26) || (100 == 26 && 100 != 26);
expect r0 == 1 <==> 100 != 100 && 100 != 26 && 100 != 26;
}
method {:test} Test45() {
var r0 := CountEqualNumbers(26, 26, -100);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 26 == 26 && 26 == -100;
expect r0 == 2 <==> (26 == 26 && 26 != -100) || (26 != 26 && 26 == -100) || (26 == -100 && 26 != -100);
expect r0 == 1 <==> 26 != 26 && 26 != -100 && 26 != -100;
}
method {:test} Test46() {
var r0 := CountEqualNumbers(26, 26, 100);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 26 == 26 && 26 == 100;
expect r0 == 2 <==> (26 == 26 && 26 != 100) || (26 != 26 && 26 == 100) || (26 == 100 && 26 != 100);
expect r0 == 1 <==> 26 != 26 && 26 != 100 && 26 != 100;
}

// REPEAT 1 - TIME: 140.9959687 s

method {:test} Test50() {
var r0 := CountEqualNumbers(24, 24, 24);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 24 == 24 && 24 == 24;
expect r0 == 2 <==> (24 == 24 && 24 != 24) || (24 != 24 && 24 == 24) || (24 == 24 && 24 != 24);
expect r0 == 1 <==> 24 != 24 && 24 != 24 && 24 != 24;
}
method {:test} Test51() {
var r0 := CountEqualNumbers(30, 31, 31);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 30 == 31 && 31 == 31;
expect r0 == 2 <==> (30 == 31 && 31 != 31) || (30 != 31 && 31 == 31) || (30 == 31 && 31 != 31);
expect r0 == 1 <==> 30 != 31 && 31 != 31 && 30 != 31;
}
method {:test} Test52() {
var r0 := CountEqualNumbers(30, 31, 30);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 30 == 31 && 31 == 30;
expect r0 == 2 <==> (30 == 31 && 31 != 30) || (30 != 31 && 31 == 30) || (30 == 30 && 31 != 30);
expect r0 == 1 <==> 30 != 31 && 31 != 30 && 30 != 30;
}
method {:test} Test53() {
var r0 := CountEqualNumbers(30, 31, 32);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 30 == 31 && 31 == 32;
expect r0 == 2 <==> (30 == 31 && 31 != 32) || (30 != 31 && 31 == 32) || (30 == 32 && 31 != 32);
expect r0 == 1 <==> 30 != 31 && 31 != 32 && 30 != 32;
}
method {:test} Test54() {
var r0 := CountEqualNumbers(24, 24, 29);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 24 == 24 && 24 == 29;
expect r0 == 2 <==> (24 == 24 && 24 != 29) || (24 != 24 && 24 == 29) || (24 == 29 && 24 != 29);
expect r0 == 1 <==> 24 != 24 && 24 != 29 && 24 != 29;
}

// REPEAT 2 - TIME: 149.8106813 s

method {:test} Test55() {
var r0 := CountEqualNumbers(34, 34, 34);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 34 == 34 && 34 == 34;
expect r0 == 2 <==> (34 == 34 && 34 != 34) || (34 != 34 && 34 == 34) || (34 == 34 && 34 != 34);
expect r0 == 1 <==> 34 != 34 && 34 != 34 && 34 != 34;
}
method {:test} Test56() {
var r0 := CountEqualNumbers(34, 33, 33);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 34 == 33 && 33 == 33;
expect r0 == 2 <==> (34 == 33 && 33 != 33) || (34 != 33 && 33 == 33) || (34 == 33 && 33 != 33);
expect r0 == 1 <==> 34 != 33 && 33 != 33 && 34 != 33;
}
method {:test} Test57() {
var r0 := CountEqualNumbers(35, 36, 35);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 35 == 36 && 36 == 35;
expect r0 == 2 <==> (35 == 36 && 36 != 35) || (35 != 36 && 36 == 35) || (35 == 35 && 36 != 35);
expect r0 == 1 <==> 35 != 36 && 36 != 35 && 35 != 35;
}
method {:test} Test58() {
var r0 := CountEqualNumbers(34, 33, 35);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 34 == 33 && 33 == 35;
expect r0 == 2 <==> (34 == 33 && 33 != 35) || (34 != 33 && 33 == 35) || (34 == 35 && 33 != 35);
expect r0 == 1 <==> 34 != 33 && 33 != 35 && 34 != 35;
}
method {:test} Test59() {
var r0 := CountEqualNumbers(34, 34, 33);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 34 == 34 && 34 == 33;
expect r0 == 2 <==> (34 == 34 && 34 != 33) || (34 != 34 && 34 == 33) || (34 == 33 && 34 != 33);
expect r0 == 1 <==> 34 != 34 && 34 != 33 && 34 != 33;
}

// REPEAT 3 - TIME: 158.5934669 s

method {:test} Test60() {
var r0 := CountEqualNumbers(38, 38, 38);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 38 == 38 && 38 == 38;
expect r0 == 2 <==> (38 == 38 && 38 != 38) || (38 != 38 && 38 == 38) || (38 == 38 && 38 != 38);
expect r0 == 1 <==> 38 != 38 && 38 != 38 && 38 != 38;
}
method {:test} Test61() {
var r0 := CountEqualNumbers(38, 37, 37);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 38 == 37 && 37 == 37;
expect r0 == 2 <==> (38 == 37 && 37 != 37) || (38 != 37 && 37 == 37) || (38 == 37 && 37 != 37);
expect r0 == 1 <==> 38 != 37 && 37 != 37 && 38 != 37;
}
method {:test} Test62() {
var r0 := CountEqualNumbers(38, 37, 38);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 38 == 37 && 37 == 38;
expect r0 == 2 <==> (38 == 37 && 37 != 38) || (38 != 37 && 37 == 38) || (38 == 38 && 37 != 38);
expect r0 == 1 <==> 38 != 37 && 37 != 38 && 38 != 38;
}
method {:test} Test63() {
var r0 := CountEqualNumbers(39, 40, 41);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 39 == 40 && 40 == 41;
expect r0 == 2 <==> (39 == 40 && 40 != 41) || (39 != 40 && 40 == 41) || (39 == 41 && 40 != 41);
expect r0 == 1 <==> 39 != 40 && 40 != 41 && 39 != 41;
}
method {:test} Test64() {
var r0 := CountEqualNumbers(37, 37, 38);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 37 == 37 && 37 == 38;
expect r0 == 2 <==> (37 == 37 && 37 != 38) || (37 != 37 && 37 == 38) || (37 == 38 && 37 != 38);
expect r0 == 1 <==> 37 != 37 && 37 != 38 && 37 != 38;
}

// REPEAT 4 - TIME: 167.4098008 s

method {:test} Test65() {
var r0 := CountEqualNumbers(42, 42, 42);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 42 == 42 && 42 == 42;
expect r0 == 2 <==> (42 == 42 && 42 != 42) || (42 != 42 && 42 == 42) || (42 == 42 && 42 != 42);
expect r0 == 1 <==> 42 != 42 && 42 != 42 && 42 != 42;
}
method {:test} Test66() {
var r0 := CountEqualNumbers(43, 42, 42);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 43 == 42 && 42 == 42;
expect r0 == 2 <==> (43 == 42 && 42 != 42) || (43 != 42 && 42 == 42) || (43 == 42 && 42 != 42);
expect r0 == 1 <==> 43 != 42 && 42 != 42 && 43 != 42;
}
method {:test} Test67() {
var r0 := CountEqualNumbers(43, 42, 43);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 43 == 42 && 42 == 43;
expect r0 == 2 <==> (43 == 42 && 42 != 43) || (43 != 42 && 42 == 43) || (43 == 43 && 42 != 43);
expect r0 == 1 <==> 43 != 42 && 42 != 43 && 43 != 43;
}
method {:test} Test68() {
var r0 := CountEqualNumbers(43, 42, 44);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 43 == 42 && 42 == 44;
expect r0 == 2 <==> (43 == 42 && 42 != 44) || (43 != 42 && 42 == 44) || (43 == 44 && 42 != 44);
expect r0 == 1 <==> 43 != 42 && 42 != 44 && 43 != 44;
}
method {:test} Test69() {
var r0 := CountEqualNumbers(44, 44, 45);
expect r0 >= 0 && r0 <= 3;
expect r0 == 3 <==> 44 == 44 && 44 == 45;
expect r0 == 2 <==> (44 == 44 && 44 != 45) || (44 != 44 && 44 == 45) || (44 == 45 && 44 != 45);
expect r0 == 1 <==> 44 != 44 && 44 != 45 && 44 != 45;
}

// REPEAT 5 - TIME: 176.3894152 s
