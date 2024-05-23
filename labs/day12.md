# Day 12

## 1

    > Get-Command -Module PSReadLine

## 2

    > Get-Command -Module PSReadLine -Verb Get

## 3

    > Get-ChildItem -File -Recurse -Path /usr/bin | Where-Object -FilterScript {$_.Size -Gt 5MB}

## 4

    > Find-Module -Name PS* | Where-Object -Property Author -Like Microsoft*

## 5

    > Get-ChildItem -Path . -Recurse | Where-Object -FilterScript {$_.LastWriteTime -Gt (Get-Date).AddDays(-7)}

## 6

    > Get-Process | Where-Object -FilterScript {$_.Name -Eq 'pwsh' -Or $_.Name -Eq 'bash'}
