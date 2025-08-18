---------------- Signatures ----------------

abstract sig Person {
  children: set Person,
  siblings: set Person
}

sig Man, Woman, Other extends Person {}

sig Married in Person {
  spouse: one Married
}

----------------------------------------

/* create an instance with at most three atoms in every top-level signature
 * (in this case just Person).  3 is the SCOPE. */
run {} for 3

/* Since by default the scope is 3, the above is equivalent to */
run {}