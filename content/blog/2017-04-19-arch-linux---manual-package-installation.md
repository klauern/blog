---
layout: blog
draft: 'true'
title: Arch Linux - Manual Package Installation
date: 2017-04-19T13:52:03.578Z
---
I use a flavor of Arch Linux at work called Manjaro Linux.  I love it, but one thing that I always get tripped up on is the way that Arch and the `pacman` tool handle non-free software.  In almost all of the cases, I can usually find a package on the Arch Linux repo with what I need, but for some commercial apps, you have to install these yourself.  This is fine, and supported, but the process to do it is not clear to me, as opposed to how easy it is to work with `yaourt` to do package installs for everything else.

Let’s discuss how we can do that here.


# Downloading the `PKGBUILD` manually

`yaourt -G <pkgname>`

# Making packages

`makepkg`

# Installing packages

`yaourt <pkgname.xz>`
