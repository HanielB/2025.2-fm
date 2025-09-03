
sig State {
    successor : set State
}

abstract sig Person {
  spouse: Person lone -> State,
}

sig Man, Woman extends Person {}

pred getMarried [p,q: Person, s1,s2: State] {
  -- Pre-condition
   -- they must not be married
  no (p+q).spouse.s1
  -- Post-condition
   -- After marriage they are each other's spouses
  q in p.spouse.s2
  p in q.spouse.s2
}

run {some p,q : Person | some s1,s2 : State | getMarried[p,q,s1,s2] }

-- run {some p,q : Person | some s1,s2 : State | getMarried[p,q,s1,s2] and no s : State | s in s.successor} for exactly 2 Person, 2 State