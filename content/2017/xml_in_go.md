---
tags: ["xml", "golang", "go"]
slug: ""
title: "XML in Go"
date: "2017-04-25T22:11:11-06:00"
draft: false
---

# Woes with XML and Go

Recently, I had a problem that I thought I could toy with [Go][go] to solve.  I support a number of software components written with a backend that heavily uses XML for definition data.  Most of these XML elements have familiar namespace values that you would likely see in a SOAP service, or anything that used more than your vanilla XML.

Now, while XML is not even close to a new language or data format, I assumed that parsing and digging in to XML would be pretty easy, relatively speaking.  Go has some easy to learn ways to parse JSON data, generally with struct tags like so:

```go
type Author struct {
  firstName string `json:"first_name,omitempty"`
  lastName  string `json:"last_name,omitempty"`
  age       int    `json:"wisdom_level,omitempty"`
}
```

And this works reasonably well.  For XML types, it's not much different:

```go
type Author struct {
  firstName string `xml:"FirstName,omitempty"`
  lastName  string `xml:"LastName,omitempty"`
  age       int    `xml:"WisdomLevel,omitempty"`
}
```

That is, these are  all reasonably effective in parsing vanilla XML.  Now, I work in an environment where XML never really left as a primary means of passing data around, and with it, people have been using every little bit of the schema to perform all sorts of things.  For instance, the multitude of WS-\* specifications are only part of what I deal with.  The colliding namespaces (`xmlns:bob`, `xmlns:bob2`, etc., where unfortunately for me, they are different, despite sharing many fields) make working with XML in Go simply unworkable.

This is not lost on the Go developers.  There are many tickets on the [Golang Issue board][issue_board] that explain that namespaces in XML just don't work that well or at all in some cases.  I've tried to reason out how Go would solve the issue of namespaces, and it just doesn't bode well.  The issue boils down to losing the underlying namespace types in the translation. 

Let's consider a small example:

```xml-dtd
<ser:binding type="SOAP" isSoap12="false" xsi:type="con:SoapBindingType" xmlns:con="http://www.bea.com/li/sb/services/bindings/config" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<!-- lots of nested items not really worth outlining -->
...
</ser:binding>
```

Now, I used a great tool (highly recommended if/when namespacing in Go becomes accessible) called [chidley][chidley] that will generate structs from  XML for you.  It was an incredibly useful time saver, at least until I got to what it generated in this instance:

```go
type Chiser_binding struct {
  Attr_con              string                `xml:"xmlns con,attr"`
  Attr_isSoap12         string                `xml:"isSoap12,attr"`
  Attr_type             string                `xml:" type,attr"`
  Attr_xsi_type         string                `xml:"http://www.w3.org/2001/XMLSchema-instance type,attr"`
  Attr_xsi              string                `xml:"xmlns xsi,attr"`
  Chicon_WSI_compliant 	*Chicon_WSI_compliant `xml:"http://www.bea.com/wli/sb/services/bindings/config WSI-compliant,omitempty"`
  Chicon_port           *Chicon_port          `xml:"http://www.bea.com/wli/sb/services/bindings/config port,omitempty"`
  Chicon_selector       *Chicon_selector      `xml:"http://www.bea.com/wli/sb/services/bindings/config selector,omitempty"`
  Chicon_wsdl           *Chicon_wsdl          `xml:"http://www.bea.com/wli/sb/services/bindings/config wsdl,omitempty"`
  XMLName               xml.Name              `xml:"http://www.bea.com/wli/sb/services binding.omitempty"`
}
```

You'll have to forgive some of the non-idiomatic Go that this generated (`golint` would have a field day with this thing), but the meat of the issue is that both the `Attr_type` and the `Attr_xsi_type` have the same XML-delineated tag.   It doesn't necessarily matter that they are in separate namespaces, because it looks the same to the Go unmarshaller for some reason.  In fact, if you were to try to parse this out with a given XML string, you'd get the following error:

```sh
xml_test.go:25: x.Chiser_binding field "Attr_type" with tag " type, attr"
conflicts with field "Attr_xsi_type" with tag 
"http://www.w3.org/2001/XMLSchema-instance type,attr" 
```

Here's an even smaller example that shows what is going on here:

```go
package main

import (
	"encoding/xml"
	"fmt"
)

type DataWithAttrs struct {
	Name    string `xml:"name,attr"`
	XsiName string `xml:"http://www.w3.org/2001/XMLSchema-instance name,attr"`
}

func main() {
	data := `<Person name="Bob" xsi:name="Jeff" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"></Person>`
	doc := &DataWithAttrs{}
	err := xml.Unmarshal([]byte(data), &doc)
	if err != nil {
		fmt.Printf("error: %v", err)
		return
	}
	fmt.Printf("data %+v", doc)
}

// error: main.DataWithAttrs field "Name" with tag "name,attr" conflicts with field "XsiName" with tag "http://www.w3.org/2001/XMLSchema-instance name,attr"
// Program exited.
```

Reference: https://play.golang.org/p/j8aIJtbwEm

I'm  not sure what the fix is for this, or how I could even rig Go's type system to comply with my somewhat convoluted demands.  I do have to say that I don't *enjoy working with* the XML that I'm parsing, but such is the real world with legacy systems that you're often thrown only a SOAP-based format and expected to **deal with it**.  Unfortunately in my case, I don't see how I can do that, as it appears that the namespace between `Attr_type` and `Attr_xsi_type` are different, yet the same.

Maybe if I have some time, I'll dig in to the `encoding/xml` package and figure out what could be done.  It seems pretty gnarly.



[issue_board]: https://github.com/golang/go/issues/13400	"encoding/xml: fix name spaces"
[chidley]: https://github.com/gnewton/chidley
