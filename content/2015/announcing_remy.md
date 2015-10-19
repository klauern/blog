+++
date = "2015-10-18T10:44:48-05:00"
draft = false
title = "Remy - RESTful client for WebLogic Servers"

+++

I've been learning the [Go](https://golang.org) programming language for the
past few months.  I can't say I'm totally smitten with the language, but with
it's ability to produce self-contained, cross-platform binaries, it is really
compelling, language semantics aside.

Anyways, while working with Go, I tried to find out how easy it would be to
generate really useful, self-contained command-line applications.  I don't have
nearly the same need for the concurrency features that Go provides, but I'm
certain that the stepping-stone to getting there is to be able to create small,
focused tools, adding concurrency as needed afterwards.

# WebLogic RESTful Management Services

This isn't exactly a **new** feature of WebLogic server, but Oracle built in
a set [of RESTful API's](http://docs.oracle.com/cd/E23943_01/web.1111/e24682/toc.htm#RESTS149)
that let you query an Administration Server for various statistics of your
managed servers in a domain.  You can use whatever kind of tool to query this,
like `curl`, `wget`, etc., but I thought it might be fun to try to wrap this
into some kind of command-line tool.

# Enter Remy

That's where I came up with the [Remy command-line
application](https://github.com/klauern/remy).  Remy is really
just a play on vocabulary for **RESTful Management Extensions**, REME(long-E).

There's a lot of features that Oracle put in place with the WebLogic RESTful
Management Services, so typing `remy help` will get you familiarized with
*what*'s available:

```powershell
C:\
> remy help
Query a WebLogic Domain's resources, including Datasources, Applications, Clusters, and Servers by using the WebLogic RESTful Management Extensions API

Usage:
  remy [command]

Available Commands:
  applications Query applications deployed under AdminServer
  config       Configure the credentials and server to default REST connections to
  clusters     Query clusters under AdminServer
  datasources  Query datasources under AdminServer
  servers      Display Server information
  version      Show the version of this command

Flags:
  -s, --adminurl="http://localhost:7001": Url for the Admin Server
  -f, --full-format[=false]: Return full format from REST server
  -p, --password="welcome1": Password for the user
  -u, --username="weblogic": Username with privileges to access AdminServer

Use "remy [command] --help" for more information about a command.
```

## Querying

All commands require some form of the `AdminUrl`, `Password` and `Username`, in
order to query an appropriate AdminServer instance.  This can be specified on
the command-line with the global `--adminurl`, `--password`, and `--username`
flags, respectively:

```powershell
$ remy servers --adminurl "http://adminServer:7001" --password "welcome1" --username "weblogic"
Finding all Servers
Using Full Format? false
Name:        AdminServer   | State:           RUNNING       | Health:        HEALTH_OK
Cluster:                   | CurrentMachine:                | JVM Load:      0
Sockets #:   0             | Heap Sz Cur:     0             | Heap Free Cur: 0
Java Ver:                  | OS Name:                       | OS Version:
WLS Version:

Name:        WLS_WSM1      | State:           RUNNING       | Health:        HEALTH_OK
Cluster:                   | CurrentMachine:                | JVM Load:      0
Sockets #:   0             | Heap Sz Cur:     0             | Heap Free Cur: 0
Java Ver:                  | OS Name:                       | OS Version:
WLS Version:

Name:        WLS_SOA1      | State:           RUNNING       | Health:        HEALTH_OK
Cluster:                   | CurrentMachine:                | JVM Load:      0
Sockets #:   0             | Heap Sz Cur:     0             | Heap Free Cur: 0
Java Ver:                  | OS Name:                       | OS Version:
WLS Version:

Name:        WLS_OSB1      | State:           RUNNING       | Health:        HEALTH_OK
Cluster:                   | CurrentMachine:                | JVM Load:      0
Sockets #:   0             | Heap Sz Cur:     0             | Heap Free Cur: 0
Java Ver:                  | OS Name:                       | OS Version:
WLS Version:
```

## Configuration

Typing in the username, password, etc., on the command-line is not really the
greatest way to solve the problem, and is very likely insecure, so we can do one
better.  With Remy, I implemented a [`TOML`](https://github.com/toml-lang/toml)-formatted
configuration format.  It looks like this:

```toml
AdminURL = "http://adminserver.local:7001"
Username = "weblogic"
Password = "welcome1"
```

Now, you may think, "That password is in plain text".  You'd be correct. The way
to configure this how you like is to call the `remy config --local --password
'password'`, or `$env:PASSWD` environment variable, or whatever you like doing
in Bash (maybe `read -s PASSWD`).

Now, you can look at the file and see that it is at least encrypted/abstracted
a bit using a built-in encryption key:

```powershell
C:\
λ cat .\wlsrest.toml
AdminURL = "http://adminserver.local:7001"
Username = "weblogic"
Password = "{AES}LR8d4zIdsRl0CqmKRvVBDuk3"
```

The next thought that you might have "well, you're using a plainly-visible,
known, searchable-on-your-repo, password.  Yes, you're correct.  I love smart
people.  Well, you can supply your own environment variable for it, too:

```powershell
$ export WLS_REMYKEY="My very very very awesome key!!!" # (MUST be 32 bytes in length EXACTLY)
$ remy config --local
$ cat .\wlsrest.toml
AdminURL = "http://adminserver.local:7001"
Username = "weblogic"
Password = "{AES}BM1uj9uv1bD7KV6BXapCf1kucxDYbCU6"
```

But I'm sure there's other implications here.  I'd like to keep going down the
rabbit-hole, but honestly, I'm really waiting for [Hashicorp Vault](https://vaultproject.io/)
to support LDAP a lot better than their current version (0.3.1 is pretty
rudimentary for LDAP).  In that event, I'd be all for getting that secret from
Vault.  Although, I think that the [FIDO U2F Yubikey](https://www.yubico.com/products/yubikey-hardware/)
is probably even cooler when you get down to it, but I digress.

# Source Code, Information and Errata

I've really only touched the surface of this tool.  I think you should take
a look at it yourself:

GitHub Source Code
- [https://github.com/klauern/remy](https://github.com/klauern/remy)

As I've mentioned before, this is probably my second or third GoLang application
(I'm goign to call it Golang, so all you "It's called Go", zealots need to get
a life and realize Google search sucks with 2 letter
verbs-used-as-programming-languages) so I am open to learning and finding out
more about whether you think that the form is good.  I'm not really looking for
critiques on whether or not it's easier solved in a set of `curl` or `httpie`
commands, because that's not what I wrote it for.


