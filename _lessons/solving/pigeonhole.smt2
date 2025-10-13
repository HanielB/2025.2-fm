(set-logic QF_UF)
(set-option :produce-models true)

(declare-const p0 Bool)
(declare-const p1 Bool)
(declare-const p2 Bool)

(declare-const h0 Bool)
(declare-const h1 Bool)
(declare-const h2 Bool)

(declare-const n00 Bool)
(declare-const n01 Bool)
(declare-const n02 Bool)
(declare-const n10 Bool)
(declare-const n11 Bool)
(declare-const n12 Bool)
(declare-const n20 Bool)
(declare-const n21 Bool)
(declare-const n22 Bool)

; all p : Pigeon | one p.nest

; every pigeon is in a hole
(assert (and
          (or n00 n01 n02)

          (or n10 n11 n12)

          (or n20 n21 n22)))

; every pigeon in at most one hole
(assert (and
          (=> n00 (and (not n01) (not n02)))
          (=> n01 (and (not n00) (not n02)))
          (=> n02 (and (not n00) (not n01)))

          (=> n10 (and (not n11) (not n12)))
          (=> n11 (and (not n10) (not n12)))
          (=> n12 (and (not n10) (not n11)))

          (=> n20 (and (not n21) (not n22)))
          (=> n21 (and (not n20) (not n22)))
          (=> n22 (and (not n20) (not n21)))
          ))

;; all h : Hole | lone nest.h

; every hole has at most one pigeon
(assert (and
          (=> n00 (and (not n10) (not n20)))
          (=> n10 (and (not n00) (not n20)))
          (=> n20 (and (not n00) (not n10)))

          (=> n01 (and (not n11) (not n21)))
          (=> n11 (and (not n01) (not n21)))
          (=> n21 (and (not n01) (not n11)))

          (=> n02 (and (not n12) (not n22)))
          (=> n12 (and (not n02) (not n22)))
          (=> n22 (and (not n02) (not n12)))
          ))

; relation defines variables
(assert (=> n00 (and p0 h0)))
(assert (=> n01 (and p0 h1)))
(assert (=> n02 (and p0 h2)))

(assert (=> n10 (and p1 h0)))
(assert (=> n11 (and p1 h1)))
(assert (=> n12 (and p1 h2)))

(assert (=> n20 (and p2 h0)))
(assert (=> n21 (and p2 h1)))
(assert (=> n22 (and p2 h2)))

(check-sat)
(get-model)
