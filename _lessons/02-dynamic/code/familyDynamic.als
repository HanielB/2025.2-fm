enum Status {Unborn, Alive, Dead}

abstract sig Entity {
  var children : set Person,
}

one sig God extends Entity {}

abstract sig Person extends Entity {
  var spouse : lone Person,
  var status : one Status
}

sig Man, Woman extends Person {}

enum Operator { Death, Birth, Marriage, Other }

one sig Track { var op : lone Operator }

-- Utils

pred isAlive [p : Person] {
  p.status = Alive
}

pred isDead [p : Person] {
  p.status = Dead
}

pred isUnborn [p: Person] {p.status = Unborn }

pred isMarried [p, q : Person ] {
  q in p.spouse and p in q.spouse
}

fun LivingPeople : Person { status.Alive }

pred noChildrenChanged [ Ps : set Person ] {
  all p : Ps + God | p.children' = p.children
}

pred noSpouseChanged [ Ps : set Person ] {
  all p : Ps | p.spouse' = p.spouse
}

pred noStatusChanged [ Ps : set Person ] {
  all p : Ps | p.status' = p.status
}

pred BloodRelatives [p, q : Person] {
  some a : Person | (p + q) in a.*children
}

fun fathers [p : Person] : Entity { p.~children & (Man + God) }

fun mothers [p : Person] : Entity { p.~children & (Woman + God) }

-- Operations

pred dies [p : Person] {
  -- pre-condition: be alive
  isAlive[p]
  -- post-condition
  after isDead[p]

  -- frame conditions (fully determining the next state)
  noStatusChanged[Person - p]
  noChildrenChanged[Person]
  noSpouseChanged[Person]

  Track.op' = Death
}

pred getMarried [p, q : Person] {
  -- pre-condition
  isAlive[p] and isAlive[q]
  no (p + q).spouse
  not BloodRelatives[p,q]

  -- post-condition
  after q in p.spouse
  after p in q.spouse

  -- frame conditions
  noStatusChanged[Person]
  noSpouseChanged[Person - (p + q)]
  noChildrenChanged[Person]

  Track.op' = Marriage
}

pred isBornFromParents [p: Person, m: Man, w: Woman] {
  -- pre-condition
  p.status = Unborn
  isAlive[w]
  once isAlive[m]

  -- post-condition
  after isAlive[p]
  --w.children' = w.children + p
  --m.children' = m.children + p
  children' = children + (m -> p) + (w -> p)

  -- frame conditions
  noSpouseChanged[Person]
  noStatusChanged[Person - p]
  noChildrenChanged[Person - (m + w)]

  Track.op' = Birth
}

pred other {
  noStatusChanged[Person]
  noChildrenChanged[Person]
  noSpouseChanged[Person]

  Track.op' = Other
}

--pred getMarried [p, q : Person]

-------------------------
-- Inital conditions
-------------------------

pred init {
  -- We now require that every initially living people descend
  -- directly from God.
  some children
  all p : LivingPeople | some p.~children and p.~children in God
  -- nobody is married, nobody is dead
  no spouse
  no status.Dead
  -- Some people must be unborn
  #Person > #LivingPeople
  -- There must be people from whom other people can be born. Together
  -- with the restrictions above any valid instance will require at
  -- least 4 entities: God, an alive man, an alive woman, an unborn
  -- person
  some Man & LivingPeople
  some Woman & LivingPeople
  -- Let's make it mandatory for everybody to die eventually. Note
  -- that adding this initial condition requires all instances to have
  -- at least 6 steps (inital one, plus one for somebody to be born,
  -- another for them to die, two more for the minimal original man
  -- and woman to die, and finally one for the "Other" operation)
  Track.op != Other until all p : Person | p.status = Dead
}

----------------------------
-- Transition Relation
----------------------------

pred transition {
  (some p : Person | dies[p])
  or (some p, q : Person | getMarried[p, q])
  or (some p : Person, m : Man, w : Woman |
           isBornFromParents[p,m,w])
  or other
}

-----------------------------
-- Transition system
---------------------------

pred System {
  init
  always transition
}

run {
  System

  -- Note that adding this requirement will force the valid traces to
  -- have at least 7 steps rather than 6.
  -- eventually ( some p, q : Person | getMarried[p, q] )
 } for 4 but 6 steps

-- Nobody can be their own ancestor
assert nobodyCanBeTheirOwnAncestor {
  System => always (no p : Person | p in p.^children)
}
--check nobodyCanBeTheirOwnAncestor for 5 but 6 steps

-- Nobody can have more than one father or mother
assert a2 {
  System => always (all p : Person | lone fathers[p] and lone mothers[p])
}
--check a2 for 5 but 5 steps

-- Only living people can have children
assert a3 {
  System => always (all p : Person | some p.children => isAlive[p])
}
-- check a3 for 5 but 5 steps

-- Only people that are or have been alive can have children
assert a4 {
  System => always (all p : Person | some p.children => once isAlive[p])
}
--check a4 for 5 but 5 steps

assert yourInvariant {
  System => always (all p : Person, f : fathers[p], m : mothers[p] | isMarried[f,m] )
}
-- check yourInvariant for 5 but 5 steps

assert noResurrections {
  --System => always (all p : Person | once isDead[p] => isDead[p])
  System => always (all p : Person | isDead[p] => after isDead[p])
}
--check noResurrections for 5 but 5 steps

assert noImmortalityAndNoEncarnationWaitlist {
  System => always (all p : Person |
                      isAlive[p] => ((eventually isDead[p]) and (always !isUnborn[p] ))
                   )
}
--check noImmortalityAndNoEncarnationWaitlist for 5 but 5 steps

assert everyLivingPersonHasParents {
  System => always (all p : Person | isAlive[p] => some p.~children )
}
check everyLivingPersonHasParents for 5 but 7 steps
