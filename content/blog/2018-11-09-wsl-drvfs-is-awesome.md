---
draft: 'true'
title: WSL - DrvFs is awesome
date: '2018-11-30T00:00:00-06:00'
---
Simply put, [DrvFs](https://blogs.msdn.microsoft.com/commandline/2018/01/12/chmod-chown-wsl-improvements/) is awesome.  This is a small tutorial on how to configure it.  We will make use of several components that Microsoft's dev team provided us:

1. DrvFs with [chmod/chown WSL Improvements](https://blogs.msdn.microsoft.com/commandline/2018/01/12/chmod-chown-wsl-improvements/)
2. [`/etc/wsl.conf`](https://blogs.msdn.microsoft.com/commandline/2018/02/07/automatically-configuring-wsl/) configuration file that will be loaded on start
3. a customized `/etc/fstab` to store the configs for this

# First time Setup

To try out the new DrvFs environment, first, we want to unmount the existing `/mnt/c` mount:

```
sudo umount /mnt/c
```

From here, we can configure a more full-featured version of that mount:

```
sudo mount -t drvfs C: /mnt/c -o metadata,uid=1000,gid=1000,umask=22,fmask=111
```

To summarize what these options do:

* `uid=1000,gid=1000` - set the default Group ID and User ID to match our user (in my case, the `klauer` user is `1000`, so we match that
* `umask=22` - in most *nix distros, it's common to have the `umask` set to `022`, to prevent automatically setting everything as an **executable** program.  There's a great [StackOverflow Answer](https://askubuntu.com/questions/44542/what-is-umask-and-how-does-it-work#44548) that explains this better than I can, so I recommend you look there.
* `fmask=111` - similar to `umask`, but for regular files
* `metadata` - Reading from the [associated blog post](https://blogs.msdn.microsoft.com/commandline/2018/01/12/chmod-chown-wsl-improvements/), this allows us to set metadata on Windows files, allowing us to apply `+x` perms, etc to it.

# Always Setting Up with `/etc/fstab`

Now, if you get around to playing with this, you might _like_ using it, but find that typing `sudo umount` and `sudo mount` a chore, let's start by stubbing out a `wsl.conf` file:

```ini
#Let’s enable extra metadata options by default
[automount]
enabled = true
root = /mnt/
options = "metadata,uid=1000,gid=1000,umask=22,fmask=111"
mountFsTab = true

#Let’s enable DNS – even though these are turned on by default, we’ll specify here just to be explicit.
[network]
generateHosts = true
generateResolvConf = true
```

I really didn't change much of anything here, but I do want to make sure that this is created in `/etc/wsl.conf` on your WSL distro as `root`.

The final bit is adding this to your `/etc/fstab` file:

```
C:  /mnt/c  drvfs   rw,uid=1000,gid=1000,metadata,case=off,umask=22,fmask=111,relatime   0   0
```

Now, whenever you start a new prompt, you can check your mount points and see all of the options pre-set for you:

![C: /mnt/c drvfs rw,uid=1000,gid=1000,metadata,case=off,umask=22,fmask=111,relatime 0 0](/img/uploads/2018-11-09-18_51_48-select-klauer-klauerxps__home_klauer.png)
