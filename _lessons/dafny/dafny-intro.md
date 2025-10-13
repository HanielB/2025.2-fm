---
layout: page
title: Dafny Introduction
---

# Dafny Introduction
{: .no_toc .mb-2 }

- TOC
{:toc}

## Readings

- Sections 1-5 of [[Koen12]({{ site.baseurl }}{% link _lessons/dafny/Koen12.pdf %})], an introduction to the Dafny language
  - Also available as an [online tutorial](http://rise4fun.com/Dafny/tutorial/guide)
- [Examples]({{ site.baseurl }}{% link _lessons/dafny/examples.tar.gz %})
- [Dafny Reference Manual](https://dafny-lang.github.io/dafny/DafnyRef/DafnyRef)

### Recommended readings

- [[Wing95]({{ site.baseurl }}{% link _lessons/dafny/Wing95.pdf %})], which provides several hints to specifiers.

## Topics

- Specifying and verifying programs in high-level programming languages.
- Introduction to Dafny. Main features.
- Method contracts in Dafny.
- Specifying pre and post-conditions.
- Compositional verification of methods through the use of contracts.

## Example: Absolute value

``` c++
method abs (x : int) returns (y : int)
    ensures 0 <= x ==> x == y
    ensures 0 > x ==> -x == y
{
    if x < 0
    {
        return -x;
    }
    else
    {
        return x;
    }
}

method Main()
{
    var x := -3;
    var n := abs(x);
    assert n >= 0;
    print "Absolute value of ", x, ": ", n, "\n";
}
```
