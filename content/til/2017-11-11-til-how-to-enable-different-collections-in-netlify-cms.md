---
draft: 'false'
title: 'TIL: How to enable different collections in Netlify CMS'
date: 2017-11-12T00:15:51.584Z
---
I have never really used NetlifyCMS for much other than the occasional entry here and there, but now that I am getting more comfortable with Hugo and entering in some data, I've had a chance to try some other things out.  One point in particular was adding in a whole blog entry setup `/til/` that will allow me to use the more short-form entries.

## Adding a Collection

Pretty easy, actually.  You just add another entry to your `collections` field:

```yaml
backend:
  name: github
  repo: klauern/blog
  branch: master

publish_mode: editorial_workflow
media_folder: "static/img/uploads"
public_folder: "/img/uploads"

collections:
  - name: "blog" # used in routes, e.g. /admin/collections/blog
    label: "Blog Entries" # Used in the UI
    folder: "content/blog" # The path to the folder where the documents are stored
    create: true # Allow users to create new documents in this collection
    slug: "{{year}}-{{month}}-{{day}}-{{slug}}" # Filename template i.e. YYYY-MM-DD-title.md
    fields: # The fields for each document, usually in front matter
      - {label: "Layout", name: "layout", widget: "hidden", default: "blog"}
      - {label: "Is Draft?", name: "draft", widget: "string", default: "false"}
      - {label: "Title", name: "title", widget: "string"}
      - {label: "Publish Date", name: "date", widget: "datetime"}
      - {label: "Body", name: "body", widget: "markdown"}
  - name: "til" # today I learned
    label: "Today I Learned"
    folder: "content/til"
    create: true
    slug: "{{year}}-{{month}}-{{day}}-{{slug}}" # Filename template i.e. YYYY-MM-DD-title.md
    fields: # The fields for each document, usually in front matter
      - {label: "Layout", name: "layout", widget: "hidden", default: "til"}
      - {label: "Is Draft?", name: "draft", widget: "string", default: "false"}
      - {label: "Title", name: "title", widget: "string"}
      - {label: "Publish Date", name: "date", widget: "datetime"}
      - {label: "Body", name: "body", widget: "markdown"}
```
