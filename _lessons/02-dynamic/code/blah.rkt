#lang forge

option solver MiniSatProver
option logtranslation 1

sig Node {
    edges: set Node,
    weighted: set Int -> Node
    }

pred invariants {
  edges = (weighted.Node.Int)->(Int.(Node.weighted))

  all n1 : Node | all n2 : Node | lone n1.weighted.n2
}

run {{all n : Node | lone n.edges } and some edges} for exactly 2 Node
