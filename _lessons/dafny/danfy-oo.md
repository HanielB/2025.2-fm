---
layout: page
title: Dafny and object orientation
---

# Dafny and object orientation

{: .no_toc .mb-2 }

- TOC
{:toc}

## Readings

- [Lein13]({{ site.baseurl }}{% link _lessons/dafny/Lein13.pdf %}) and [Herb11]({{ site.baseurl }}{% link _lessons/dafny/Herb11.pdf %}), tutorial and lecture notes on Dafny
- [Collection types](https://dafny-lang.github.io/dafny/DafnyRef/DafnyRef#sec-collection-types) chapter from Dafny's refernce manual
- [Class types](https://dafny-lang.github.io/dafny/DafnyRef/DafnyRef#sec-class-types) chapter from Dafny's refernce manual

### Recommended readings

- [Dafny power user](http://leino.science/dafny-power-user/)

## Collection types

Dafny offers several built-in collection types. Of particular interest for us are `sets` and `sequences`. A few examples of their usage are below.

### Sets

Examples:

``` c++
method m1()
{
   var s1 : set<int> := {}; // the empty set
   var s2 := {1, 2, 3}; // set contains exactly 1, 2, and 3
   assert s2 == {1,1,2,3,3,3,3}; // same as before
   var s3, s4 := {1,2}, {1,4};
}

method m2 ()
{
   var s1 : set<int> := {};
   var s2 := {1, 2, 3};
   var s3, s4 := {1,2}, {1,4};
   assert s2 + s4 == {1,2,3,4}; // set union
   assert s2 * s3 == {1,2} && s2 * s4 == {1}; // set intersection
   assert s2 - s3 == {3}; // set difference
}

method m3()
{
   assert {1} <= {1, 2} && {1, 2} <= {1, 2}; // subset
   assert {} < {1, 2} && !({1} < {1}); // strict, or proper, subset
   assert !({1, 2} <= {1, 4}) && !({1, 4} < {1, 4}); // no relation
   assert {1, 2} == {1, 2} && {1, 3} != {1, 2}; // equality and non-equality
}

method m4()
{
   assert 5 in {1,3,4,5};
   assert 1 in {1,3,4,5};
   assert 2 !in {1,3,4,5};
   assert forall x : set<int> :: x !in {};

}

method m5()
{
   assert (set x | x in {0,1,2}) == {0,1,2};
   assert (set x | x in {0,1,2,3,4,5} && x < 3 :: x) == {0,1,2};
}
```

Note that Dafny may fire a warning for quantifiers and sets above that "no terms
found to trigger on". This is because by default variables are not chosen as
*triggers*, but rather function applications (and arrays etc can be seen as
function applications).

- *Triggers* are terms that occur in the body of the quanified formula or the
  set definition in question. They are used to guide the automated reasoning
  happening under the hood in Dafny and an expert feature.

### Sequences

Examples:

``` c++
function method len(s:seq<int>) : int
  decreases s;
 {
  if s == [] then 0
  else 1 + len(s[1..])
}

function method greatest(x:int, y:int) : int
{
  if x > y then x else y
}

function method max(s:seq<int>) : int
  requires len(s) >= 1
  decreases s;
{
  if len(s) == 1 then s[0]
  else greatest(s[0], max(s[1..]))
}

predicate sorted(s: seq<int>)
{
   forall i,j :: 0 <= i < j < |s| ==> s[i] <= s[j]
}

predicate sorted2(s: seq<int>)
  decreases s;
{
   0 < |s| ==> (forall i :: 0 < i < |s| ==> s[0] <= s[i]) &&
               sorted2(s[1..])
}

method m()
{
   var a := new int[3]; // 3 element array of ints
   a[0], a[1], a[2] := 0, 3, -1;
   var s := a[..];
   assert s == [0, 3, -1];

  assert forall x ::
           (forall k :: 0 <= k < a.Length ==> x != a[k])
           <==>
           x !in a[..];
}


method m1()
{
   var s := [1, 2, 3, 4, 5];
   assert s[|s|-1] == 5; //access the last element
   assert s[|s|-1..|s|] == [5]; //slice just the last element, as a singleton
   assert s[1..] == [2, 3, 4, 5]; // everything but the first
   assert s[..|s|-1] == [1, 2, 3, 4]; // everything but the last
   assert s == s[0..] == s[..|s|] == s[0..|s|]; // the whole sequence


   assert [1,2,3] == [1] + [2,3];
   assert s == s + [];
   assert forall i :: 0 <= i <= |s| ==> s == s[..i] + s[i..];

   assert forall a: seq<int>, b: seq<int>, c: seq<int> ::
      (a + b) + c == a + (b + c);

   assert 5 in s;
   assert 0 !in s;

   assert s[2 := 6] == [1,2,6,4,5];
}

function update(s: seq<int>, i: int, v: int): seq<int>
   requires 0 <= i < |s|
   ensures update(s, i, v) == s[i := v]
{
   s[..i] + [v] + s[i+1..]
   // This works by concatenating everything that doesn't
   // change with the singleton of the new value.
}
```

## Class types

From [Lein13]({{ site.baseurl }}{% link _lessons/dafny/Lein13.pdf %}):

> Classes offer a way to dynamically allocate mutable data
structures. References (that is, pointers) to components of these data
structures gives flexibility in programming, but generally also make
specifications more complicated (though, arguably, also make verification more
worthwhile). A common approach to specifying a class in Dafny is to use two sets
of variables, some *ghost* variables that give a simple way to understand the
behavior of the class and some *physical* (i.e., non-ghost) variables that form an
efficient implementation of the class. The relation between the two sets of
variables is described in a *class invariant*, which in Dafny is typically
coded into a boolean function (a *predicate*) called `Valid` that gets used in
method specifications. The program updates both sets of variables, maintaining
the validity condition, but the compiler emits only the physical variables into
the executable code. The Dafny language embraces the idea of ghost constructs,
not just for variables but also for other declarations and statements.

We will now see how to specify classes as abstract data types to separate
observable behavior from internal implementation. Moreover we will see the use
of dynamic frames in Dafny to specify and verify programs using objects.

### Example

```c++
class Queue<T> {
  // specification-only field representing abstract state
  ghost var Content : seq<T>;

  // concrete state
  var a: array<T>;
  var n: nat;

  ghost predicate Valid()
    reads this, a
  {
    // consistency conditions for concrete state
    a.Length > 0 &&
    n <= a.Length &&

    // consistency conditions for abstract state
    Content == a[0..n]
  }

  constructor (d: T)
    ensures Valid();
    ensures fresh(a);
    ensures Content == [];
  {
    a := new T[5](_ => d); // initializes every array element to d
    n := 0;

    Content := [];
  }

  method front() returns (e: T)
    requires Valid()
    requires Content != []
    ensures Valid()
    ensures Content == old(Content)
    ensures e == Content[0]
  {
    e := a[0];
  }

  method enqueue(e: T)
    modifies this, a
    requires Valid()
    ensures Valid()
    ensures old(n) < old(a.Length) ==> a == old(a)
    ensures old(n) == old(a.Length) ==> fresh(a)
    ensures Content == old(Content) + [e]
  {
    if (n == a.Length) {
      var b := new T[2 * a.Length](_ => e);
      forall i:int | 0 <= i < n {
        b[i] := a[i];
      }
      a := b;
    }
    a[n] := e;
    n := n + 1;

    Content := a[0..n];
  }

  method dequeue() returns (e: T)
    modifies this, a
    requires Valid()
    requires Content != []
    ensures Valid()
    ensures a == old(a)
    ensures [e] + Content == old(Content)
    ensures Content == old(Content[1..])
  {
    e := a[0];
    n := n - 1;
    forall i:int | 0 <= i < n {
      a[i] := a[i + 1];
    }

    Content := a[0..n];
  }
}

method Main ()
{
  var q := new Queue<int>(0);
  q.enqueue(1);
  q.enqueue(2);
  q.enqueue(3);
  q.enqueue(2);
  q.enqueue(4);

  var f := q.front();
  assert f == 1;
  print "Front of the list is ", f, "\n";
  f := q.dequeue();
  q.enqueue(5);
  f := q.front();
  assert f == 2;
  assert q.Content == [2,3,2,4,5];
  print "Now front of the list is ", f, "\n";
}
```
