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
    // invariant lo <= a.Length
    // invariant hi <= a.Length
    // invariant (lo+hi)/2 <= a.Length
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
