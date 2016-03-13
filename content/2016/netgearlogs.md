+++
date = "2016-03-13T11:26:34-05:00"
draft = false
title = "Playing with NetGear Router Logs"

+++

I was recently toying around on my router and noticed that I can send myself
a set of logs related to activity going on.  Considering this an interesting
set of diagnostics, I thought it would be fun to create some way to parse these
log entries and save them in some format.  In addition, as I am also always
trying out new languages, the current language du jour is
[Golang](https://golang.org), so it seems like a reasonably interesting problem
to solve in a library.

## Example NetGear Log Entries

Parsing a log seems like a fun diversion, and looking at the NetGear log format,
it seems apparent that there was little formality in how they even logged what
happened.  There's **some** structure to it, but it's kinda messy:

```
[DoS Attack: ACK Scan] from source: 195.179.119.177, port 80, Monday, February 22, 2016 04:42:22
[Internet connected] IP address: 127.0.0.1, Monday, February 22, 2016 09:02:59
[DHCP IP: 192.168.1.11] to MAC address ff:ff:ff:ff:ff:ff, Monday, February 22, 2016 06:15:56
[UPnP set event: del_nat_rule] from source 192.168.1.8, Saturday, February 20, 2016 19:27:21
```

You can see that while it seems like everything within the square braces (`[]`)
is simple, things like `DHCP IP: 192.168.1.11` seem like a mixture of a rule
type and a dynamic piece of data.  Parsing this isn't like parsing a regular
format, or at least, it has enough special rules that will make creating
a parser a bit more work.

## Parsing Logs

I struck out to solve this in a couple ways.  My first attempt was a very simple
attempt to brute-force the log by `switch`'ing on a prefix, using some kind
of parsing for each type of log entry.  You can find example code of this on my
GitHub project here:

[github.com/klauern/go-netgearlogs/netgear.go](https://github.com/klauern/go-netgearlogs/blob/master/netgear.go)

I don't particularly like the repetitive nature of it, but I wonder whether this
isn't just 'acceptable code duplication' due to the nature of Go not allowing
much in the way of abstraction.  That said, this works, and it throws everything
I have given it into my generic `NetGear` struct type.  Yay for progress.

## Go's Parsing Strategies

After throwing together the above example, I started doing a bit more digging
and trying to determine if there was a "Go Way" to do things.  This is where
I stumbled on an article I was really excited about reading on the topic:
[Handwritten Parsers & Lexers in Go](https://blog.gopheracademy.com/advent-2014/parsers-lexers/)

Using the above blog as a guide, I struck out to create another format of the
parsing, to see if it would turn out to be simpler and/or more flexible. Currently,
I have some files that are still in-progress, but feel MUCH more like
a real parsing attempt for my problem.  I took a lot of inspiration
(*cough* copying *cough*)  from this article, and the current result can be
found in the source below: 

* [github.com/klauern/go-netgearlogs/token.go](https://github.com/klauern/go-netgearlogs/blob/master/token.go) (my list of tokens for a NetGear Log)
* [github.com/klauern/go-netgearlogs/scanner.go](https://github.com/klauern/go-netgearlogs/blob/master/scanner.go) (scanner for tokenizing the input into something above)
* [github.com/klauern/go-netgearlogs/parser.go](https://github.com/klauern/go-netgearlogs/blob/master/parser.go) (parser for converting those tokens into something tangible)

This is still a work-in-progress, but I highly recommend the blog post above if
you're curious on writing your own parser.  I also recommend finding something
to write a parser for.  It really gives you a window into the world of text
processing, programming language design, etc., and I walked away with a lot of
knowledge on parsing that I did not have before.
