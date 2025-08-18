---
layout: page
title: Alloy Introduction
---

# Alloy Introduction
{: .no_toc .mb-2 }

- TOC
{:toc}

## Readings

- [Class notes on set theory recap]({{ site.baseurl }}{% link _lessons/00-course-intro/sets-slides.pdf %})

- [Class notes on Alloy intro]({{ site.baseurl }}{% link _lessons/01-alloy-intro/01-alloy-intro.pdf %})
- [Class notes on Alloy constraints]({{ site.baseurl }}{% link _lessons/01-alloy-intro/02-alloy-intro-constraints.pdf %})

- [Old recorded lectures](https://youtube.com/playlist?list=PLeIbBi3CwMZxRUSUJbwyeerfCptuP19Br)
- Old class notes on an introduction to Alloy [[part 1]({{ site.baseurl }}{% link _lessons/01-alloy-intro/old-alloy-intro-1.pdf %}), [part 2]({{ site.baseurl }}{% link _lessons/01-alloy-intro/old-alloy-intro-2.pdf %})]
  - In particular try to do the exercises in these lecture notes

### Recommended readings

- Alloy [FAQ](http://alloytools.org/faq/faq.html)
- Lecture notes on first-order logic
  - [by Cesare Tinelli]({{ site.baseurl }}{% link _lessons/01-alloy-intro/fol-cesare.pdf %})
  - [by Mario S. Alvim]({{ site.baseurl }}{% link _lessons/01-alloy-intro/fol-mario.pdf %})
- Alloy Analyzer tutorial, notes by Greg Dennis and Rob Seater [[part 1]({{ site.baseurl }}{% link _lessons/01-alloy-intro/alloy-tutorial-1.pdf %}), [part 2]({{ site.baseurl }}{% link _lessons/01-alloy-intro/alloy-tutorial-2.pdf %})]
- [A hands-on introduction to Alloy](https://blackmesatech.com/2013/07/alloy/), by Michael Sperberg-McQueen

- Automatic generation of security exploits with Alloy, by Caroline Trippel et al. [[paper 1]({{ site.baseurl }}{% link _lessons/01-alloy-intro/trippel2018-checkmate.pdf %}), [paper 2]({{ site.baseurl }}{% link _lessons/01-alloy-intro/trippel2018.pdf %})]

- More generally, how Amazon Web Services has been leveraging formal methods:
  - [Provable Security: Security Assurance, Backed by Mathematical Proof](https://aws.amazon.com/security/provable-security/)
  - [CAV 2022 keynote - A Billion SMT Queries A Day](https://www.youtube.com/watch?v=zT8E4kMY4cM&ab_channel=NehaRungta)

## Topics covered

- Modeling general software systems.
  - Introduction to the Alloy modeling language.
  - Alloy's foundadions.
  - Signatures, fields, and multiplicity constrainst.

- Modeling simple domains in Alloy.
  - Generating and analyzing model instances.

- Relations and operations on them.
  - Formulas, Boolean operators and quantifiers.
  - Expressing constraints on relations using Alloy formulas.

- Functions and predicates.

## Resources

- A simple family model for the Alloy Analyzer: [family-1.als]({{ site.baseurl }}{% link _lessons/01-alloy-intro/code/family-1.als %})
- A simple family model *with facts, different run configurations and assertions* for the Alloy Analyzer: [family-2.als]({{ site.baseurl }}{% link _lessons/01-alloy-intro/code/family-2.als %})

## Transitive closure

A relation is *transitive* when it satisfies the transitivity property, which can be stated as:
```
∀xyz . ((x, y) ∈ R ∧ (y, z) ∈ R) → (x, z) ∈ R
```
for any relation `R : A × A`, with `x,y,z ∈ A`. The *transitive closure* of a relation `R` is the smallest transitive relation containing it. It can be defined as
```
R⁺ = R ∪ (R ; R) ∪ ((R ; R) ; R) ∪ ...
```
in which `;` is relation composition.

Consider a relation `S = {(a, b), (b, c)}`. This relation is *not*
transitive. Its transitive closure can be obtained by creating a new relation
`T` which contains `S`, is transitive, and is the smallest relation with these
two properties. This is the case if `T = {(a, b), (b, c), (a, c)}`, i.e., `T = S
∪ (S ; S)`.

Note that `(S ; S) ; S` is the empty set. So no new pairs can be obtained via
composition.
