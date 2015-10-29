+++
date = "2015-10-29T08:26:23-05:00"
draft = true
title = "Thoughts On Go"

+++

# Learning Go

I started fumbling about wnating to write small applications that were portable
and compatible with many platforms.  I have a lot of experience working with
Java, and while I do well enough with that language, I find the need to package
an entire JVM runtime along with an [uberjar](http://stackoverflow.com/questions/11947037/what-is-an-uber-jar)
was somewhat unsettling.  In addition, the runtime speed for small client-side
applications was a bit of a turnoff to me.  It's great where it runs for a long
period of time, but it is lacking in providing that fast bootstrap times you
need to make a Unix-like CLI tool.



# The Platform is Great

One of the first things that I was drawn to was the ease in creating small,
self-contained little applications.  I first found things like
[Hugo](https://gohugo.io)'s static site generator to be pretty slick and
compelling (and if you haven't noticed, I've taken it up for my own blog and
homepage).  Then, other little tools started popping up, providing a lot of
really cool, cross-platform features.  Things like [the_platinum_searcher](https://github.com/monochromegane/the_platinum_searcher)
work on Windows, for pete's sake.  This is simply unheard of.  I am currently
stuck at work using Windows for my desktop, and with it, I have had to resort to
a lifetime of Googling "Alterative to X for Windows" kinds of searches for
everything I like in Linux.

With Go, I'm at least able to get these small applications and command-line
tools working on Windows with as much ease as I do on Linux/Mac.  A quick `go
get <package-name>` and I'm done.  Simple as that.

This is part of the reason I liked

# The Language is Not

I don't think it's necessary to rehash the arguments against the language.
Plenty of people more experienced and knowledgable with Go have already done
that.  I'll link to a few of the articles that I thought best represented my
opinions on it:

* [Why Go is a Poorly Designed Language (Reddit commentary)][poor]
* [Four Days of Go][4-days]
* [Why Go's design is a disservice to intelligent programmers][disservice]

I only link to the [Reddit commentary][poor] because I think it's important
to see how a community responds to criticism.  It's easy to dismiss
a poorly written article (I think this article was written by a non-native English
speaker, so I gave it more credence than most), but humility is one of those
characteristics that will make most people better over time.  I don't see that
in the Go community.

One person in particular took the the time to respond
to his piece [with a lengthy comment][poor-comment], and others are taking it as
being a highlight of the rebuttals provided.  I don't think his response really
helped their case that Go is anything but a weak language with a great platform.

This is made more apparent in the other two articles.  [Evan Miller's
piece][4-days] is probably the better of the many rantings about Go as
a language:

> Reading Go’s mailing list and documentation, I get a similar sense of
> refusal-to-engage — the authors are communicative, to be sure, but in a
> didactic way. They seem tired of hearing people’s ideas, as if they’ve already
> thought of everything, and the relative success of Go at Google and elsewhere
> has only led them to turn the volume knob down. Which is a shame, because
> they’ll probably miss out on some good ideas (including my highly compelling,
> backwards-incompatible, double-triple-colon-assignment proposal mentioned
> above).

I can't say I felt any different about it.  It's certainly one of those
languages where you often ask "I do X in Ruby/Python/Java/etc.  How do I do X in
Go?" Generally, the response is not, "think in Go", but "Go doesn't allow you to
to do X because X is (add argument for explicit vs. implicit here)"

It's pretty easy to dismiss a lot of language features that people like that
way, and I'm not necessarily one to argue for having more complexity, but I am
quite turned off by the [arguments for missing features][feature], wondering
when the designers of the language figured out that most things beyond C-like
languages were not necessary:

> If it bothers you that Go is missing feature X, please forgive us and
> investigate the features that Go does have. You might find that they
> compensate in interesting ways for the lack of X.

Or that they completely punt on it, or expect the [community to pick up the
slack][vendoring].

[poor]: https://www.reddit.com/r/programming/comments/3qjo3y/why_go_is_a_poorly_designed_language_from_a/
[poor-comment]: https://www.reddit.com/r/golang/comments/3qjo2q/why_go_is_a_poorly_designed_language_from_a/cwfyp9c
[4-days]: http://www.evanmiller.org/four-days-of-go.html
[disservice]: http://nomad.so/2015/03/why-gos-design-is-a-disservice-to-intelligent-programmers/
[compat]: https://golang.org/doc/go1compat
[feature]: https://golang.org/doc/faq#Why_doesnt_Go_have_feature_X
[vendoring]: https://docs.google.com/document/d/1Bz5-UB7g2uPBdOx-rw5t9MxJwkfpx90cqG9AFL0JAYo/edit
