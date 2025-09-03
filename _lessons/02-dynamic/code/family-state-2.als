---------------- Signatures ----------------

sig State {
    successor : set State,
    prev : set State
}

one sig Initial extends State {}

abstract sig Person {
  -- primitive relations
  children: Person set -> State,
  spouse: Person lone -> State,
  alive: set State,
}

sig Man, Woman extends Person {}

abstract sig Operator {}
one sig Dies, IsBornFromParents, GetMarried extends Operator {}

one sig Track {
  op: Operator lone -> State
}

------------------ Linear order on State ------------

fact linearOrder {
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

fun last: one State { State - (successor.State) }

-- These derived relations are defined here as macros, to keep the model lean

fun parents [t: State]: Person -> Person {
  ~(children.t)
}

fun siblings [p: Person, t: State]: Person {
  { q : Person - p | some q.(parents[t]) and p.(parents[t]) = q.(parents[t]) }
}

-- Two persons are blood relatives at time t iff
-- they have a common ancestor at time t
-- (alternative definition in based directly on children)
pred BloodRelatives [p: Person, q: Person, t: State, ]  {
  some a: Person | p+q in a.*(children.t)
}


------------------------------
-- Frame condition predicates
------------------------------

pred noChildrenChangeExcept [ps: set Person, t,t': State, ] {
    all p: Person - ps | p.children.t' = p.children.t
}

pred noSpouseChangeExcept [ps: set Person, t,t': State] {
    all p: Person - ps | p.spouse.t' = p.spouse.t
}

pred noAliveChange [t, t': State] {
    alive.t' = alive.t
}


-------------
-- Operators
-------------

pred getMarried [p,q: Person, t,t': State] {
  -- Pre-condition
     -- p and q must be alive before marriage (at time t)
     p+q in alive.t
     -- they must not be married
     no (p+q).spouse.t
     -- they must not be blood relatives
     not BloodRelatives [p, q, t]
  -- Post-condition
     -- After marriage they are each other's spouses
     q in p.spouse.t'
     p in q.spouse.t'
  -- Frame condition
     noChildrenChangeExcept [none, t, t']
     noSpouseChangeExcept [p+q, t, t']
     noAliveChange [t, t']

     Track.op.t' = GetMarried
}

pred isBornFromParents [p: Person, m: Man, w: Woman, t,t': State] {
  -- Pre-condition
     m+w in alive.t
     p !in alive.t
  -- Post-condition and frame condition
     alive.t' = alive.t + p
     m.children.t' = m.children.t + p
     w.children.t' = w.children.t + p
  -- Frame condition
     noChildrenChangeExcept [m+w, t, t']
     noSpouseChangeExcept [none, t, t']

     Track.op.t' = IsBornFromParents
}

pred dies [p: Person, t,t': State] {
  -- Pre-condition
     p in alive.t
  -- Post-condition
     no p.spouse.t'

  -- Post-condition and frame condition
     alive.t' = alive.t - p
     all s: p.spouse.t | s.spouse.t' = s.spouse.t - p

  -- Frame condition
     noChildrenChangeExcept [none, t, t']
     noSpouseChangeExcept [p + p.spouse.t, t, t']

     Track.op.t' = Dies
}


---------------------------
-- Inital state conditions
---------------------------
pred init [t: State] {
  no children.t
  no spouse.t
  #alive.t > 2
  #Person > #alive.t
}

-----------------------
-- Transition relation
-----------------------
pred trans [t,t': State]  {
  (some p,q: Person | getMarried [p, q, t, t'])
  or
  (some p: Person, m: Man, w: Woman | isBornFromParents [p, m, w, t, t'])
  or
  (some p :Person | dies [p, t, t'])
}

-------------------
-- System predicate
-------------------
-- Denotes all possible executions of the system from a state
-- that satisfies the init condition
pred System {
  init [Initial]
  all t: State - last | trans [t, t.successor]
}

---------------------------
-- Sanity-check predicates
---------------------------

pred sc1 [] {
  -- having children is possible
  some t: State | some children.t
}

pred sc2 [] {
  -- births can happen
  some t: State | some p: Person | p in alive.t and p !in alive.(t.successor)
}

pred sc3 [] {
  -- people can get married
  some t: State | some p: Person | some q: Person - p | q in p.spouse.t
}


run {
 #Man > 1
 #Woman > 1
 System
 -- uncomment any of sanity-check predicates to check it
  -- sc1
  -- sc2
  -- sc3
}  for 10 but 8 State



-- Only living people can have children
assert a1 {
  System => all t: State | all p: Person |
             (some p.children.t) => p in alive.t
}

check a1 for 10 but 6 State

-- Only people that are or have been alive can have children
assert a2 {
  System => all t: State | all p: Person |
             (some p.children.t) => some t': t+(t.^prev) | p in alive.t'
}

check a2 for 10 but 6 State

-- Only living people can be married
assert a3 {
  System => all t: State | all p: Person |
             (some p.spouse.t) => p in alive.t
}
check a3 for 10 but 6 State

-- No person can be their own ancestor
assert a4 {
  System => all t: State | no p: Person | p in p.^(parents[t])
}
check a4 for 10 but 6 State

-- No person can have more than one father or mother
assert a5 {
  System => all t: State | all p: Person |
             lone (p.(parents[t]) & Man) and
             lone (p.(parents[t]) & Woman)
}
check a5 for 10 but 6 State

-- Each married woman has a husband
assert a6 {
  System => all t: State | all w: Woman | some (w.spouse.t & Man)
}
check a6 for 10 but 6 State

-- A spouse can't be a sibling
assert a7 {
  System => all t: State | all p: Person | all q: p.spouse.t |
             q !in siblings[p, t]
}
check a7 for 10 but 6 State

 -- the spouse relation is symmetric
assert a8 {
  System => all t: State | spouse.t = ~(spouse.t)
}

check a8 for 10 but 4 State
