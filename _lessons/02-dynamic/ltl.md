---
layout: page
title: Linear Temporal Logic
---

# Dynamic systems and temporal logic
{: .no_toc .mb-2 }

- TOC
{:toc}

## Readings

- [Code for the ball example]({{ site.baseurl }}{% link _lessons/02-dynamic/code/ballDynamic.als %})
- [Class notes on dynamic models]({{ site.baseurl }}{% link _lessons/02-dynamic/cesare-dynamic-models.pdf %}), by C. Tinelli
- [Class notes on a dynamic model for a hotel lock system]({{ site.baseurl }}{% link _lessons/02-dynamic/cesare-hotel-model.pdf %}), by C. Tinelli
- [Class notes on a dynamic model for a rover]({{ site.baseurl }}{% link _lessons/02-dynamic/cesare-rover-model.pdf %}), by C. Tinelli


### Recommended readings

- Alloy [Reference manual](https://alloytools.org/spec.html)
- [Alloy 6: It's about time](https://www.hillelwayne.com/post/alloy6/) blog post by Hillel Wayne.
  - The ball example is taken from this post.
- Notes notes on Alloy 6 (aka, Electrum Alloy) by A. Cunha and N. Macedo on
  - [Electrum overview](http://wiki.di.uminho.pt/twiki/pub/Education/MFES1920/EM/trash.pdf)
  - [First Order Logic](http://wiki.di.uminho.pt/twiki/pub/Education/MFES1920/EM/fol.pdf)
  - [Relational Logic](http://wiki.di.uminho.pt/twiki/pub/Education/MFES1920/EM/rl.pdf)
  - [Alloy's type system](http://wiki.di.uminho.pt/twiki/pub/Education/MFES1920/EM/types.pdf)
  - [Relational model finding](http://wiki.di.uminho.pt/twiki/pub/Education/MFES1920/EM/foltl.pdf)

## Family model as a transition system

We convert the static family model we studied before to a transition system via
the use of the temporal operators. The code we built in class is available [here]({{ site.baseurl }}{% link _lessons/02-dynamic/code/familyDynamic.als %})

## LTL Tutor

A free online tutor for Linear Temporal Logic.
- [Online tutor](https://www.ltl-tutor.xyz/)
- [Blog post explaining it](https://blog.brownplt.org/2024/08/08/ltltutor.html)
- [Research paper describing it](https://cs.brown.edu/~sk/Publications/Papers/Published/pgnk-ltl-tutor/paper.pdf)
