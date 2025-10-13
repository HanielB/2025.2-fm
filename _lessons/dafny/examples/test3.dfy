predicate isSorted(a : array<int>, k:int) 
    reads a
{
    forall i, j :: 0 <= i < j < a.Length ==> a[i] < a[j]
}

method myMethod(a:int) returns (index:int)
    ensures index == a;
{ 
    return a;
}

method myOtherMethod(a:array<int>)
    requires a.Length > 2
    modifies a
{
   a[2]:=0;
}

method Find(a: array<int>, key: int) returns (index: int)
    ensures index != -1 ==> 0 <= index < a.Length && a[index] == key
    ensures index == -1 ==> forall k :: 0 <= k < a.Length ==> a[k] != key
{
    index := 0;
    while (index < a.Length)
        decreases a.Length - index
        invariant 0 <= index <= a.Length
        invariant forall k :: 0 <= k < index ==> a[k] != key
    {
        // I[index, a] ^ (index < a.Length ^ a[index] != key) ==> I[b + 1, a]
        if (a[index] == key) { return; }
        var b := myMethod(index);
        index := b + 1;
    }
    index := -1;
    return;
    // return -1;
}



method Main ()
{
    var a := new int[3];
    a[0], a[1], a[2] := 0, 3, -1;
    var res := Find(a, 3);
    print "Index with value 3 is ", res, "\n";
}