// dafny-synthesis_task_id_599.dfy

method {:testEntry} SumAndAverage(n: int) returns (sum: int, average: real)
  requires n > 0
  ensures sum == n * (n + 1) / 2
  ensures average == sum as real / n as real
{
  sum := 0;
  for i := 1 to 1
    invariant 0 <= i <= n + 1
    invariant sum == (i - 1) * i / 2
  {
    sum := i;
  }
  average := sum as real / n as real;
}


method {:testEntry} SumAndAverage(n: int) returns (sum: int, average: real)
    requires n > 0
    ensures sum == n * (n + 1) / 2
    ensures average == sum as real / n as real
{
    sum := 0;
    for i := 1 to n + 1
    invariant 0 <= i <= n + 1
    invariant sum == (i - 1) * i / 2
    {
        sum := sum + i;
    }
    average := sum as real / n as real;
}

method {:test} Test0() {
expect 1 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := SumAndAverage(1);
expect r0 == 1 * (1 + 1) / 2;
expect r1 == r0 as real / 1 as real;
}
method {:test} Test2() {
expect 100 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := SumAndAverage(100);
expect r0 == 100 * (100 + 1) / 2;
expect r1 == r0 as real / 100 as real;
}
method {:test} Test5() {
expect 199 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := SumAndAverage(199);
expect r0 == 199 * (199 + 1) / 2;
expect r1 == r0 as real / 199 as real;
}

// REPEAT 1 - TIME: 6.803392 s

method {:test} Test8() {
expect 200 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := SumAndAverage(200);
expect r0 == 200 * (200 + 1) / 2;
expect r1 == r0 as real / 200 as real;
}

// REPEAT 2 - TIME: 7.7309619 s

method {:test} Test9() {
expect 201 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := SumAndAverage(201);
expect r0 == 201 * (201 + 1) / 2;
expect r1 == r0 as real / 201 as real;
}

// REPEAT 3 - TIME: 8.4134877 s

method {:test} Test10() {
expect 202 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := SumAndAverage(202);
expect r0 == 202 * (202 + 1) / 2;
expect r1 == r0 as real / 202 as real;
}

// REPEAT 4 - TIME: 9.1991662 s

method {:test} Test11() {
expect 203 > 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0, r1 := SumAndAverage(203);
expect r0 == 203 * (203 + 1) / 2;
expect r1 == r0 as real / 203 as real;
}

// REPEAT 5 - TIME: 9.8504959 s
