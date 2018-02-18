---
draft: 'false'
title: Using Ansible for setting up Ubuntu desktop
date: 2018-01-25T01:42:13.873Z
---
I've been a huge fan of [Ansible](https://www.ansible.com) ever since I found it.  Perhaps because I work with long-lived servers, the use of Ansible to provision, modify, configure, etc., servers had a much bigger influence on my productivity over solutions that provision immutable, throwaway-like servers, as my kind of work is usually dealing with legacy systems that haven't moved to that paradigm (yet).  In the age of [immutable infrastructure](https://thenewstack.io/a-brief-look-at-immutable-infrastructure-and-why-it-is-such-a-quest/), it's become less important to manage long-lived servers.   

Alright, so if we're not going to throw away our desktop machines, what kind of things can we automate to keep our desktop machine in tip-top shape?  I've been using Ansible to figure this out.  It's been really interesting, as I've found all of the fun dials and knobs to modify stuff outside of the GUI, and it's been a lot of fun.

## How to configure a developer workstation with Ansible

So, let me show off what I've been working on and having so much fun doing.

