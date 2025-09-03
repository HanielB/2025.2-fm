#lang forge

sig State {
  successor : set State,
  prev : set State
}

one sig Initial extends State {}

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

run {linearOrder} for exactly 5 State
