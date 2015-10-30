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

It took probably a few days in my spare time to get a decent handle on the
language, so I started out coding in it almost right away.  I've written
a couple small applications, and I can't say I had too many nightmares using it.
That said, I am not necessarily impressed with developing in it.


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

This is part of the reason I liked Java so much at the beginning.  The sales
pitch of "write once, run anywhere" is really compelling, especially when you
realize the effort it takes to do a /proper/ job of making a cross-platform
application.  Just look at the discrepencies between any iOS application and an
equivalent Android one.  It's not simply **hard** to make it look good on
both--it's oftentimes at odds with how that system works.

In Go, I'm restricting myself to applications that run on the command-line, so
I'm not necessarily concerned or interested in GUI applications.

With the prevalence of new tools and applications out there written in Go, it's
pretty obvious that there are many people able to make successful use of their
time in developing an application in Go and releasing it to the masses.  I can
attest to the ease in the compile/retest cycle that seems to be pretty prevalent
in Go, and I attribute the ability to release an application is due in part to
the speed of compilation.

So, with all of these benefits, I think the platform and community are doing
a good job promoting the features of Go that make **Go the Platform** better than
**Go the Language**.  With that said...

# The Language is Not

I don't think it's necessary to rehash the arguments against the language.
Plenty of people more experienced and knowledgable with Go have already done
that.  Let me link to a few articles that I was somewhat intrigued by.  In most
of these, I found myself nodding in agreement on their results and experiences:

* [Why Go is a Poorly Designed Language (Reddit commentary)][poor]
* [Four Days of Go][4-days]
* [Why Go's design is a disservice to intelligent programmers][disservice]

I only link to the [Reddit commentary][poor] on the first article because I
think it's important to see how a community responds to criticism.  It's easy to dismiss
a poorly written article, but being able to introspect your own beliefs and ideals
is part of what makes a person, and further, a **community** vibrant and able to
keep up with change.  That said, I think this article was written by a non-native English
speaker, so I gave it more credence than most.  Humility is one of those
characteristics that will make most people better over time.  I can't say I see that
in the Go community.

One person in particular took the the time to respond
to his piece [with a lengthy comment][poor-comment], and others are taking it as
being a highlight of what a reasoned, responsible response should look like.
I don't think his response really helped their case that Go is anything but a
weak language with a great platform.  Consider some of the points being made:

> And yes, inserting numbers into a slice is a complicated action. This is because it ends up with a lot of copies. One of the things I like about Go is that it doesn't hide memory usage. Also, how often do you really need to insert values in the middle of a slice? Almost never. Usually it's the beginning or the end, and the beginning is pretty easy.

I can't say I use slices **at all**, and that's mostly because I abhor the
syntax and the random issues around it.

<br/>

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
to do X because X is (add argument for explicit vs. implicit here, or something
about compilers doing too much for you)"

It's pretty easy to dismiss a lot of language features that people like that
way, and I'm not necessarily one to argue for having more complexity, but I am
quite turned off by the [arguments for missing features][feature], wondering
when the designers of the language decided that most things beyond C-like
languages were not necessary:

> If it bothers you that Go is missing feature X, please forgive us and
> investigate the features that Go does have. You might find that they
> compensate in interesting ways for the lack of X.

Or that they completely punt on it, or expect the [community to pick up the
slack][vendoring].

The most damning critique of the language--and one that I think doesn't get
enough attention--is in [the third article][disservice].  Coming from playing
with Clojure, I find the premise that simplicity is paramount to be kind of
laughable.  When Rich Hickey explains [Simple Made Easy](http://www.infoq.com/presentations/Simple-Made-Easy),
he also made a point in explaining that simple solutions take an incredible
amount of thought and focus on limiting the amount of complexity you introduce
into your system.  I don't feel that Go has done anything in that regard.  It
eschews complexity, sure, but offers nothing in terms of simplifying the
problem.  You don't have to manage memory (Yay!) but you still have to manage
everything else:

* memory addresses (slices)
* stack vs. heap allocation, and the myriad ways one goes about doing it
* pedantry around how you use the language (no unused imports, variable
    shadowing, etc)
* type complexity (just because you can make everything an `interface{}`,
    doesn't make it /generic/)

and so on and so forth.

# So which language do you use?

When writing in Go, you realize that the issues it solves are so much less about
making it easy for the developer, and more about making it easy for the language
developers.  I'm not going to ignore it, but lacking generics should continue to
be lambasted as a cop-out for some perceived trade-off that the designers didn't
want to make.  They are more than happy to have you use `interface{}`
everywhere, and just ignore all the types at a whim.  All of this is marginally
better than C, though, so why not, right?

With all that said, do I still support the language?  Well, let me put it to you
another way.  As a developer, it's just as important to stay ahead of the curve
on programming trends, fads, and phases.  Just as software teams are "Java
shops", "Python shop", "Cool, Fad-like Language shop", you will still want to be
aware of and probably reasonably proficient in a popular language or two.  Go's
not terrible, but that's mostly due to the platform and community.

You do need to keep your eye out for shiny things.  People still code in C,
so it's had a surprisingly long lifetime.  Ruby seemed to be pretty awesome for
a while, but it's becoming obvious at this point that it's not the hot language
to learn.  Same for Python, same for Java.

Guess what?  Those languages didn't go away.  Go probably won't either.

The tl;dr of this is that while I think Go is a poor language, you're probably
going to be stuck using it in some form or fashion down the line, so don't
dismiss it out of hand.  The platform is pretty good, the tooling around it
seems to be getting better, and it's surprisingly effective for as simple as it
is.

Plenty of people use it effectively, and you can
probably slap something half-working together yourself in a short amount of
time.  Hell, even Rob Pike said that he designed the language for that purpose.
Don't sing this languages praises, however.  The designers of it don't appear to
be, but are sure as sh*t going to ride the wave with you.

[poor]: https://www.reddit.com/r/programming/comments/3qjo3y/why_go_is_a_poorly_designed_language_from_a/
[poor-comment]: https://www.reddit.com/r/golang/comments/3qjo2q/why_go_is_a_poorly_designed_language_from_a/cwfyp9c
[4-days]: http://www.evanmiller.org/four-days-of-go.html
[disservice]: http://nomad.so/2015/03/why-gos-design-is-a-disservice-to-intelligent-programmers/
[compat]: https://golang.org/doc/go1compat
[feature]: https://golang.org/doc/faq#Why_doesnt_Go_have_feature_X
[vendoring]: https://docs.google.com/document/d/1Bz5-UB7g2uPBdOx-rw5t9MxJwkfpx90cqG9AFL0JAYo/edit
