+++
date = "2016-07-19T16:25:21-05:00"
slug = ""
tags = ["", ""]
title = "Adding Formatting and Parallelism"
+++

# Improved Formatting in Trackello

I've been using my [trackello](https://github.com/klauern/trackello) app for
a few weeks and I do like the way I can keep track of my work.  However, some of
the things I was curious about were more specific to the card.  If you've used
this application, you may have noticed that activity is marked by repeated
entries of the same card.  This is just messy, and not something that I thought
would be usable if you had a particularly busy week.

To remedy this, I set about fixing it up with some additional fields:

![trackello](/img/trackello_colorized.png "Trackello with statistics")

Specifically, I added a placeholder for some general-purpose statistics:

![statistics](/img/trackello_statistics.png "Statistics in Trackello")

I don't have a very solid setup for how I want to layer this out at this time,
but it provides a lot more information for a particular card than before.  Now,
with a quick glance you can get a rough estimate on how much you've been
fiddling with a particular card.

# Parallelism

Once I added this in, I had to make some changes in terms of collecting the
actions for a board and being able to parse it out.  For whatever reason, I was
initially going about it in a very naive way, requesting a card or list for
**every** action that I had.  This resulted in a couple issues off the bat:

1. Many actions result in many HTTP requests
2. Duplicating the same `HTTP GET` for the same card multiple times was
   redundant.
3. Each call was done in succession of the previous one, in order.

I first attempted to at least simplify how many calls I was making, ensuring
I was only making calls when I needed new information (such as a new Card that
I had not yet encountered).  However, that didn't really speed things up, and
I found that it would wait 20-30 seconds just to return a Board's Actions.

Next, I pursued one of the things that Go is known for--easy parallelism with
Goroutines.  I am not an expert in this stuff, but managed to wing it somehow.

Using parallelism in Go is a lot easier than I intially thought it would be.
That isn't to say it's not fraught with concurrency issues, but it seems that
the scope of the issues is contained well enough that you can work out a lot of
the things that I used to get hung up on for DAYS with Java Threads and
concurrency there.

I don't have a quick comparison, but the performance improvement is noticable
off the bat, so I'm pretty confident in sticking with this.

# Future work

I want to use this framework and library as the basis for something a little
more interesting.  I know that Trello is great for building a lot of different
kinds of sites, and one thing that I was really interested in is how [The
Changelog](https://changelog.com) uses Trello to build their weekly email.
I figure I can probably build something similar in Go and share it with the
world.  I don't know if there's another project out there for it, but I haven't
yet been able to find one, so there's an opening.
