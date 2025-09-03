#lang forge

option solver MiniSatProver
option logtranslation 1

sig Node {
    edges: set Node -> Int
}

pred path [n1: Node, n2: Node] {
    n2 in n1.^(edges.Int)
}

pred invariants {
  -- no self edges
  no iden & edges.Int

  -- symmetric
--  all n1, n2 : Node | n2 in n1.edges.Int implies n1 in n2.edges.Int

  -- no cycles
  no n : Node | n in n.^(edges.Int)

  -- connected
--  all n1 : Node | some n2 : Node | n1 != n2 and path[n2, n1]
}


-- pred somePath {some n1, n2 : Node | path[n1,n2] }

--inst myInst {
--  Node = A + B + C + D + E + F + G + H + I + J
--  edges = A->5->G
--}

run {invariants and some edges}
