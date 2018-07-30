---
draft: 'false'
title: Configure a custom path for PowerShell Modules
date: 2018-03-23T20:00:00.000Z
---
At work, my laptop is configured to share it's `Documents` folder on a remote share (probably for ease of use in the network).  This is fine, but it does introduce a noticeable delay for starting every new PowerShell prompt.  To speed this up, you can follow a link to "move" your Documents folder to another location, but that is if you have access to do that.  As my Documents folder is managed by my company's IT, it's hard-coded to a Universal Network Controller (UNC) share: `//some/server/path/here`

However, all is not lost.  You can still re-point where your modules are sourced from.  There is an environment variable called `$env:PSModulePath` which
stores the locations of modules that you have.  From the documentation:

> By default, the **PSModulePath** environment variable value contains the following system and user module directories, but you can add to and edit the value.
>
> * `$PSHome\Modules (%Windir%\System32\WindowsPowerShell\v1.0\Modules)`
> * `$Home\Documents\WindowsPowerShell\Modules (%UserProfile%\Documents\WindowsPowerShell\Modules)`
> * `$Env:ProgramFiles\WindowsPowerShell\Modules (%ProgramFiles%\WindowsPowerShell\Modules)`
>

We can override this in our system environment variables, which will point it to a location of our choosing.

    > [System.Environment]::SetEnvironmentVariable('PSModulePath', 'C:\tools\PowerShellModules\')

Unfortunately, you can't install modules if you override your original home:

```
PackageManagement\Install-Package : Unable to find module providers (PowerShellGet).
At C:\Program Files\WindowsPowerShell\Modules\PowerShellGet\1.0.0.1\PSModule.psm1:1809 char:21
+ ...          $null = PackageManagement\Install-Package @PSBoundParameters
+                      ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : InvalidArgument: (Microsoft.Power....InstallPackage:InstallPackage) [Install-Package], Exception
    + FullyQualifiedErrorId : UnknownProviders,Microsoft.PowerShell.PackageManagement.Cmdlets.InstallPackage
```

But, again, there's another **simple** fix.  You can use [`Save-Module`][2] to store it to a path, which will allow it to load successfully Here's an example of saving the `posh-git` module to this location:

```
Save-Module -Name posh-git -Path C:\tools\PowerShellModules\
```

* [Installing a PowerShell Module][1]
* [Save-Module][2]


[1]: https://msdn.microsoft.com/en-us/library/dd878350(v=vs.85).aspx
[2]: https://docs.microsoft.com/en-us/powershell/module/powershellget/save-module?view=powershell-6
