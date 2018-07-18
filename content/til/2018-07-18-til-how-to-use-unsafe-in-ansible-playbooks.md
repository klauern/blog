---
draft: 'false'
title: 'TIL: How to use ''!unsafe'' in Ansible Playbooks'
date: '2018-07-18T06:37:39-05:00'
---
This is a really short one, but useful.

# Scenario

You are a developer working with [Ansible](https://docs.ansible.com/) and you have to do some kind callout to Docker using native syntax.  The `docker-py` module that is normally used for Docker-based operations is unavailable on the target server, so you're forced to use simple `shell` callouts.

# Problem

How do you use Go templates with the `--format` flag that is present in most (all?) Docker commands?

# Solution

Use the [!unsafe](https://docs.ansible.com/ansible/latest/user_guide/playbooks_advanced_syntax.html#unsafe-or-raw-strings) directive in a variable.

Here's a simple solution:

```yml
---
- hosts: all  
  vars:    
    storage_driver_cmd: !unsafe docker system info --inspect '{{.Driver}}'  
    expected_storage_driver: devicemapper
  tasks:
  - name: get the storage driver from the host
    shell: "{{ storage_driver_cmd }}"
    register: driver_output
    failed_when: expected_storage_driver not in driver_output.stdout
```

# Explanation

The `!unsafe` flag is used in variable replacement to _prevent_ interpretation of strings that might be confused with Jinja-style templating.  In Docker, it makes heavy use of [Go templating](https://golang.org/pkg/text/template/), which uses the `{{ }}` curly braces to perform variable substitution.  We can't simply throw that in with our Jinja templates, so we must first save off the string we want to call in an `!unsafe`-stored variable, and then we can use that in all of our playbooks.

Neat!
