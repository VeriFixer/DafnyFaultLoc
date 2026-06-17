function Factorial(n: int): int
    requires n >= 0
    ensures 0 <= Factorial(n)
    {
        if n == 0 then 1
        else n * Factorial(n-1)
    }

    method {:testEntry} FactorialOfLastDigit(n: int) returns (fact: int)
    requires n >= 0
    ensures fact == Factorial(n % 10)
    {
        var lastDigit := n % 10;
        fact := Factorial(lastDigit);
    }

method {:test} Test0() {
expect 4 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := FactorialOfLastDigit(4);
expect r0 == Factorial(4 % 10);
}
method {:test} Test1() {
expect 0 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := FactorialOfLastDigit(0);
expect r0 == Factorial(0 % 10);
}
method {:test} Test2() {
expect 100 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := FactorialOfLastDigit(100);
expect r0 == Factorial(100 % 10);
}
method {:test} Test4() {
expect 5 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := FactorialOfLastDigit(5);
expect r0 == Factorial(5 % 10);
}
method {:test} Test5() {
expect 62834 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := FactorialOfLastDigit(62834);
expect r0 == Factorial(62834 % 10);
}

// REPEAT 1 - TIME: 5.7723594 s

method {:test} Test7() {
expect 62835 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := FactorialOfLastDigit(62835);
expect r0 == Factorial(62835 % 10);
}

// REPEAT 2 - TIME: 6.8827973 s

method {:test} Test8() {
expect 62836 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := FactorialOfLastDigit(62836);
expect r0 == Factorial(62836 % 10);
}

// REPEAT 3 - TIME: 7.7833109 s

method {:test} Test9() {
expect 62837 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := FactorialOfLastDigit(62837);
expect r0 == Factorial(62837 % 10);
}

// REPEAT 4 - TIME: 8.6222497 s

method {:test} Test10() {
expect 62838 >= 0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := FactorialOfLastDigit(62838);
expect r0 == Factorial(62838 % 10);
}

// REPEAT 5 - TIME: 9.3887415 s
