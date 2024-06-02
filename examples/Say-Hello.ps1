<#
.SYNOPSIS
Say-Hello greets the user.
.DESCRIPTION
The user is greeted with the string "Hello", followed by either the provided
name, or by the name "Anonymous.
.PARAMETER Name
The name of the user to be greeted. Default: Anonymous.
.EXAMPLE
Say-Hello -Name Joe
#>
Param (
    $Name = 'Anonymouns'
)
Write-Host -Message "Hello, $Name."
