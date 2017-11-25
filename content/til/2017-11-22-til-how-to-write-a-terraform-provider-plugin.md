---
draft: 'false'
title: 'TIL: How to write a Terraform Provider Plugin'
date: 2017-11-22T20:49:34.020Z
---
As with most "Infrastructure as Code" concepts, one of the major appeals of some of these tools is the declarative format to specifying what you want your infrastructure to look like.  YOu then let the tool figure out how to make that happen.  Personally, this is why tools like [Ansible](https://ansible.com/) and [Terraform](https://terraform.io) seem to have taken what I think of as the **People's Choice** awards.

In this post, I was curious how easy it would be to write what Terraform calls a [Provider](https://www.terraform.io/docs/providers/index.html), which you can consider the API that will interface with a particular set of resources.  Some providers that came out of the box include:

* Amazon Web Services
* Microsoft Azure
* Digital Ocean
* Various DNS providers

among many, many others.

Along these providers, there were a couple posts that I followed to help implement one
