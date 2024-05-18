Notes on _Learn PowerShell in a Month of Lunches_ (4th Edition)

# Variables

- `$PSVersionTable`: version information

# Help

Update the help files (takes a shitload of time):

    Update-Help

Same, but in English (gives you a complete help):

    Update-Help -UICulture en-US

Save the help to `DIRECTORY` (a.k.a. take a huge XML dump):

    Save-Help -DestinationPath DIRECTORY -UICulture en-US

Show help (not paged):

    Get-Help TOPIC

Show help (paged):

    Help TOPIC

Also accepts wildcards:

    Help *foo*

Show _full_ help:

    Help -Full TOPIC

Show help online (i.e. in a browser):

    Help -Online TOPIC

Show example section of help:

    Help -Example TOPIC

List all commands:

    Get-Command

List all commands for a noun/verb:

    Get-Command -Noun NOUN
    Get-Command -Verb VERB

# Running Commands

There are different kinds of commands:

- Cmdlet ("command-let"): PowerShell command-line utilities written in a .Net-Language (e.g. C#)
- Function: piece of code written in PowerShell
- Application: executable written in any language

Scripts have the `.ps1` extension.

Command names are all case _insensitive_ and follow the convention `[Verb]-[Noun]`. (See `Get-Verb` for conventionally used "verbs".)

The invocation operator `&` can run a command with a name stored in a variable:

    $cmd = 'ping'
    & $cmd google.com

The operator `%-- [...]` prevents parsing of `[...]`.

## Execution Policy

Policies (set machine-wide) protect the user from _accidentally_ running harmful scripts:

- `Restricted` (default on Windows 10): no script execution allowed
- `RemoteSigned` (default on Windows Server): all local script and signed remote script execution allowed
- `AllSigned` (stricter): signed script execution allowed
- `Unrestricted`: all script execution allowed
- `Bypass`: for embedded PowerShell use

Commands:

- `Get-ExecutionPolicy`
- `Set-ExecutionPolicy` (only as Admin)

The PowerShell can be started with the `-ExecutionPolicy POLICY` option.

The Execution Policy can also be configured by a Group Policy Object (GPO).

## Aliases

Aliases only emcompass the command, but no parameters. (There are parameter aliases, too: see `Get-Help about_CommonParameters`.)

- `New-Alias`: create a new temporary alias (for the current session)
- `Export-Alias`: export aliases
- `Import-Alias`: import aliases

## Positional Parameters

Any parameter with its name surrounded in `[]` in the help text is a positional parameter:

    Get-Foo [[-Param] ...]

# Provider

A _Provider_ (Noun: `PSProvider`) is an _adapter_ from a _data storage_ to a virtual _disk drive_.

- `Get-PSProvider`: lists the providers
- `Get-PSDrive`: list the virtual drives (mount points for data storage)

Providers (with drives) available by default are:

- `Registry`: `HKLM` (for `HKEY_LOCAL_MACHINE`), `HKCU` (for `HKEY_CURRENT_USER`) for the registry
- `Alias`: `Alias` for command alias names
- `Environment`: `Env` for environment variables
- `FileSystem`: `C`, `Temp` for the file system
- `Function`: `Function` for PowerShell functions
- `Variable`: `Variable` for PowerShell variables

Providers work with different kind of items (e.g. `FileSystem` with files and directories, `Environment` with environment variables).

- `Get-Command -Noun *item*`: lists all commands to deal with items
    - not all providers support all commands 
- Verbs for `Item` commands (with different meanings depending on the provider):
    - `Clear`
    - `Copy`
    - `Get`
    - `Move`
    - `New`
    - `Remove`
    - `Rename`
    - `Set`
- Nouns for `Item` commands:
    - `ItemProperty` (e.g. for files, but not for environment variables)
    - `ChildItem` (e.g. for directories, but not for files)

Wildcards (`*`: matching `0..n`, `?`: matching `0..1` characters) are supported in `-Path` parameters. Use `-LiteralPath` if the wildcards should _not_ be expanded.

## Examples (with Unix equivalents)

- `Set-Location -Path DRIVE:PATH`
    - `cd PATH`
- `New-Item FOLDER -ItemType Directory`
    - `mkdir FOLDER`
- `Get-ChildItem`
    - `dir`
- `Get-ChildItem Env:`
    - `env`
- `Set-Item -Path Env:/FOO -Value 123`
    - `export FOO=123`
- `Set-Location -Path HKCU:` move to `HKEY_CURRENT_USER` in registry
    - no Unix equivalent
- `Set-ItemProperty -Path dwm -PSProperty EnableAeroPeek -Value 0`: set `EnableAeroPeek` property of `dwm` registry key to `0`

# Pipelines

The _Pipe_ operator `|` in PowerShell can be used like its Unix Shell equivalent, but it forwards _objects_ rather than text.

## Examples (with Unix eqiuvalents, if applicable)

- `Get-ChildItem | Where-Object -Property Name -Eq 'README.md'`
    - `ls | grep '^README.md$'`
- `Get-ChildItem | Select-Object -Property Name`
    - think of a combination of `ls -l` and `cut`
    - alternative notation: `(Get-ChildItem).Name`
- `Get-ChildItem -Path .\labs\ | Select-Object -First 2`
    - `ls labs | head -2`

## Exporting/Importing and Converting Data

Several formats are allowed for `Export-*` and `Import-*` commands:

- `Export-Csv`/`Import-Csv`: Comma Separated Values
    - `-Delimiter ';'`: defines delimiter `;`
- `Export-Clixml`/`Import-Clixml`: Serialized Objects as XML

Use the `-IncludeTypeInformation` parameter to include type information, which allows for a nicely formatted output of an import later:

    > Get-ChildItem -Path .\labs\ | Export-Csv -IncludeTypeInformation -Path labs.csv
    > Import-Csv -Path labs.csv

More formats are supported via the `ConvertTo` verb, e.g.:

- `ConvertTo-Csv`
- `ConvertTo-Html`
- `ConvertTo-Json`
- `ConvertTo-Xml`

Examples:

    > Get-Item -Path README.md | ConvertTo-Json
    > Get-Item -Path README.md | ConvertTo-Html > readme.html

Not the _content_ is converted, but the Item as a PowerShell object, mind you!

## Output Redirection

The default output goes _formatted_ to the screen:

    > ... | Out-Default
    > ... | Out-Host

Without colors:

    > ... | Out-String

Discard output (equivalent to Unix: `> /dev/null`):

    > ... | Out-Null

Redirect to a file:

    > Get-ChildItem > foo.txt
    > Get-ChildItem | Out-File -Path foo.txt

Unlike the `>` operator, the `Out-File` Cmdlet supports various parameters (e.g. encoding).

## Confirmation

Both the running PowerShell (`$ConfirmPreference`) and each Cmdlet have their own _impact level_:

- If the Cmdlet's impact level is bigger/equal than the PowerShell's, the user is asked for confirmation.
- Otherwise, the Cmdlet is executed without further ado.
- Cmdlets support the `-Confirm` parameter to enforce confirmation.
- The `-WhatIf` parameter let's the Cmdlet run in _dry mode_, just showing the impact the Cmdlet would cause.

## Comparing Objects

Compare the PID (process id) of the running Notepad and Bash process:

    > Compare-Object -ReferenceObject (Get-Process -Name notepad) -DifferenceObject (Get-Process -Name bash) -Property Id

- `<=`: only on the left side (`-ReferenceObject`)
- `=>`: only on the right side (`-DifferenceObject`)

# Commands and Modules

Commands can be added by installing _modules_. The module _PowerShellGet_ manages modules from online repositories ("Galleries"), e.g. [PowerShellGallery](https://www.powershellgallery.com/). Make sure to check the compatibility under the section _PSEditions_ (e.g. _Core_) for each module. Modules can not only add commands, but also providers.

Repositories can be registered using the `Register-PSRepository` Cmdlet.

Modules have a _prefix_, e.g. `Az` for the `Azure` module. This prefix is used in the nouns of commands to avoid name conflicts. (Use fully qualified paths, such as `Module\Cmdlet` in case of a conflict.)

Modules are stored in one of the paths denoted by `$PSModulePath`.

Install a Module (e.g. Azure):

    > Install-Module -Name Az

Check if the module was installed:

    > Get-Module -Name Az -ListAvailable

See `Update-Module` and `Remove-Module` for updating and removing a module, respectively.

Import the module into the current PowerShell session, or do so with a custom prefix:

    > Import-Module -Name Az
    > Import-Module -Name Az -Prefix Cloud

List the available commands (with paging):

    > Get-Command -Noun Az* | Out-Host -Paging

# Recipies

Compressing and uncompressing archives:

    > Compress-Archive -Path foo -DestinationPath foo.zip
    > Expand-Archive -Path foo.zip -DestinationPath foo_copy

# Miscellaneous

- Powershell 5.1 is called "Windows PowerShell" and has the binary `powershell.exe` and a blue background by default.
- Powershell 7.x is called "PowerShell" and has the binary `pwsh.exe` and a black background by default.
- ISE: Integrated Scripting Environment (host application), outdated; use Visual Studio Code with the PowerShell extension instead
