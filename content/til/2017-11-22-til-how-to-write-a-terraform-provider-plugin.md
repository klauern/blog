---
draft: 'false'
title: 'TIL: How to write a Terraform Provider Plugin'
date: 2017-11-22T20:49:34.020Z
---
As with most "Infrastructure as Code" concepts, one of the major appeals of some of these tools is the declarative format to specifying what you want your infrastructure to look like.  You then let the tool figure out how to make that happen.  Personally, this is why tools like [Ansible](https://ansible.com/) and [Terraform](https://terraform.io) seem to have taken what I think of as the **People's Choice** awards.

In this post, I was curious how easy it would be to write what Terraform calls a [Provider](https://www.terraform.io/docs/providers/index.html), which you can think of as the API that interfaces with a service.  Some providers that came out of the box include:

* Amazon Web Services
* Microsoft Azure
* Digital Ocean
* Various DNS providers

in addition to many, many others.

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
package gitea

import (
	"code.gitea.io/sdk/gitea"
)

// Config represents the configuration necessary to connect to a Gitea API Server.
type Config struct {
	Token   string
	BaseURL string
}

// Client will create a new Gitea HTTP client based on the Config.
func (c *Config) Client() *gitea.Client {
	return gitea.NewClient(c.BaseURL, c.Token)
}
```

<!--EndFragment-->

## gitea/provider.go

```go
package gitea


import (
	"github.com/hashicorp/terraform/helper/schema"
)


// Provider is the Terraform provider for Gitea.
func Provider() *schema.Provider {
	return &schema.Provider{
		Schema: map[string]*schema.Schema{
			"token": {
				Type:        schema.TypeString,
				Required:    true,
				DefaultFunc: schema.EnvDefaultFunc("GITEA_TOKEN", nil),
				Description: "Token key for Gitea API access",
			},
			"base_url": {
				Type:        schema.TypeString,
				Required:    true,
				DefaultFunc: schema.EnvDefaultFunc("GITEA_URL", nil),
				Description: "URL to the Gitea Server (https://gitea.user.com:8888)",
			},
		},
		ResourcesMap: map[string]*schema.Resource{
			"gitea_user": resourceUser(),
		},
		ConfigureFunc: providerConfigure,
	}
}


func providerConfigure(d *schema.ResourceData) (interface{}, error) {
	config := &Config{
		Token:   d.Get("token").(string),
		BaseURL: d.Get("base_url").(string),
	}


	return config.Client(), nil
}
```
