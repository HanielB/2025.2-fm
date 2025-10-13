---
layout: page
title: Constraint solving for Alloy
---

# Constraint solving for Alloy
{: .no_toc .mb-2 }

- TOC
{:toc}

## Readings
{: .no_toc .mb-2 }

- Writings on the board:
  - [Board for the overview of leveraging SAT solvers]({{ site.baseurl }}{% link _lessons/solving/alloy2sat.png %})
  - [Board for SAT solving]({{ site.baseurl }}{% link _lessons/solving/satSolving.png %})
  - [Board for Alloy encoding into SAT]({{ site.baseurl }}{% link _lessons/solving/alloy2sat-encoding.png %})

- State-of-the-art SAT solving:
  - [Slides by João Marques-Silva and Mikoláš Janota]({{ site.baseurl }}{% link _lessons/solving/Marques-Silva-sat-summerschool2013.pdf %})
  - [Slides by Marijn Heule]({{ site.baseurl }}{% link _lessons/solving/SCSC-Heule1.pdf %})

- [Automating Alloy solving]({{ site.baseurl }}{% link _lessons/solving/Jackson2000.pdf %}), paper by Daniel Jackson.

### Recommended readings
{: .no_toc .mb-2 }

- [Kodkod: A Relational Model Finder]({{ site.baseurl }}{% link _lessons/solving/Torlak2007.pdf %})
- [Alloy*: A General-Purpose Higher-Order Relational Constraint Solver]({{ site.baseurl }}{% link _lessons/solving/Milisevic2015.pdf %})

## From Alloy to SAT

Determining if an Alloy specification has an instance (within the given bounds) that respects the established restrictions is encoded as a SAT problem (see below). If this problem is *satisfiable*, the corresponding solution is decoded into an Alloy instance and exhibited.

Similarly, checking whether an assertion is valid (i.e., it is always true within the given bounds) is also encoded *negatively* as a SAT problem. If this SAT problem is *unsatisfiable*, then the assertion is valid (within the bounds), otherwise the problem is satisfiable and the corresponding is decoded into an Alloy counterexample.

## The SAT problem

The satisfiability problem consists of determining if there exists a valuation
to the variables of a propositional formula (i.e., a formula in propositional
logic).

## Resolução de problemas via SAT

