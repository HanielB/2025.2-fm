// a[0] + a[1] + ... a[k-1]
function sumTo(a:array<int>, k:nat):int
{
  if (k == 0) then 0
  else a[k-1] + sumTo(a, k-1)
}

// compute a[0] + a[1] + ...
method sum(a:array<int>) returns (s:int)
{
  var i:nat := 0 ;
  s := 0 ;
  while (i < a.Length)
  {
    s := s + a[i] ;
    i := i + 1 ;
  }
}
