function fib(n: nat): nat
decreases n;
{
   if n == 0 then 0 else
   if n == 1 then 1 else
      fib(n - 1) + fib(n - 2)
}











































// efficient fib computation (the above is used only as an spec)

//      n = 0, 1, 2, 3, 4, 5, 6,  7,  8, ...
// fib(n) = 0, 1, 1, 2, 3, 5, 8, 13, 21, ...
method ComputeFib(n: nat) returns (f: nat)
{
  if (n ==0)
   { f := 0; }
  else
  {
    var i, f_1, f_2: int;

    i := 1;
    f := 1;    f_1 := 0;    f_2 := 0;

    while (i < n)
    decreases n - i
    {
      f_2 := f_1;
      f_1 := f;
      f  := f_1 + f_2;

      i := i + 1;
    }
  }
}
