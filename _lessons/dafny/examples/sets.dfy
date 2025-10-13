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
