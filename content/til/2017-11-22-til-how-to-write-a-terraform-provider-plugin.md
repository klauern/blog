---
draft: 'false'
title: 'TIL: How to write a Terraform Provider Plugin'
date: 2017-11-22T20:49:34.020Z
---
As with most "Infrastructure as Code" concepts, one of the major appeals of some of these tools is the declarative format to specifying what you want your infrastructure to look like.  YOu then let the tool figure out how to make that happen.  Personally, this is why tools like [Ansible](https://ansible.com/) and [Terraform](https://terraform.io) seem to have taken what I think of as the **People's Choice** awards.

I wouldn't say that one is better than the other, but I would agree that together, you can either 1) spin up new infrastructure from scratch or 2) modify existing infrastructure to have the right state.  I think that in the long-run, Terraform--or something like it--is likely to take the lead.  Part of the reason for thinking this is that as we move away from hand-crafting or modifying existing servers (be it legacy or even new ones created through EC2/VMWare, etc.) we will be pursuing a scrap-it-all approach to build them anew using cloning and 
