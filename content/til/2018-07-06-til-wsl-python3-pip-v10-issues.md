---
draft: 'false'
title: 'TIL: WSL Python3 Pip v10.* issues'
date: '2018-07-06T07:53:01-05:00'
---
I recently had an issue where I had attempted to update pip on my installation of WSL.  However, this caused some issues:

![ImportError: cannot import name 'main'](/img/uploads/2018-07-06-08_07_39-window.png)

Now, I didn't know what I did wrong, so a little Googling came back with a nify StackOverflow answer:

[Python pip3 - cannot import name 'main' error after upgrading pip](https://stackoverflow.com/q/49836676/7008)

The fix is pretty easy.  You simply uninstall and reinstall the `python3-pip` system version:

```sh
sudo python3 -m pip uninstall pip && sudo apt install python3-pip --reinstall
```
