---
draft: 'false'
title: How to use keybase.io with goreleaser
date: 2018-02-16T23:43:42.247Z
---
I have been dabbling a bit with PGP, as I know it's something that I use indirectly, but have some gaps in my knowledge.  Recently, I started integrating [**`goreleaser`**](https://goreleaser.com) in some of my projects.  Well, nifty enough is there is a place to [add signing to it](https://goreleaser.com/#signing), which uses `gpg` by default:

```yml
# .goreleaser.yml
sign:
  # name of the signature file.
  # '${artifact}' is the path to the artifact that should be signed.
  #
  # signature: "${artifact}.sig"

  # path to the signature command
  #
  # cmd: gpg

  # command line arguments for the command
  #
  # to sign with a specific key use
  # args: ["-u", "<key id, fingerprint, email, ...>", "--output", "${signature}", "--detach-sign", "${artifact}"]
  #
  # args: ["--output", "${signature}", "--detach-sign", "${artifact}"]


  # which artifacts to sign
  #
  #   checksum: only checksum file(s)
  #   all:      all artifacts
  #   none:     no signing
  #
  # artifacts: none
```

Well, this was easy enough to modify with a [little change](https://github.com/klauern/trackello/blob/97d579b023355e374b6aac16b3b4e62f4a74733e/.goreleaser.yml#L61-L72):

```yml
sign:
  cmd: keybase
  args:
  - sign
  - --infile
  - $artifact
  - --binary
  - --outfile
  - $signature
  - --detached
  signature: ${artifact}.sig
  artifacts: checksum
```

Which, when run on a recent release, will produce a release with a signed file for the checksum itself:

![trackello release v0.2.7](/img/uploads/screenshot from 2018-02-16 18-16-15.png)
