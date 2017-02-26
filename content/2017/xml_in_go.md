+++
tags = ["xml","golang", "go"]
slug = ""
title = "XML in Go"
date = "2017-02-25T22:11:11-06:00"
draft = true
+++

Recently, I had a problem that I thought I could toy with [Go][go] to solve.  I support a number of software
components written with a backend that heavily uses XML for definition data.  Most of these XML elements have
familiar namespace values that you would likely see in a SOAP service, or anything that used more than
your vanilla XML.

Now, while XML is not even close to a new language or data format, I assumed that parsing and digging in to
XML would be pretty easy, relatively speaking.  Go has some pretty nifty ways to parse XML and JSON data
