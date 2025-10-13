method Find(a: array?<int>, key: int) returns (index: int)
requires a != null;
ensures 0 <= index ==> index < a.Length && a[index] == key
ensures index < 0 ==> forall k :: 0 <= k < a.Length ==> a[k] != key
{
   index := 0;
   while (index < a.Length)
   decreases a.Length - index
   invariant 0 <= index <= a.Length
   invariant forall k :: 0 <= k < index ==> a[k] != key
   {
      if (a[index] == key) { return; }
      index := index + 1;
   }
   index := -1;
}

method Main()
{
   var a := new int[3];
   a[0], a[1], a[2] := 0, 3, -1;
   var res := Find(a, 3);
   print "Index with value 3 is ", res, "\n";
}
