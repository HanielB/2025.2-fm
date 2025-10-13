class Counter {
  // The "abstract" state which is visible to clients
  ghost var val: int ;

  // The actual implementation (also called the "concrete state")
  // This is meant to be hidden from the client
  var inc: int ;
  var dec: int ;

  // The object invariant -- indicates how the abstract and
  // concrete states are related
  predicate Valid()
    reads this
  {
    val == inc - dec
  }

  // The constructor
  constructor()
    ensures val == 0
    ensures Valid()
  {
    inc := 0 ; dec := 0 ;

    // ghost code (to establish the postcondition)
    val := 0;
  }

  // Method implementations.  Note that the specifications only
  // mention the abstract state and not the concrete state.  This
  // allows us to later change the implementation without breaking
  // any client code.

  method Inc()
    modifies this
    requires Valid() // val = inc - dec
    ensures Valid()
    ensures val == old(val) + 1
  {
    inc := inc + 1 ;

    // ghost code
    val := inc - dec;
  }

  method Dec()
    modifies this
    requires Valid()
    ensures Valid()
    ensures val == old(val) - 1
  {
    dec := dec + 1 ;

    val := inc - dec;
}

  method Clear()
    modifies this;
    requires Valid();
    ensures Valid();
    ensures val == 0;
  {
    inc := 0 ;
    dec := 0 ;

    // ghost code
    val := inc - dec;
}

  method Get() returns (n: int)
    requires Valid()
    ensures Valid()
    ensures n == val
  {
    return inc - dec;
  }

  method Set(n: int)
    modifies this
    requires Valid()
    ensures Valid()
    ensures n == val
  {
    if n < 0 {
      inc := 0;
      dec := -n;
    }
    else {
      inc := n;
      dec := 0;
    }

    // ghost code
    val := inc - dec;
  }
}
