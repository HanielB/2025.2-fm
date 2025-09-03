
sig State {
    successor : set State,
    prev : set State
}

one sig Initial extends State {}

abstract sig Person {
  spouse: Person lone -> State,
}

sig Man, Woman extends Person {}


------ guaranteeing that successor is a total order on states

pred linearOrder {
    -- no cycles, each state has at most one successor
    all s: State {
        lone s.successor
        s not in s.^successor
    }
    -- there is one final state
    one s: State | no s.successor
    -- there is one initial state, which is Initial
    one s: State | no successor.s
    no s : State - Initial | some s.successor & Initial
    -- no self loops
    no iden & successor
    -- prev is symmetric of successor
    prev = ~successor
}

------ Getting married now is with the next one

pred getMarried [p,q: Person, s,s': State] {
  -- Pre-condition : they must not be married
  no (p+q).spouse.s

  -- Post-condition : After marriage they are each other's spouses
  q in p.spouse.s'
  p in q.spouse.s'
}

run {linearOrder and some p,q : Person | some s : State | getMarried[p,q,s,s.successor] } for exactly 2 Person, exactyly 4 State