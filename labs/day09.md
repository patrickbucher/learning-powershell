# Day 9

Install and import the secret management module:

    > Find-Module -Name *SecretManagement*
    Microsoft.PowerShell.SecretManagement
    > Install-Module -Name Microsoft.PowerShell.SecretManagement -Force
    > Import-Module -Name Microsoft.PowerShell.SecretManagement

Inspect the module's commands:

    > Get-Module -Name Microsoft.PowerShell.SecretManagement | Select-Object -ExpandProperty ExportedCommands
    Get-Secret
    Set-Secret
    ...

Install and import the secret store module:

    > Install-Module -Name Microsoft.PowerShell.SecretStore -Force
    > Import-Module -Name Microsoft.PowerShell.SecretStore
    > Get-Module -Name Microsoft.PowerShell.SecretStore | Select-Object -ExpandProperty ExportedCommands
    > Set-SecretStorePassword
    Password: ********

Register secret store as vault:

    > Register-SecretVault -Name SecretStore -Module Microsoft.PowerShell.SecretStore

Create a secret (don't tell them!):

    > Set-Secret -Vault SecretStore -Name MyFavouriteBand -Secret 'Backstreet Boys'
    Vault Password: ********

Retrieve a secret (as plain text):

    > Get-Secret -Vault SecretStore -Name MyFavouriteBand -AsPlainText
    Backstreet Boys

Now they know…
