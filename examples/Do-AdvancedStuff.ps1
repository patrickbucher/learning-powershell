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
