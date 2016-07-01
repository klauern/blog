+++
date = "2016-06-29T19:47:15-05:00"
slug = ""
tags = ["java", ""]
title = "Java 9 Modularity Features"
draft = false
+++

# Modularity in the JVM

I spent some time yesterday playing with the demos for the [Jigsaw Project][1],
and have something that I hope is usable for others:

* [github.com/klauern/modularity][2]

I haven't yet tried it on a Windows machine, but that's next on my list.  Each
of the examples in the Jigsaw Quick Start have an associated `run.sh` script
that will build the example.  I haven't done much documenting, but I do suggest
that if you're looking at these examples, you follow along with the
documentation.  It's pretty good, and does a much better job explaining the
steps than I can.

## JLinker sizes

The biggest reason I wanted to play with the Jigsaw features was to see how the
`jlink`er worked in terms of generating a self-contained JVM+runnable app.  I'm
pretty happy with it, and think that it's pretty slick, all things considered.
The downside is just the size.  I'm sure that it's a massive effort to slim down
the JVM to what is absolutely needed to run the code you have, but the smallest
example I could run on my MacBook Air was around ~33MB.  That's pretty good, but
still pretty large (at least compared to a similarly-written Golan project).
I think that things are probably trending even further downward, so I wouldn't
be surprised to see further interations of this slim it down further, or even
finding some excited hackers able to shrink it even further themselves.  At this
point, I'm really hopeful, and think that this is a pretty nice addition the
JVM.  More competition is always a good thing.




[1]: http://openjdk.java.net/projects/jigsaw/quick-start
[2]: https://github.com/klauern/modularity

