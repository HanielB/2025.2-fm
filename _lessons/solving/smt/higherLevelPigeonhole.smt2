(set-logic ALL)

(declare-sort AP 0)
(declare-sort AH 0)
(define-sort Pigeon () (Set AP))
(define-sort Hole () (Set AH))

(declare-const P Pigeon)
(declare-const H Hole)

(declare-fun Nest () (Relation AP AH))

(assert (<= (set.card P) 3))
(assert (<= (set.card H) 3))

; all p : Pigeon | one p.nest
(assert (forall ((p AP))
          (and
            (set.member p P)
            (= (set.card (rel.join (set.singleton (tuple p)) Nest)) 1))))

; all h : hole | lone nest.h
(assert (forall ((h AH))
          (and
            (set.member h H)
            (<= (set.card (rel.join Nest (set.singleton (tuple h)))) 1))))

(assert (> (set.card (rel.join (set.singleton (tuple (set.choose P))) Nest)) 1))
(assert (> (set.card (rel.join Nest (set.singleton (tuple (set.choose H))))) 1))

(check-sat)
