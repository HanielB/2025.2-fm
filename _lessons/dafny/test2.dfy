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