Podemos resolver problemas SAT automaticamente usando ferramentas de *automatização de raciocínio*. Um exemplo é o [cvc5](https://cvc5.github.io/), um solucionador SMT (de *satisfatibilidade módulo teorias*; falaremos um pouco mais sobre SMT em futuras aulas).

Como vimos em aula, podemos usar a [API](https://pt.wikipedia.org/wiki/Interface_de_programa%C3%A7%C3%A3o_de_aplica%C3%A7%C3%B5es) do cvc5 em Python para escrever programas nessa linguagem que resolvem problemas que podemos representar via SAT.

Para instalar o `cvc5` e usar sua API em Python, basta instalar o cvc5 com, por exemplo:

``` shell
pip install cvc5
```

Mais instruções sobre instalação estão disponíveis [aqui](https://cvc5.github.io/docs/cvc5-1.0.7/api/python/python.html). E a documentação das operações disponíveis na API estão [aqui](https://cvc5.github.io/docs/cvc5-1.0.7/api/python/pythonic/pythonic.html).

### Determinando a satisfatibilidade de uma fórmula proposicional

O programa abaixo, ao ser executado, apresnta todas as soluções para a fórmula 

```
(p v q v r) ∧ (¬p v ¬q v ¬r)
```

```python
from cvc5.pythonic import *

if __name__ == '__main__':
    p, q, r = Bools("p q r")
    s = Solver()

    # p v q v r
    s.add(Or(p, q, r))
    # ¬p v ¬q v ¬r
    s.add(Or(Not(p), Not(q), Not(r)))

    count = 0
    while (s.check() == sat):
        m = s.model()
        print("Solution {}".format(count))
        print("p: ", m[p])
        print("q: ", m[q])
        print("r: ", m[r])
        s.add(Or(p != m[p], q != m[q], r != m[r]))
        print("============")
        count += 1
```

### Resolvendo o problema das n-rainhas

Segundo a codificação dada [neste conjunto de slides]({{ site.baseurl }}{% link _lessons/solving/ilc-sat.pdf %}), podemos escrever o programa abaixo que dá todas as soluções para o problema das `n` rainhas, para um dado `n`.

```python
from cvc5.pythonic import *

# Definindo o número de rainhas
n = 8

if __name__ == '__main__':
    # Criamos n+1 posições para que possamos contar de 1 até n (em vez de 0 
    # até n-1, como seria o padrão)
    board = [[None for i in range(n+1)] for i in range(n+1)]
    # Criamos uma variável para cada posição no tabuleiro
    for i in range(1, n+1):
        for j in range(1, n+1):
            board[i][j] = Bool("p{}{}".format(i, j))

    s = Solver()
    # Q1: há pelo menos uma rainha por linha
    for i in range(1, n+1):
        row = []
        for j in range(1, n+1):
            row += [board[i][j]]
        s.add(Or(row))

    # Q2: há no máximo uma rainha por linha
    for i in range(1, n+1):
        for j in range(1, n):
            for k in range(j+1, n+1):
                s.add(Implies(board[i][j], Not(board[i][k])))

    # Q3: há no máximo uma rainha por coluna
    for j in range(1, n+1):
        for i in range(1, n):
            for k in range(i+1, n+1):
                s.add(Implies(board[i][j], Not(board[k][j])))

    # Q4: não há rainhas na mesma diagonal (parte 1)
    for i in range(2, n+1):
        for j in range(1, n):
            for k in range(1, min(i-1, n-j) + 1):
                s.add(Implies(board[i][j], Not(board[i-k][k+j])))

    # Q5: não há rainhas na mesma diagonal (parte 2)
    for i in range(1, n):
        for j in range(1, n):
            for k in range(1, min(n-i, n-j) + 1):
                s.add(Implies(board[i][j], Not(board[i+k][j+k])))

    count = 0
    while (s.check() == sat):
        m = s.model()
        values = []
        count += 1
        print("Solution {}\n----------".format(count))
        for i in range(1, n+1):
            string = ""
            for j in range(1, n+1):
                string += "{}{}".format("Q" if m[board[i][j]] else "_", ", " if j < n else "")
                values += [board[i][j] != m[board[i][j]]]
            print(string)
        print("===============================================")
        # block current solution
        s.add(Or(values))
```

## Encoding Sudoku as SAT

- [Sudoku as a SAT problem]({{ site.baseurl }}{% link _lessons/solving/sudoku_sat.pdf %})

- SAT problems can be solved with SAT solvers

- [Solving via Minisat](https://github.com/daviddimic/mini-SAT-sudoku-solver):
  This requires having `Minisat` installed. This python program takes a file containing a sudoku problem like

```
0 0 5 0 0 0 8 7 0
3 0 6 0 7 8 4 0 0
8 7 0 0 0 0 0 9 6
0 1 0 3 0 7 0 0 0
0 2 0 0 0 0 0 3 0
0 0 0 8 0 6 0 1 0
5 3 0 0 0 0 0 4 9
0 0 9 4 5 0 1 0 7
0 8 7 0 0 0 3 0 0
```

and producing another file containing the problem solved (where each 0 will be replaced by a number between 1 and 9 following the sudoku rules).

## SAT solving

SAT solvers implement the *conflict-driven clause learning* (CDCL) calculus.

## Translating Alloy goals into SAT

Let's consider a specification of a pigeonhole problem in Alloy. First we model that we may have pigeons, holes and pigeons may be nested in holes.

```alloy
sig Hole {}
sig Pigeon {nest : set Hole}
```

The property to be respected is that no pigeon is in more than one hole and every pigeon is in a hole. The above formulation is not enough to guarantee this. We can check it:


``` alloy
check {no h : Hole | #nest.h > 1 and no p : Pigeon | no p.nest }
```

This check will produce counterexamples. To avoid this we can force the restrictions that every pigeon is exactly one hole and that all holes have at most one pigeon:

```alloy
fact {
  all p : Pigeon | one p.nest
  all h : Hole | lone nest.h
}
```

Now every execution of a `run` command will yield an instance respecting the
pigeonhole principle. All is well, but *how* are such instances found? We know
that Alloy solving is done via SAT solving. But *how*? What is the propositional
formula that is fed into a SAT solver and whose satisfying assignment can be
mapped back into the Alloy instance being searched?




Now consider adding this predicate

```
pred hasSubNest {
  some subNest : Pigeon -> Hole | some subNest and #subNest < #nest and subNest in nest
}

run {hasSubNest} for exactly 3 Hole, exactly 3 Pigeon
```
