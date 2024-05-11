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

# Miscellaneous

- Powershell 5.1 is called "Windows PowerShell" and has the binary `powershell.exe` and a blue background by default.
- Powershell 7.x is called "PowerShell" and has the binary `pwsh.exe` and a black background by default.
- ISE: Integrated Scripting Environment (host application), outdated; use Visual Studio Code with the PowerShell extension instead
