class Queue<T> {
  
  ghost var Content : seq<T>;

  var a: array<T>;
  var n: nat;

  predicate Valid()
    reads this, a
  {
    // concrete state
    a.Length > 0 &&
    n <= a.Length &&

    // abstract state
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
    // ensures Content == old(Content)[1..old(n)]
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
  print "Now front of the list is ", f, "\n";  
}
