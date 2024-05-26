# Day 15

## 1

    > Get-ChildItem | Get-Member | Where-Object -Property Name -Like *Delete*
    Delete()

## 2

    > Get-Process Get-Member -MemberType Method
    Kill

## 3

    > Remove-Item -Path *deleteme* -Recurse
    > Get-ChildItem -Recurse -Name *deleteme* | Remove-Item
    > Get-ChildItem -Recurse -Name *deleteme* | ForEach-Object -Process { Remove-Item $_ }

## 4

    > Get-Content computers.txt | ForEach-Object { Write-Output $_.ToUpper() }
