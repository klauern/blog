---
draft: 'false'
title: Arch Linux - Manual Package Installation
date: 2017-04-19T13:52:03.578Z
---
I use a flavor of [Arch Linux][1] at work called [Manjaro Linux][2].  I love it, but one thing that I always get tripped up on is the way that Arch and the `pacman` tool handle non-free software.  In almost all of the cases, I can usually find a package on the Arch Linux repo with what I need, but for some commercial apps, you have to install these yourself.  This is fine, and supported, but the process to do it is not clear to me, as opposed to how easy it is to work with `yaourt` to do package installs for everything else.

Let’s discuss how we can do that here.


# Downloading the `PKGBUILD` manually

First, let's download the `PKGBUILD` file manually.  This can be done with the `-G` flag:

`yaourt -G <pkgname>`


# Making packages

Next, download whatever sources you need to include and use.  Any files that are downloaded and referenced locally *relative to the `PKGBUILD` file*, and run the `makepkg` command.

`makepkg`

# Installing packages

Finally, after the tool has made your packages, you can use `yaourt` to install them directly by just passing the `.xz` file in directly.

`yaourt <pkgname.xz>`



[1]: https://archlinux.org
[2]: https://manjaro.org/
