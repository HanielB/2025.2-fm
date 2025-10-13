function fib (n : nat) : nat
    decreases n
{
    if n == 0 then 0
    else if n == 1 then 1
    else fib(n-1) + fib(n-2)
}

method fibImp(n : nat) returns (res : nat)
    ensures res == fib(n)
{
    if n == 0 { return 0; }
    var i := 1;
    var a := 0;
    var b := 1;
    while i < n
        decreases n - i
        invariant i <= n
        invariant fib(i-1) == a
        invariant fib(i) == b
    {
        a, b := b, a + b;
        i := i + 1;
    }
    return b;
}

method Main()
{
    var x := 6;
    var i := 1;
    while i <= x
    {
        var res := fibImp(i);
        print "fib(", i, ") = ", res, "\n";
        i := i + 1;
    }
}