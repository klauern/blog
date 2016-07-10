+++
date = "2016-07-01T20:31:12-04:00"
slug = ""
tags = ["", ""]
title = "Trackello"

+++

# Trello's API and Golang

Among some of [my][1] [earlier][2] [posts][3], I've been looking towards Golang
as a tool for building some more command-line apps.  To better understand how to
use it for HTTP-based client work, I wanted to build a small command-line app to
work with the [Trello API][4].  When working with it, I found a really excellent
Golang API for the Trello API here: https://github.com/VojtechVitek/go-trello


# Trackello

Recently, my boss wanted to get a bi-weekly update of projects, tasks, and
things I've been working on.  This was more for him to have an idea what I was
putting my time into, as well as having evidence for promotions, bonuses, etc.
I track most of my work using Trello, so this seemed a perfect opportunity to
pull all of this information out using the built-in [Trello API][4] that they so
wonderfully provided us users.

Thus, let us introduce to the audience, [Trackello][5], a CLI to track your
work:

```sh
Trackello is a command-line tool to allow you to retrieve and get
information on your Trello boards.  This tool provides a list
of the previous 14 days of information on a board defined in
your 'config' file (see '--config' flag for info

Usage:
  trackello [command]

Available Commands:
  boards      List all of your boards
  cards       List all of the cards on a particular board.
  config      Configure your Trello API keys and preferred Trello Board
  list        List activities on a board

Flags:
      --appkey string   Trello Application Key
      --board string    Preferred Board ID
      --config string   config file (default is $HOME/.trackello.yaml)
  -h, --help            help for trackello
      --token string    Trello Token

Use "trackello [command] --help" for more information about a command.
```

# Configuration

To talk to the Trello API, you need two pieces:

* Trello APP key
* Trello Token

To get both of these, go to https://trello.com/app-key .  You can get both the
Application key and a personal Token.  For my first iteration of this program, I
assumed you would want to get information for **one** Trello board, which would
be your /preferred/ board.  This is not required for normal use, but makes things
easier.

As always, the command-line options can help here:

```
$ trackello help config
Using config file: /<your_home_dir>/.trackello.yaml
To communicate to a Trello API, you will need to configure a
minimum of 3 parameters:
  - TRELLO_APPKEY
  - TRELLO_TOKEN
  - preferredBoard

If you do not know or have any of these, you can review  the documentation
on this site: https://trello.com/app-key

Usage:
  trackello config [flags]

Global Flags:
      --appkey string   Trello Application Key
      --board string    Preferred Board ID
      --config string   config file (default is $HOME/.trackello.yaml)
      --token string    Trello Token
```

If you call this command and pass in the Global Flags, you will get
a `trackello.yaml` file that has your configuration in it:

```yaml
$ cat ~/.trackello.yaml
appkey: f3ff39c83d227a7243abf4df66ffffff
token: b448d5fb4f1af85f3fffffffffffffffffffffffffffffffffffffffffffffff
board: 572ffff7ffffffffffffff83
```

# Listing A Specific Board's Actions

By default, the `trackello list` command will show you a listing of all board
actions that occured in the last two weeks:

```sh

```

# Listing All Boards

Further, you can also list all of your boards using `trackello boards`

[1]: /2016/netgearlogs
[2]: /2015/announcing_remy
[3]: /2015/thoughts_on_go
[4]: https://developers.trello.com/
[5]: https://github.com/klauern/trackello/
