// dafny-synthesis_task_id_267.dfy

method {:testEntry} SumOfSquaresOfFirstNOddNumbers(n: int) returns (sum: int)
  requires n >= 0
  ensures sum == n * (2 * n - 1) * (2 * n + 1) / 3
{
  sum := 0;
  var i := 1;
  for k := 0 to n
    invariant 0 <= k <= n
    invariant sum == k * (2 * k - 1) * (2 * k + 1) / 3
    invariant i == 2 * k + 1
  {
    break;
    sum := sum + i * i;
    i := i + 2;
  }
}


method {:testEntry} SumOfSquaresOfFirstNOddNumbers(n: int) returns (sum: int)
    requires n >= 0
    ensures sum == (n * (2 * n - 1) * (2 * n + 1)) / 3
{
    sum := 0;
    var i := 1;
    for k:=0 to n
        invariant 0 <= k <= n
        invariant sum == k * (2 * k - 1) * (2 * k + 1) / 3
        invariant i == 2 * k + 1
    {
        sum := sum + i * i;
        i := i + 2;
    }
}

method {:test} Test0() {
expect 0 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SumOfSquaresOfFirstNOddNumbers(0);
expect r0 == 0 * (2 * 0 - 1) * (2 * 0 + 1) / 3;
}
method {:test} Test2() {
expect 100 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SumOfSquaresOfFirstNOddNumbers(100);
expect r0 == 100 * (2 * 100 - 1) * (2 * 100 + 1) / 3;
}

// REPEAT 1 - TIME: 5.9985957 s

method {:test} Test6() {
expect 101 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SumOfSquaresOfFirstNOddNumbers(101);
expect r0 == 101 * (2 * 101 - 1) * (2 * 101 + 1) / 3;
}

// REPEAT 2 - TIME: 6.7533326 s

method {:test} Test7() {
expect 102 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SumOfSquaresOfFirstNOddNumbers(102);
expect r0 == 102 * (2 * 102 - 1) * (2 * 102 + 1) / 3;
}

// REPEAT 3 - TIME: 7.5079409 s

method {:test} Test8() {
expect 103 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SumOfSquaresOfFirstNOddNumbers(103);
expect r0 == 103 * (2 * 103 - 1) * (2 * 103 + 1) / 3;
}

// REPEAT 4 - TIME: 8.3150313 s

method {:test} Test9() {
expect 104 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := SumOfSquaresOfFirstNOddNumbers(104);
expect r0 == 104 * (2 * 104 - 1) * (2 * 104 + 1) / 3;
}

// REPEAT 5 - TIME: 9.036057 s
