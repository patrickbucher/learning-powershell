# Day 17

## 1

    > Write-Output -InputObject (100*10)
    1000

## 2

    > Write-Host -Object (100*10)

## 3

    > $name = Read-Host "Name"
    Name: Patrick
    > Write-Host -Object $name -ForegroundColor yellow
    Patrick [in yellow]

## 4

    > Write-Output -InputObject (Read-Host -Prompt "Name") | Where-Object -Property Length -GT 5
