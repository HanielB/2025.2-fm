---
layout: page
title: Dafny invariants and arrays
---

# Dafny invariants and arrays
{: .no_toc .mb-2 }

- TOC
{:toc}

## Readings

- [Dafny Reference Manual](https://dafny-lang.github.io/dafny/DafnyRef/DafnyRef)
- [Board for programs as transition systems]({{ site.baseurl }}{% link _lessons/dafny/board.png %})

### Recommended readings

- Lectures notes by Cesare Tinelli:
  - [Arrays in Dafny (part I)]({{ site.baseurl }}{% link _lessons/dafny/cesare-arrays.pdf %})
  - [Arrays in Dafny (part II)]({{ site.baseurl }}{% link _lessons/dafny/cesare-arrays-ii.pdf %})

## Topics

- Termination of while loops and recursive functions in Dafny.
- Abstraction of while loops by loop invariants.
- Functions and predicates.
- Complex specifications using recursive functions.
- Reading Frames.
- Termination of while loops and recursive functions in Dafny.
- Arrays and quantified verification conditions.
- Loop invariants for arrays.

## Programs as transition systems

Dafny verifies programs by reasoning about them *symbolically*. This way the
contracts we write are guaranteed to hold for *any* input the program runs on,
since verification was performed for *all* possible inputs.

An imperative program can be seen as a state machine, starting at an initial
state and transitioning between states as commands are performed. Each state is
defined by how the program variables are valued.

## Example: Fibonacci

``` c++
function fib (n:nat):nat
    decreases n
{
    if n == 0 then 0
    else if n == 1 then 1
    else fib(n - 1) + fib(n - 2)
}

method fibImp(n:nat) returns (res:nat)
    ensures res == fib(n)
{
    if n == 0 { return 0; }
    var i := 1;
    var a := 0;
    var b := 1;
    while i < n
        decreases n - i
        invariant i <= n
        invariant a == fib(i - 1)
        invariant b == fib(i)
    {
        a, b := b, a + b;
        i := i + 1;
    }
    // (i >= n ^ i <= n ^ fib(i) == b) => b == fib(n)
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
```

## Example Find

```c++
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
        index := index + 1;
    }
    index := -1;
    return;
}

method Main ()
{
    var a := new int[3];
    a[0], a[1], a[2] := 0, 3, -1;
    var res := Find(a, 3);
    print "Index with value 3 is ", res, "\n";
}
```

## Example Binary Search

``` c++
predicate isSorted(a : array<int>)
    reads a
{
    forall i, j :: 0 <= i < j < a.Length ==> a[i] < a[j]
}

// a[lo] <= a[lo+1] <= ... <= a[hi-2] <= a[hi-1]
method binSearch(a:array<int>, K:int) returns (b:bool)
    requires isSorted(a)
    ensures b <==> exists i : nat :: i < a.Length && a[i] == K
{
  var lo: nat := 0 ;
  var hi: nat := a.Length ;
  while (lo < hi)
    decreases hi - lo
    invariant lo <= hi <= a.Length
    invariant forall i : nat :: (i < lo || hi <= i < a.Length) ==> a[i] != K
  {
    var mid: nat := (lo + hi) / 2 ;
    if (a[mid] < K) {
      lo := mid + 1 ;
    } else if (a[mid] > K) {
      hi := mid ;
    } else {
      return true ;
    }
  }
  return false ;
}
```
