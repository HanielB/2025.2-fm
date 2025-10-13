// Returns maximal element of array

method max(a : array<int>) returns (key : int)
  requires a.Length > 0;
  ensures exists  k :: 0 <= k < a.Length && a[k] == key;
  ensures forall k :: 0 <= k < a.Length ==> a[k] <= key;
{
  var i : nat := 0;
  key := a[0];
  while (i < a.Length)
    decreases a.Length - i;
    invariant 0 <= i <= a.Length;
    // for the maximum post condition
    invariant forall k :: 0 <= k < i ==> a[k] <= key;
    // for the witness post condition
    invariant exists k : 0 <= k < a.Length && a[k] == key;
  {
    if (key < a[i])
    {
      key := a [i];
    }
    i := i + 1;
  }
}
