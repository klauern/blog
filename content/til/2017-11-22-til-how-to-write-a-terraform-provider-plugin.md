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

Along these providers, there were a couple posts that I followed to help implement one:

* [Managing Google Calendar with Terraform](https://www.hashicorp.com/blog/managing-google-calendar-with-terraform)
* [Provider Plugins](https://www.terraform.io/docs/plugins/provider.html)

Both of these really made it seem **possible** to implement your own plugin, so I decided to try out something with [Gogs](https://gogs.io) and [Gitea](https://gitea.io).  Both Gogs and Gitea are self-hosted Git repository managers.  In particular, Gitea is a fork of Gogs, so they share a sizable codebase, including having nearly identical SDK client libraries.  I attempted to write a Terraform Provider plugin against Gitea, and found that the same provider works just as well with Gogs.  Source for both projects can be found here:

* [terraform-gitea-provider](https://github.com/klauern/terraform-gitea-provider)
* [terraform-gogs-provider](https://github.com/klauern/terraform-gogs-provider)

I wouldn't say that either are perfectly working, but they do enough to make me confident that I could write something else just as quickly.

## main.tf

<!--StartFragment-->

```hcl
variable "gitea_token" {
    type = "string"
}

variable "gitea_base_url" {
    type = "string"
}

provider "gitea" {
    token = "${var.gitea_token}"
    base_url = "${var.gitea_base_url}"
}

resource "gitea_user" "bob" {
    login = "bob"
    password = "password"
    email = "bob@example.com"
    full_name = "Bob Marley"
}
```

<!--EndFragment-->

## gitea/config.go

<!--StartFragment-->

```go
variable "gitea_token" {
    type = "string"
}

variable "gitea_base_url" {
    type = "string"
}

provider "gitea" {
    token = "${var.gitea_token}"
    base_url = "${var.gitea_base_url}"
}

resource "gitea_user" "bob" {
    login = "bob"
    password = "password"
    email = "bob@example.com"
    full_name = "Bob Marley"
}
```

<!--EndFragment-->
