-- The pigeonhole problem

sig Hole {}

sig Pigeon {
  nest : set Hole
}

fact {
  all p : Pigeon | one p.nest
  all h : Hole | lone nest.h
}

run {}

check { (no h : Hole | #nest.h > 1) and (no p : Pigeon | no p.nest)} for 5

pred hasSubNest {
  some subNest : Pigeon -> Hole | some subNest and #subNest < #nest and subNest in nest
}

run {hasSubNest} for exactly 3 Hole, exactly 3 Pigeon
