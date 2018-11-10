---
draft: 'false'
title: Windows Subsystem for Linux
date: 2017-09-18T00:05:23.000Z
---
With a new laptop and a ton of horsepower, I’ve been trying to figure out just how best to set up this new machine.  I’m pretty agnostic with what kind of platform I run.  I have been working on Windows, Linux and OS X regularly, so choice is pretty ‘meh’.  I have a personal preference for Linux, but as Microsoft has recently been doing a lot of good work in trying to win over developer mindshare, I’d like to keep at least one toe in the Redmond pool.

My new machine is a [Dell XPS 15 9560](http://www.anandtech.com/show/11670/the-dell-xps-15-9560-review-infinity-edge-part-two), and it’s probably a beast for what I’m doing with it.  I know it could run Linux admirably, but there are a number of things that I just want to try out that require Windows:

* Docker Windows Containers
  * .NET platform (Mono is an option, but why handicap yourself before you know what you're doing?)
  * In particular, F# is a great looking language, and I'd like to get a better feel for it
* Windows Application Development

While I am probably always going to have a fondness for the CLI and terminal, I can't pretend that the rest of the world even likes using these things, so I'm more than happy to learn a platform that lets me develop a tool that everyone can use, even if it doesn't fill my Linux lifeblood.

# Configuring Windows Subsystem for Linux

That said, the work that Microsoft has been putting in to the Windows Subsystem for Linux is incredibly impressive, so I think I can probably have my cake and eat it, too.  In fact, I've been doing just that, and setting up WSL was probably one of the best additions to Windows.  Here's a quick rundown of the steps I had to follow to make the setup a bit seamless for the work I'm doing.

Bash on Windows Repo stubs

## 1. Update packages

```
sudo apt update
sudo apt upgrade
sudo apt autoremove
```

## 2. Apt packages

```
# install packages that are common to our group and/or useful
apt-get install -y \
        maven \
        python \
        python3 \
        curl \
        wget \
        stow \
        vim-gtk \
        subversion \
        openjdk-7-jdk
```

## 3. NodeJS

```
curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
```

## 4. Ansible

```
# configure ansible
apt-get install -y software-properties-common python-software-properties
add-apt-repository ppa:ansible/ansible
apt-get update
apt-get install -y --force-yes ansible
```

# Summary

This is really just a small "tip of the iceberg" of what I am doing with this.  I actually have a set of Ansible playbooks written to do a lot more than this.  The playbooks do a lot around:

* [Keybase.io](https://keybase.io) setup
* Work-related HTTP/s proxy configuration
* [Golang](https://golang.org) install and configuration of base packages/tools
* NodeJS configuration
* Vim rollout (I have a completely [separate repository](https://github.com/klauern/dot-vim) for this)


Unfortunately, I’m not yet comfortable with sharing it at this time.  If I find the time, I will work on getting this out there, as I think WSL is a great tool, and coupling it with Ansible is nothing short of powerful.
