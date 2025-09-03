sig State {
    successor : set State
}

sig Initial extends State {}

pred atLeastOneInitial {
    some Initial
}

pred deterministic {
    one Initial
    all s: State | lone s.successor
}

pred nondeterministic {
    atLeastOneInitial
    not deterministic
}

pred unreachable {
    atLeastOneInitial
    some State - Initial.*successor
}

pred reachable {
    atLeastOneInitial
    not unreachable
}

pred connected {
    atLeastOneInitial
    all s: State | State in s.*successor
}

pred deadlock {
    atLeastOneInitial
    some s: Initial.*successor | no s.successor
}

pred livelock {
    atLeastOneInitial
    -- c is the cycle state, l is the livelocked state
    some c: State | some l: State | {
        -- c is reachable from an initial state without using l
        c in Initial.*(successor - (State -> l) - (l -> State))
        -- c is in a cycle not containing l
        c in c.^(successor - (State -> l) - (l -> State))
        -- l is reachable from the cycle
        l in c.^successor
    }
}

run {deadlock}
