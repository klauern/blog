---
layout: blog
draft: 'false'
title: Windows Subsystem for Linux
date: 2017-04-19T00:05:23.510Z
---
With a new laptop and a ton of horsepower, I’ve been struggling to figure out just how best to set up this new machine.  I’m pretty agnostic with what kind of platform I run, as I have been working on Windows, Linux and OS X regularly.  I do have my preference for Linux, but Microsoft has been doing a lot of good work recently in trying to win over developer mindshare, so I’d like to keep at least one toe in the Redmond pool.

My new machine is a Dell XPS 15, and it’s great for what it has in it.  I think it could run Linux admirably, but there are a number of things that I just want to try out that require Windows:

* Docker Windows Containers
* .NET platform (Mono is an option, but why handicap yourself before you know what you're doing?)
  * In particular, F# is a great looking language, and I'd like to get a better feel for it
* Windows Application Development

While I am probably always going to have a fondness for the CLI and terminal, I can't pretend that the rest of the world even likes using these things, so I'm more than happy to learn a platform that lets me develop a tool that everyone can use, even if it doesn't fill my Linux lifeblood.

# Configuring Windows Subsystem for Linux

That said, the work that Microsoft has been putting in to the Windows Subsystem for Linux is incredibly impressive, so I think I can probably have my cake and eat it, too.  In fact, I've been doing just that, and setting up WSL was probably one of the best additions to Windows.  Here's a quick rundown of the steps I had to follow to make the setup a bit seamless for the work I'm doing.


Bash on Windows Repo stubs
## 1. Update packages

```sh
sudo apt update
sudo apt upgrade
sudo apt autoremove
```

## 2. Apt packages

```sh
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

```sh
curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash -
```
## 4. Ansible

```sh
# configure ansible
apt-get install -y software-properties-common python-software-properties
add-apt-repository ppa:ansible/ansible
apt-get update
apt-get install -y --force-yes ansible
```

## 5. other tooling

## 6. Golang

I have been coding in go in my spare time, and setting it up is pretty easy:



