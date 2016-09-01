+++
date = "2016-09-01T18:20:48-05:00"
draft = true
publishdate = "2016-09-02T12:00:00-05:00"
slug = ""
tags = ["", ""]
title = "Managed File Transfer Shenanigans"

+++

An approach in integrating two systems which I see pretty regularly is to take
an old, or legacy file format and copy it over to another system.  The end goal
being that you would write some kind of parser on the receiving end of this file
to take and ingest that format in.

This is your Poor Man's
Service Oriented Architecture, where systems either don't have integration
endpoints, or the work to implement all of those are deemed too difficult and/or
hard.  I don't fault anyone for being thrown in this pit of non-web services'
integration, but if you choose to go this route, you must be aware of several
considerations.

# Timing Guarantees, Missed Arrivals, Late Deliveries, etc.

If you implement any form of `cron`-based scheduling, you need to keep a very
clear set of contingencies in place for any of the following issues:

1. Failed Job Runs
2. Missed Delivery Timeframes
3. Late Delivery
4. Duplicate Delivery

Any of which can create mountains of trouble for you and your system.  How you
go about verifying any of the above is somewhat dependent on the use-case of the
system and the requirements that are being fulfilled.

## Failed Job Runs

For failures, you'll need an alerting system to ensure you will able to notify
and/or automatically recover any failed job runs.  Scheduling these runs can be
tricky, and there are who-knows-how-many systems out there that can provide some
kind of scheduling toolkit for you to use.  Aim for the automatic if possible,
as it's always faster for the system to automatically retry than for you to try
to do it at 2 or 3 in the morning (these jobs never fail at 9AM or after your
second cup of coffee).

## Late Delivery

Late delivery can mean a lot of things for a system, such as not being able to
send a shipment out on time, not getting bills paid within some kind of Service
Level Guarantee, or even automatically kickstarting some backup or redundancy
process that will attempt to re-run your job or re-process things.  This leads
to the next point.

## Duplicate Entry

Should you get in a vicious cycle of processing the same data over and over
again, there's--at minimum--the added load of having your systems process extra
data without need.  Worse yet, if your data is naive enough to have data in the
form of:

    --Add $20 to account X
    --Subtract $100 from account X

and you re-process this data, you're definitely going to have a bad day when
someone calls in to say that they lost all their money, or **nobody** calls in
when they somehow accidentally got $$$$$'s of dollars without notice.

You need to build in some kind of tolerance for this, and hopefully that can be
encoded in the file you're processing.  The ideal goal is that re-processing is
at worst a wasted effort, but no harm as it is just overwriting the same 1's and
0's with the same 1's and 0's.  That can't always be the case, but it should be
strived for.

# Verification and Validation

What comes next is that when you get a file, you need to do both **verify** that
it is the file you need, and **validate** that it can be properly parsed.

## Verification

Verification is the act of assuring that the file you're looking at came from
the person or system you expected it to.  In broad terms, you should encrypt
files at rest, **always**.  This isn't going to cover everything, however,
because while it may prevent a man-in-the-middle attacker from subverting and/or
muck with your system data, it doesn't prevent that same person from encrypting
a completely different file that shouldn't be processed at all.

If you choose to encrypt the file, you better be using some form of Digital
Signature.  It's about the only means you have to verify that the person that
encrypted it was the person you wanted to get the file from.  I am not terribly
strong on this front, so I might be off-base.

## Validation

Finally, we get to the Validation portion of the file.  This is simply being
able to parse the file out properly before you attempt to import it in to the
system.  Many systems do this, and I don't think this is a terribly difficult
part of the process to handle.  That said, I would avoid doing any kind of
transaction committal before processing the whole file.  The worst-case scenario
here is that you find that the file format isn't quite right, or that something
is out of alignment (a huge issue with column-delimted or CSV data), so you will
find yourself inserting the wrong columns into your system without proper
validation.

# Summary

File transfer as a service is hard.  I don't think it's something that you can
take for granted as being 'just a `cron` job', as it's way more complicated than
that.  You will inevitably trip yourself up with any of these kinds of things.
I wouldn't say it's less likely in the SOA or web services world, but the scope
of the problem is way larger when you batch things up into a file.

Seldom is a file just one record or transaction.  If you are at the point that
doing SOA or some kind of API development is an issue, you'll find yourself
inevitably bundling up as much as you can in that file, turning what would have
been a bunch of service calls into one massive file for import.  Now your
problem is compounded by having to not just be valid on the row or record-level,
but valid at the entire boundary of the file.  What happens if it's incorrect?
can you parse it out to find out where it broke?  How do you know the next file
will be correct?  Is there a way to reproduce the issue?

I suggest that if you find yourself using file-based transfer systems a lot,
you're probably solving the wrong problem.  You need to look at what you're
taking in, how it's being done, and just converting that into some kind of an
ETL tool or SOA integration.  Doing much else is just a recipe for the problems
above.  It's bad enough that any of these would happen, let alone having to
safeguard yourself from all of them at once.

[shamir]: https://en.wikipedia.org/wiki/Shamir%27s_Secret_Sharing
