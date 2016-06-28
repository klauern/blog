+++
date = "2016-03-26T13:01:51-05:00"
draft = false
title = "Java 9 and Jigsaw improvements with 'jlink'"

+++

It was [recently announced](https://twitter.com/mreinhold/status/713384458452226048)
that Java 9's latest builds now include the Project Jigsaw module system.  This
is pretty awesome stuff, to be honest.  One of the benefits that a lot of
systems-programming advocates claim is having a self-hosted runtime.  Being able
to do that is at least feasable in Jigsaw, using the built-in `jlink` tool.

I don't anticipate that it will completely replace the JDK for some
applicaitons, but it brings in a whole new world of options.  Some features I'm
pretty interested in include:

* improved dynamic language
* pre-compilation
* selective runtime includes
* faster bootstrap/startup times, and
* likely a whole new host of self-bootstrapping desktop/server applications that
don't need to worry nearly as much about having to roll in an entire runtime

There are a lot of good resources that I scoured trying to build this, so I'll
link to them here in case you'd like to learn for yourself or just have some fun
times digging around the docs:

- [Project Jigsaw: Modular run-time images](http://mreinhold.org/blog/jigsaw-modular-images)
- [Project Jigsaw: Module System Quick-Start Guide](http://openjdk.java.net/projects/jigsaw/quick-start)
- [JDK 9 Early Access Releases](https://jdk9.java.net/download/)
- [Keynote Session: Mark Reinhold (covers Jigsaw)](https://www.youtube.com/watch?v=l1s7R85GF1A)


## Getting Started Guide for Jigsaw

Now that build 111+ has support for Jigsaw, we should be able to follow their
[Module System Quick-Start Guide](http://openjdk.java.net/projects/jigsaw/quick-start)
and get things rolling.  I've started out building this Quick-Start guide
and have put it on GitHub: https://github.com/klauern/modularity . I can't
say that I have everything working, but I am pleased that things are working as
smoothly as they are, considering this is--at best--an alpha release.

## Future Posts

I don't have everything in a demo-able state, but I'm working on things and may
have more to update as that above repository is updated.  Stay tuned.


