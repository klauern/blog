---
draft: 'false'
title: WSLTTY and DrvFs executable perms
date: '2018-12-28T07:06:06-06:00'
---
I'm a big fan of [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/about).  I've been using it as my primary environment on my personal Windows laptop as well as receiving primary use on my work machines.  One of the newer features in recent builds of windows is support for a pseudo-filesystem called [DrvFs](https://blogs.msdn.microsoft.com/wsl/2017/04/18/file-system-improvements-to-the-windows-subsystem-for-linux/).  It allows more mount options, as well as a bigger set of controls over the way files look on the Windows side.

One of the pet peeves with the way that WSL works is that you can easily navigate to shares outside of WSL within the `/mnt/c/` auto-mounted path.  This is fine, except all of the files would look 'wrong', insofar as the octal permissions assigned to them.  

```
-rwxrwxrwx 1 klauer klauer   18451 Dec  5 11:17 cygwin-console-helper.exe
-rwxrwxrwx 1 klauer klauer 3335398 Dec  5 11:17 cygwin1.dll
-rwxrwxrwx 1 klauer klauer  100883 Dec  5 11:17 dash.exe
-rwxrwxrwx 1 klauer klauer  626176 Dec  5 11:17 mintty.exe
-rwxrwxrwx 1 klauer klauer   25107 Dec  5 11:17 regtool.exe
-rwxrwxrwx 1 klauer klauer  150568 Dec  5 11:17 wslbridge-backend
-rwxrwxrwx 1 klauer klauer  828416 Dec  5 11:17 wslbridge.exe
-rwxrwxrwx 1 klauer klauer   89600 Dec  5 11:17 zoo.exe
```

Kinda ugly, because now everything is owned and operable by everyone...  WHile we are the only user on this system, it doesn't feel right, and the visuals don't look good in a colorized terminal, either.  Usually, `777` is flagged big and flashy because it's so out of place.

To fix this, you can add a configuration to the `/etc/wsl.conf` that will let you define WSL-specific functionality, such as mount points and options passed in.  See [this blog post][2] for specifics around it.  In the example, the `options` field sets some file mask options, such as `fmask` and `umask`:

```ini
# Enable extra metadata options by default
[automount]
enabled = true
root = /mnt/
options = "metadata,umask=22,fmask=11"
mountFsTab = false

# Enable DNS – even though these are turned on by default, we’ll specify here just to be explicit.
[network]
generateHosts = true
generateResolvConf = true
```

This is actually great, because now files inside of `/mnt/c/` aren't all `0777` permissions all the time.  However, it introduced a new issue that I was completely flummoxed by: [wsltty][3] boot issues.

# `wsltty` and `wslbridge`

With WSL, there are a number of client options and terminals you can use to work with.  The out-of-the-box experience isn't my favorite, so I've opted for [wsltty][3], which is a WSL-specific version of [mintty][4], a terminal emulator.  It gives you some better customizations on themes, colors, fonts, etc., and I just like how it works better.  However, I discovered that modifying the `[automount]` options actually breaks this.

## The Issue

When starting `wsltty`, it must interact with a component called `wslbridge`, which allows I/O, mouse clicks, etc., to interface with the WSL environment and back from Windows.  However, **if it can't start this** it immediately quits.

## The Fix

The fix is actually quite easy.  With `DrvFs`, file mode changes persist on the Linux side.  That means you can `chmod +x` a file in `/mnt/c/` and it will be flagged with the appropriate executable bit when you restart WSL the next time.

I simply opened up the default WSL terminal (Ubuntu-18.04 in my case), and modified the following file:

```
chmod +x /mnt/c/Users/klauer/AppData/Local/wsltty/bin/wslbridge-backend
```

And things were ready to go.  The fix is easy, but figuring out that **this particular file was the reason for the failure** was the really hard bit.  It's surprising how seemingly unrelated changes can cause real issues.  In any event, I'm glad I learned about this, as I gained a lot of knowledge about WSL as well as file permissions, WSLTTY's use of the `wslbridge` component, and `DrvFs`.  It wasn't all for naught.

[2]: https://blogs.msdn.microsoft.com/commandline/2018/02/07/automatically-configuring-wsl/
[3]: https://github.com/mintty/wsltty
[4]: https://mintty.github.io/
