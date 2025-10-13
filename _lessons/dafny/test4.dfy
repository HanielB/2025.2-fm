class Grinder {
  var HasBeans: bool

  predicate Valid()
    reads this { true }

  constructor ()
    ensures Valid() {}
  
  method AddBeans()
    requires Valid()
    modifies this
    ensures Valid() && HasBeans 
    {
        HasBeans := true;
    }

  method Grind()
    requires Valid() && HasBeans
    modifies this
    ensures Valid() { HasBeans := false; }
}

class WaterTank {
  var Level: nat

  predicate Valid()
    reads this { true }

  constructor ()
    ensures Valid() {}

  method Fill()
    requires Valid()
    modifies this
    ensures Valid() && Level == 10 { Level := 10; }

  method Use()
    requires Valid() && Level != 0
    modifies this
    ensures Valid() && Level == old(Level) - 1 { Level := Level - 1; }
}

class Cup {
  constructor () {}
}

class CoffeeMaker {

  var g : Grinder;
  var w : WaterTank;

  ghost var Repr: set<object>

  predicate Valid()
    reads this, Repr { this in Repr && g in Repr && w in Repr && g.Valid() && w.Valid() }
  
  constructor ()
    ensures Valid() { g := new Grinder(); w := new WaterTank(); Repr := {g, w, this}; }
  
  predicate method Ready()
    requires Valid()
    reads this, Repr { true }

  method Restock()
    requires Valid()
    modifies this
    ensures Valid() && Ready() {}

  method Dispense(double: bool) returns (c: Cup)
    requires Valid() && Ready()
    modifies this
    ensures Valid() { c := new Cup(); }
}
