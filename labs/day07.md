# Day 7

## 1

[PowerShellGallery](https://www.powershellgallery.com/)

    > Install-Module -Name PSWindowsUpdate -Force

## 2

    > Get-Module -Name PSWindowsUpdate -ListAvailable

## 3

    > Find-Module -Command Compress-Archive | Select-Object Name

## 4

    > Import-Module -Name PSWindowsUpdate

## 5

    > New-Item -ItemType Directory -Path .\TestFolder
    > foreach ($i in 1..10) { Write-Output "This is file number $i." | Out-File -Path .\TestFolder\$i.txt }

## 6

    > Compress-Archive -Path TestFolder -DestinationPath TestFolder.zip

## 7

    > Expand-Archive -Path TestFolder.zip -DestinationPath TestFolder2

## 8

    > Compare-Object
        -Reference (Get-ChildItem TestFolder | Select-Object -ExpandProperty Name)
        -Difference (Get-ChildItem TestFolder2 | Select-Object -ExpandProperty Name)