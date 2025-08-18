---------------- Signatures ----------------

abstract sig Person {
  children: set Person,
  siblings: set Person
}

sig Man, Woman, Other extends Person {}

sig Married in Person {
  spouse: one Married
}
---------------- Functions ----------------

-- Define the parents relation as an auxiliary one
fun parents [] : Person -> Person { ~children }

---------------- Facts ----------------

fact {

  -- No person can be their own ancestor
  no p: Person | p in p.^parents

  -- No person can have more than two parents
  all p: Person | #parents[p] <= 2

  -- A person P's siblings are those people with the same parents as P (excluding P)
  all p: Person | p.siblings = {q: Person | p.parents = q.parents} - p

  -- You can only be married to one person (which is not yourself)
  all p: Married | let s = p.spouse |
    s != p and no p1 : Married - p | s in p1.spouse

  -- A spouse can't be a sibling, ancestor, or descendant
  no p: Married | let s = p.spouse |
    s in p.siblings or s in p.^parents or s in p.^~parents

}

----------------------------------------

/* Create an instance with at most three atoms in every top-level signature
 * (in this case just Person)
 */
run {} for 3


/*
 * NOTE THAT AA ONLY EXECUTES THE FIRST run IN THE FILE. SO YOU HAVE TO COMMENT
 * PREVIOUS run commands or use the AA "Execute" pull-down menu
 */

-- Create an instance with at most two atoms in every top-level signature (scope 2),
-- and with a married man
run {some Man & Married} for 2

run {some spouse}

-- Create an instance with at most one atom in every top-level signature,
-- and with a married man (not satisfiable)
run {some Man & Married} for 1

-- Create an instance using defaul scopes (3).
run {some Man & Married}

run {#Woman >= 1 and #Man = 0}    -- include a woman but no men
run {some p: Person | some p.children}

---------------- Assertions ----------------

/*
 * NOTE THAT AA ONLY EXECUTES THE FIRST execute-command (run OR check) IN THE FILE.
 */

-- No person has a parents that's also a siblings.
assert parentsArentsiblings {
  all p: Person | no p.parents & p.siblings
}
check parentsArentsiblings for 10

-- Every person's siblings are his/her siblings' siblings.
assert siblingsSiblings {
  all p: Person | p.siblings = p.siblings.siblings
}
check siblingsSiblings

-- No person shares a common ancestor with his spouse (i.e., spouse isn't related by blood).
assert NoIncest {
  no p: Married |
    some p.^parents & p.spouse.^parents
}
check NoIncest
