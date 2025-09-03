sig Node {
  edges : set Node
}

fact "Connected graph relative to some node" {
  some n : Node | n.*edges = Node
}

fact "No self edges" {
  no iden & edges
}

sig Ball {
  var loc : one Node
}

pred move [b : Ball, n : Node] {
  n in b.loc.edges
  b.loc' = n

  -- If we wanted to force the ball to move back after a move we could
  -- add the restriction below.
  --
  -- b.loc'' = b.loc
}

pred moved [b : Ball] {
  some n : Node | move[b, n]
}

one sig Final in Node {}

pred reached [b : Ball, n : Node] {
  once b.loc = n
}

pred onlyFinalAfterAllOthers [b : Ball] {
  -- Guaranteeing that the final is only reached after all other nodes.
  --
  -- all n : Node - Final |
  --   b.loc = n releases b.loc != Final

  -- The restriction above can be written using the past operator "once"
     b.loc != Final until (all n : Node - Final | reached[b, n])
}

pred unchanged [b: Ball] {
  b.loc = b.loc'
}

-- Only one ball can move at a time
pred step {
  some b : Ball {
    moved[b]
    all b1 : Ball - b | unchanged[b1]
  }
}

pred spec {
  -- Balls never share locations
  always all disj b, b1 : Ball | b.loc != b1.loc
  always step
  -- Note that this restriction also forces all nodes to be visited
  all b : Ball {
  eventually b.loc = Final
         onlyFinalAfterAllOthers[b]
  }
}


pred noOverlap {
  spec => always {
    no disj b, b1 : Ball | b.loc = b1.loc
  }
}

--check { noOverlap }

run {spec and #Ball > 1} for 4
