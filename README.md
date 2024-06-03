Notes on _Learn PowerShell in a Month of Lunches_ (4th Edition)

# Setup (Arch Linux)

Install the .NET Framework:

    # pacman -S dotnet-sdk

Install PowerShell as a .NET tool:

    $ dotnet tool install --global powershell

Make sure to extend your path variable to find the `pwsh` binary (e.g. in `~/.bashrc`):

    export PATH="$PATH:~/.dotnet/tools"

Reload the environment variables:

    $ source ~/.bashrc

Start PowerShell:

    $ pwsh

![How to Install PowerShell on Arch Linux](pics/install-powershell-on-arch-linux.png)

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

## Pipeline Parameter Binding

When the result from `Left-Command` is piped into `Right-Command` (such as in
`Left-Command | Right-Command`), PowerShell needs to figure out which parameter
of `Right-Command` can accept the object produced by `Left-Command`, for which
there are two strategies to be tried in the following order:

1. `ByValue`: The type of the output object from `Left-Command` is matched to
   the parameter types of `Right-Command`.
2. `ByPropertyName`: The output object of `Left-Command` has a property with
   the same name as a parameter of `Right-Command` that accepts pipeline input
   (see _Accept pipeline input?_ in the parameter's documentation). If there are
   multiple matching properties, all of them are used to exchange data from
   `Left-Command` to `Right-Command`.

If neither works, use _parenthetical commands_ instead:

    > Left-Command | Right-Command
    ERROR
    > Right-Command (Left-Command)
    OK

Use `Select-Object -ExpandProperty PROPERTY` to extract the content of a
property (i.e. its value) from an output object.

# Commands and Modules

Commands can be added by installing _modules_. The module _PowerShellGet_ manages modules from online repositories ("Galleries"), e.g. [PowerShellGallery](https://www.powershellgallery.com/). Make sure to check the compatibility under the section _PSEditions_ (e.g. _Core_) for each module. Modules can not only add commands, but also providers.

Repositories can be registered using the `Register-PSRepository` Cmdlet.

Modules have a _prefix_, e.g. `Az` for the `Azure` module. This prefix is used in the nouns of commands to avoid name conflicts. (Use fully qualified paths, such as `Module\Cmdlet` in case of a conflict.)

Install a Module (e.g. Azure, without confirmation prompt):

    > Install-Module -Name Az -Force

Check if the module was installed:

    > Get-Module -Name Az -ListAvailable

See `Update-Module` and `Remove-Module` for updating and removing a module, respectively.

Import the module into the current PowerShell session, or do so with a custom prefix:

    > Import-Module -Name Az
    > Import-Module -Name Az -Prefix Cloud

List the available commands (with paging):

    > Get-Command -Noun Az* | Out-Host -Paging

## Working with the Azure Module

Connect to an Azure account (opens browser):

    > Connect-AzAccount

If you have multiple subscriptions, use the `Select-AzSubscription` Cmdlet with
the `-SubscriptionName` parameter to pick one.

If you only have a single subscription, set it as the active context:

    > Get-AzSubscription | Select-Object Property Id | Set-AzContext

Register a resource provider for storage:

    > Register-AzResourceProvider -ProviderNamespace Microsoft.Storage

Get information about available locations:

    > Get-AzLocation | Select-Object -Property Location,DisplayName,Type,PhysicalLocation

Query existing resource groups within a location:

    > Get-AzResourceGroup -Location switzerlandnorth

Create a new resource group called `test`, if none exists:

    > New-AzResourceGroup -Location switzerlandnorth -Name test

Create a new storage account:

    > New-AzStorageAccount -ResourceGroupName test -Name patrickbucher -SkuName Standard_ZRS -Location switzerlandnorth

Remove a storage account (without confirmation):

    > Remove-AzStorageAccount -Name patrickbucher -ResourceGroupName test -Force

# Objects

A Cmdlet like `Get-Processes` shows a _collection_ of processes as a table. Each
table row represents an _object_ with various _members_—_properties_
(information about them) and _methods_ (actions to run on them). Every property
has a _value_.

There are usually more properties than are being shown in the console output.
(Pipe the result through a `ConvertTo-*` Cmdlet to see all properties.)

Inspect the members of an object, e.g. the current `Directory` (works on
single and multiple items):

    > Get-Item -Path . | Get-Member
    > Get-Item -Path . | Get-Member -MemberType Property

Members of the type _ScriptProperty_ are added dynamically by the running
PowerShell process.

Collections of objects can be sorted by a property:

    > Get-Process | Sort-Object -Property CPU
    > Get-Process | Sort-Object -Property CPU,ID -Descending

Properties can be extracted from objects:

    > Get-Process | Select-Object -Property Name,ID,CPU

Filter collections by the objects' properties:

    > Get-Process | Where-Object -Property Name -Eq -Value dotnet
    > Get-Process | Where-Object -Property Name -Like -Value pw*
    > Get-Process | Where-Object -Property CPU -GT -Value 10

The original objects (e.g. processes) are converted into generic `PSObject`
instances by such commands, which come with their own rules for output.

## Batch Cmdlets

Many Cmdlets (_Batch Cmdlets_) can deal with multiple inputs.

As the left command's output is consumed by the right command, it needs to be
explicitly passed through in order to become visible using the `-PassThru`
parameter:

    > Get-ChildItem folder | Copy-Item -Destination backup -PassThru

## Enumeration

Other Cmdlets can only deal with single inputs, and therefore the objects need
to be _enumerated_. This could either happen by the means of scripting, or by
using specialized Cmdlets. Consider a file containing patterns (`patterns.txt`):

    *.toml
    *.rs
    *.md

In order to filter the file names for _all_ those patterns, the `ForEach-Object`
Cmdlet can be used to enumerate them, invoking the `Get-ChildItem` Cmdlet in a
script block with every pattern, referred as `$_`:

    > Get-Content patterns.txt | ForEach-Object -Process { Get-ChildItem-Recurse ~/projects -Name $_ }

Instead of the (positional) `-Process` parameter, use `-Parallel` to execute the
script block concurrently:

    > Get-Content patterns.txt | ForEach-Object -Parallel { Get-ChildItem-Recurse ~/projects -Name $_ }

To measure execution time, surround the entire line in a script block, to be
called with `Measure-Command`:

    > Measure-Command { Get-Content … }

By default, no more than 5 processes are run in parallel. Use `-ThrottleLimit X`
to set the upper limit to `X`, for which the number of supported CPU threads is
a good setting.

# Formatting

Formatting options are configured in `*.format.ps1xml` files within the
PowerShell installation folder `$PSHome`. The `PSReadLine.format.ps1xml`
contains basic configuration of the shell (do not edit it, it's digitally
signed).

The Cmdlet `Get-FormatData` shows mappings of `TypeNames` to
`FormatViewDefinition`. Use the `Update-TypeData` Cmdlet to add definitions,
using the `-Path` parameter to specify an XML file containing the custom
format rules.

Cmdlets with the `Out` don't work with standard objects, but pass them to the
formatting system for conversion.

Objects with up to four properties are displayed as a table. If more properties
are to be formatted, they are shown as a list of key-value pairs. (Note that the
table headers may differ from property names.)

For better control of the output, use the `Format-*` Cmdlets:

1. `Format-Table`: tabular output
    - `-Property`: specify the output columns
        - `Get-Process | Format-Table -Property Name,CPU,VM`
    - `-GroupBy`: show multiple tables grouped by a property (the input should
      already be sorted by that particular property)
        - `Get-Process | Sort-Object -Property PriorityClass | Format-Table -GroupBy PriorityClass`
    - `-Wrap`: wrap cell content instead of abridging it with an ellipsis (`…`)
2. `Format-List`: list output
3. `Format-Wide`: output list items with single property in multiple columns
    - `-Col`: number of columns
        - `Get-Process | Format-Wide -Property Name -Col 5`

Make sure the `Format-` Cmdlet is the last one in the pipeline (except for an
additional `Out-` Cmdlet); processing formatted input will cause trouble
otherwise.

Do not mix up multiple kinds of objects when formatting, unless respective
formatting rules have been put in place.

Use hash tables to map custom headers to columns (e.g. the `Id` property of the
process to the header `PID`):

    > Get-Process | Format-Table -Property Name,@{name='PID',expression={$_.Id}},CPU

The hash table accepts additional properties such as `formatstring` and `align`.

For graphical output, use the `Out-GridView` Cmdlet from the
`Microsoft.PowerShell.GraphicalTools` module.

# Filtering & Comparison

Results can be filtered either _left_ by instructing the Cmdlet to do so by
various properties (e.g. `-Name`), or _right_ by filtering the output of a
Cmdlet through an additional piped Cmdlet. _Filter left_ or _early filtering_ is
usually more efficient and therefore should be preferred to _filter right_.

The `Where-Object` (aliased as `where`) offers powerful filtering facilities
with its `-FilterScript` (positional) parameter, which can be applied to the
piped-in object, referred to as `$_`:

- `-Eq`: test for equality
- `-Ne`: test for inequality
- `-Gt`/`-Lt`: greater/less than
- `-Ge`/`-Le`: greater/less than or equal to
- `-Ceq`, `-Cne`, `-Cgt`, `-Clt`, `-Cge`, `-Cle`: case-sensitive variants of
  above parameters for string comparisons
- `-Like`/`-NotLike`: pattern matching (`*`, `?`, etc.)
- `-CLike`/`-CNotLike`: pattern matching, but case-sensitive
- `-Match`/`-NotMatch`: matching against a regular expression
- `-CMatch`/`-CNotMatch`: case sensitive matching against a regular expression
- `-And`/`-Or`/`-Not`: logical operations to combine or negate expressions

# Remoting

A PowerShell Cmdlet can be executed on a remote computer `HOSTNAME` as follows:

    Invoke-Command -ComputerName HOSTNAME

On Windows, remoting works over WSMan (Web Services for Management) via
HTTP/HTTPS, run by Windows Remote Management (WinRM) for Windows.

On Linux and macOS, remoting works over SSH.

Objects are serialized/deserialized through XML over the network; therefore,
methods/actions are not supported, but all data can be inspected on a remote
computer.

TODO: continue with chapter 13 (13.2, p. 159)

- PSRP: PowerShell Remoting Protocol

# Multitasking and Background Jobs

PowerShell commands are executed synchronuously, i.e. the shell is blocked until
a command has finished its execution. However, commands can be moved into the
background for asynchronuous execution, allowing the user to interact with the
shell while another command is executing. Only commands running synchronuously
can be interactive; commands running asynchronuously must be provided with all
required input as they are run.

Commands running the background are referred to as _jobs_.

Start a job (with a custom name):

    > Start-Job -ScriptBlock { Get-Date | Out-File -Path date.txt }
    > Start-Job -Name WriteDateJob -ScriptBlock { Get-Date | Out-File -Path date.txt }

Specify `-FilePath` instead of `-ScriptBlock` to run a script from a file. The
`-WorkingDirectory` can also be specified.

A job is run in its own process. The `Start-ThreadJob` Cmdlet runs a script in a
separate thread within the current process:

    > Start-ThreadJob -ScriptBlock { Get-Date | Out-File -Path date.txt }

By default, no more thread jobs than 10 can be run. Pass the `-ThrottleLimit`
parameter to the `Start-ThreadJob` Cmdlet to override this limit.

Thread jobs start up faster and have less overhead than regular jobs, but slow
down the current shell process. Use thread jobs for short-lived, quick tasks;
use regular jobs for long-running, heavy tasks.

To start jobs remotely, use the `Invoke-Command` Cmdlet together with the
`-AsJob` (and optionally the `-JobName`) parameter. Many other Cmdlets, such as
`New-AzVM`, support the `-AsJob` parameter, too.

The current shell's jobs can be listed using the `Get-Job` Cmdlet. Pass the
`-Id` parameter to see the job details:

    > Get-Job -Id 1 | Format-List

The output of a job can be received using the `Receive-Job` Cmdlet. This output
will be consumed, unless the `-Keep` parameter is specified.

    > Start-Job -ScriptBlock { Write-Output "Hello, Job!" } | Select-Object -Property Id
    12
    > Receive-Job -Id 12 -Keep
    Hello, Job!
    > Receive-Job -Id 12
    Hello, Job!
    > Receive-Job -Id 12
    [nothing]

A job that started other jobs refers to them in its `ChildJobs` property. Those
jobs can be inspected by their name:

    > Get-Job -Id 7 | Select-Object -Property ChildJobs
    {Job8}
    > Get-Job -Name Job8

Use the following Cmdlets to manage jobs:

- `Remove-Job`: delete a job
- `Stop-Job`: terminate a stuck job
- `Wait-Job`: move a running job back to the foreground

Remove all completed jobs:

    > Get-Job | Where-Object -Property State -Eq -Value Completed | Remove-Job

Stop all blocked jobs:

    > Get-Job | Where-Object -Property State -Eq -Value Blocked | Stop-Job

Await all pending jobs:

    > Get-Job | Wait-Job

# Variables

The `Get-Member` Cmdlet shows the `TypeName` of an object:

    > Write-Output "hello" | Get-Member
    TypeName: System.String

Values can be stored in variables, prefixed with a sigil (`$`):

    > $name = "Joe"

Variable names can constist of letters, numbers, underscores, and even—god
forbid—spaces, for which the name has to be written in curly braces:

    > ${full name} = "Joe Doe"
    > Write-Output ${full name}
    Joe Doe

Variables are expanded within double quotes, but not so within single quotes:

    > $now = (Get-Date)
    > Write-Output 'now is $now'
    now is $now
    > Write-Output "now is $now"
    now is 05/29/2024 21:48:57

The backtick can be used as an escape character, e.g. to escape the sigil, and
to encode characters such as tabs or newline:

    > Write-Output "`$now`tis`n$now"
    $now	is
    05/29/2024 21:48:57

Variables can store multiple items when assigned a comma-separated list, which
are stored as arrays with a zero-based index (0 is the first, -1 the last
element):

    > Write-Output $names
    Alice
    Bob
    Charlene
    > Write-Output $names[0]
    Alice
    > Write-Output $names[-1]
    Charlene
    > Write-Output $names.Count
    3

Use a _subexpression_ `$()` for advanced expansion within double quotes:

    > Write-Output "The first name is $($names[0])"
    The first name is Alice

Properties and methods can be accessed directly on the variable:

    > $drink = 'Beer'
    > $drink.Replace('ee', 'ie')
    Bier

Arrays can be enumerated using the `ForEach-Object` Cmdlet:

    > $names | ForEach-Object { $_.ToUpper() }
    ALICE
    BOB
    CHARLENE

If a member isn't found on the collection itself but on the individual items,
PowerShell _unrolls_ the access to the elements of the collection:

    > $names.ToUpper()
    ALICE
    BOB
    CHARLENE

![Talking about type systems…](pics/seriously.png)

Variables can be coerced into types, e.g. when reading input interactively from
the user using the `Read-Host` Cmdlet:

    > $name = Read-Host "Name"
    Name: Joe
    > [int]$age = Read-Host "Age"
    Age: 13

Unlike the string `$name`, `$age` can be used for arithmetic:

    > $name * 3
    JoeJoeJoe
    $ $age * 3
    39

The variable `$name` has the type `System.String`, whereas `$age` was coerced
into `System.Int32`.

An error will be thrown if the coercion doesn't work:

    > [int]$age = Read-Host "Weight"
    Weight: average
    MetadataError: Cannot convert value "average" to type "System.Int32"

Commonly used types are:

- `[int]`: integer numbers
- `[single]` and `[double]`: single and double precision floating point numbers
- `[string]`: strings of characters
- `[char]`: a single character
- `[xml]`: an XML document

Variables can also be dealt with using the following Cmdlets:

- `New-Variable`
- `Set-Variable`
- `Remove-Variable`
- `Get-Variable`
- `Clear-Variable`

## Common Variables

- `$PSVersionTable`: version information
- `$PSModulePath`: paths where modules are stored
- `$_`: piped-in object
- `$PSHome`: installation folder

# Input and Output

Interactive input can be obtained using the `Read-Host` Cmdlet:

    > $input = Read-Host -Prompt "What's your name?"

Output can be produced using the `Write-Host` Cmdlet:

    > Write-Host -Object "Hello, World!"

Foreground and background colors can be specified:

    > Write-Host -ForegroundColor red -BackgroundColor yellow -Object "Nice!"

Use the `Write-Verbose` Cmdlet for messages that are not crucial for the user,
which is only displayed if the `$VerbosePreference` variable is set to
`"Continue"`:

    > $VerbosePreference = "Continue"
    > Write-Verbose -Message "ok, fine
    VERBOSE: ok, fine

The same mechanism works for the `Write-Warning` Cmdlet in accordance with the
`$WarningPreference` variable.

`Write-Host` sends objects to the output, whereas `Write-Output` sends objects
to the pipe:

    > Write-Host -InputObject "Hello"
    Hello
    > Write-Host -InputObject "Hello" | Select-Object -First 1
    Hello
    > Write-Host -InputObject "Hello" | Select-Object -First 0
    [nothing]
    > Write-Host -Object "Hello" | Select-Object -First 0
    Hello

There are a couple of `Write-*` Cmdlets with according variables (and default
values) that deal with different kinds of messages:

- `Write-Warning` with `$WarningPreference` (default: `Continue`)
- `Write-Verbose` with `$VerbosePreference` (default: `SilentlyContinue`)
- `Write-Debug` with `$DebugPreference` (default: `SilentlyContinue`)
- `Write-Error` with `$ErrorActionPreference` (default: `Continue`)
- `Write-Information` with `$InformtionPreference` (default: `SilentlyContinue`)

The value `Continue` produces, whereas `SilentlyContinue` suppresses output.

The `Write-Progress` Cmdlet can display progress bars.

# Scripting

## Documentation and Parametrized Scripts

Define documentation for the script within `<#` and `#>`. Define parameters for
the script within a `param` block (`examples/Say-Hello.ps1`):

```powershell
<#
.SYNOPSIS
Say-Hello greets the user.
.DESCRIPTION
The user is greeted with the string "Hello", followed by either the provided
name, or by the name "Anonymous.
.PARAMETER Name
The name of the user to be greeted. Default: Anonymous.
#>
Param (
    $Name = 'Anonymouns'
)
Write-Host -Message "Hello, $Name."
```

Usage:

    > Say-Hello
    Hello, Anonymouns.
    > Say-Hello -Name Joe
    Hello, Joe.

## Advanced Scripts

Use the `[CmdletBinding()]` attribute as the first line (after the
documentation) for the script to unlock various features, such as automatic
parameters like `-Verbose`, which enable verbose output of the `Write-Verbose`
Cmdlet regardless of the `$VerbosePreference` setting.

Use the `[Parameter]` attribute for various purposes:

- `[Parameter(Mandatory=$True)]`: Prompts the user interactively for the
  respective parameter if it isn't provided on the command line.
- `[Parameter(HelpMessage="…")]`: Provides a help message for the respective
  parameter.

The `[Alias('Foo')]` attribute allows to use `Foo` as an alternative name for
the respective parameter.

A set of valid values (e.g. `1`, `2`, and `3`) can be provided using the
`[ValidateSet(1,2,3)]` attribute.

Example (`examples/Do-AdvancedStuff.ps1`):

```powershell
<#
.SYNOPSIS
Demonstrate advanced scripting features.
.DESCRIPTION
Prompts for the FirstName and a Choice of flavour, which will be printed.
.PARAMETER FirstName
The first name of the user picking a flavour.
.PARAMETER Choice
The flavour of the user's choice: 1 for chocolat, 2 for strawberry, and 3 for banana.
.EXAMPLE
Do-AdvancedStuff -Name Joe -Choice 1
#>
[CmdletBinding()]
Param (
    [Alias('Name')]
    [Parameter(Mandatory=$True, HelpMessage="The name of the subject at the keyboard.")]
    [string]$FirstName,

    [ValidateSet(1,2,3)]
    [Parameter(Mandatory=$True, HelpMessage="1) chocolat, 2) strawberry, 3) banana")]
    [int]$Choice
)

Write-Verbose -Message "Entering…"
Write-Host -Message "You are $FirstName and like option $Choice."
Write-Verbose -Message "Exiting…"
```

Usage:

    > ./Do-AdvancedStuff.ps1 -FirstName Joe -Choice 1
    You are Joe and like option 1.
    > ./Do-AdvancedStuff.ps1 -Name Joe -Choice 1
    > ./Do-AdvancedStuff.ps1
    FirstName: Jane
    Choice: 2
    You are Jane and like option 2.
    > ./Do-AdvancedStuff.ps1 -Name Jack -Choice 3 -Verbose
    VERBOSE: Entering…
    You are Jack and like option 3.
    VERBOSE: Exiting…

## Best Practices

- Pick variable names similar to the parameters they are being used for. (E.g.
  `$path` to be used with `-Path`.)
- For command sequences connected by pipes, insert a newline after the pipe for
  better readability and shorter lines.
- Escape line breaks now following pipes with the backtick character.
- Write out the full command an parameter names instead of relying on aliases,
  abbreviations, and positional parameters. This will render the script easier
  readable.
- Prefer object output over pre-formatted output, for it makes the processing of
  the script's result easier downstream.

# Regular Expressions

Use `-Match` and its case-sensitive counterpart `-CMatch` to test a value
against a regular expression (e.g. to check if could be an IP address):

    > "127.0.0.1" -Match '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}'
    True
    > "1.2.3.4" -Match '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}'
    True
    > "localhost" -Match '\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}'
    False

Provide the `Select-String` Cmdlet with a regex `-Pattern`:

    $pattern = "(\d{1,3})\.(\d{1,3})\.(\d{1,3})\.(\d{1,3})"
    $ip = "127.0.0.1"
    > (Select-String -InputObject $ip -Pattern $pattern).Matches.Groups |
    >> Select-Object -Property Value

    Value
    -----
    127.0.0.1
    127
    0
    0
    1

# Miscellaneous

- Powershell 5.1 is called "Windows PowerShell" and has the binary
  `powershell.exe` and a blue background by default.
- Powershell 7.x is called "PowerShell" and has the binary `pwsh.exe` and a
  black background by default.
- ISE: Integrated Scripting Environment (host application), outdated; use Visual
  Studio Code with the PowerShell extension instead

## Recipies

Compressing and uncompressing archives:

    > Compress-Archive -Path foo -DestinationPath foo.zip
    > Expand-Archive -Path foo.zip -DestinationPath foo_copy

Measure execution time:

    > Measure-Command { foobar.exe }

Get the fully qualified type name of an object (e.g. a date):

    > (Get-Date).GetType().FullName

Find the full command name of an alias (e.g. `cd`):

    > Get-Alias | Where-Object -Property Name -Like -Value cd*

### YAML

Install a YAML module (`ConvertFrom-Yaml` and `ConvertTo-Yaml` Cmdlets):

    > Install-Module -Name Powershell-YAML -Force

Convert a YAML file to JSON:

    > Get-Content foo.yaml | ConvertFrom-YAML | ConvertTo-Json -Depth 100

### Hash Tables

    > @{name='Alice', age=37}

### Windows Cleanup

Open PowerShell as Admin.

Load the `Appx` module:

    > Import-Module -Name Appx -UseWindowsPowerShell

List the names of installed Appx packages:

    > Get-AppxPackage -AllUsers | Select-Object -Property Name

### Activate Unicode Input via Registry

Switch to the registry (`HKEY_CURRENT_USER`):

    > Set-Location -Path hkcu:

Show input method entries:

    > Get-ChildItem '.\Control Panel\Input Method\'

If `EnableHexNumpad` is not yet set to `1`, set it accordingly (use `-Type String` to get a `REG_SZ` value):

    > Set-ItemProperty -Path '.\Control Panel\Input Method\' -PSProperty EnableHexNumpad -Value 1 -Type String

Uninstall the worst offenders:

    > Remove-AppxPackage -Name *Xbox* | Remove-AppxPackage
    > Remove-AppxPackage -Name *Zune* | Remove-AppxPackage
    > Remove-AppxPackage -Name *YourPhone* | Remove-AppxPackage
    > Remove-AppxPackage -Name *Skype* | Remove-AppxPackage
