method abs (x : int) returns (y : int)
    ensures 0 <= x ==> x == y
    ensures 0 > x ==> -x == y
{
    if x < 0 
    {
        return -x;
    }
    else
    {
        return x;
    }
}

method Main()
{
    var x := -3;
    var n := abs(x);
    assert n >= 0;
    print "Absolute value of ", x, ": ", n, "\n";
}

