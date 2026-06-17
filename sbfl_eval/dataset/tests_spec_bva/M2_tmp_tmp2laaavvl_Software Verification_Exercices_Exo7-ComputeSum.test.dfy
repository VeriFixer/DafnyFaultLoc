function Sum(n:nat):nat
 
{
  if n==0 then  0 else n + Sum(n-1)
}

method {:testEntry} ComputeSum(n:nat) returns (s:nat)
    ensures s ==Sum(n)
{
    s := 0;
    var i := 0;
    while i< n
      invariant 0 <= i <= n
      invariant s == Sum(i)
      {
        s := s + i + 1;
        i := i+1;
      }
}

method {:test} Test0() {
var r0 := ComputeSum(7721);
expect r0 == Sum(7721);
}
method {:test} Test1() {
var r0 := ComputeSum(100);
expect r0 == Sum(100);
}
method {:test} Test3() {
var r0 := ComputeSum(24);
expect r0 == Sum(24);
}

// REPEAT 1 - TIME: 6.0171547 s

method {:test} Test6() {
var r0 := ComputeSum(7722);
expect r0 == Sum(7722);
}

// REPEAT 2 - TIME: 7.0539557 s

method {:test} Test7() {
var r0 := ComputeSum(7723);
expect r0 == Sum(7723);
}

// REPEAT 3 - TIME: 7.8894675 s

method {:test} Test8() {
var r0 := ComputeSum(7724);
expect r0 == Sum(7724);
}

// REPEAT 4 - TIME: 8.7240383 s

method {:test} Test9() {
var r0 := ComputeSum(7725);
expect r0 == Sum(7725);
}

// REPEAT 5 - TIME: 9.4523224 s
