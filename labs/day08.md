# Day 8

## 1

    > Get-Command -Noun Random
    Get-Random

## 2

    > Get-Command -Noun Date
    Get-Date

## 3

    > Get-Date | Get-Member
    System.DateTime

## 4

    > Get-Date | Get-Member -MemberType Property
    DayOfWeek
    > Get-Date | Select-Object -Property DayOfWeek
    Sunday

## 5

    > Get-ChildItem . | Get-Member | Where-Object -Property Name -Like -Value *Time*
    CreationTime
    LastAccessTime
    LastWriteTime

## 6

    > Get-ChildItem . | Select-Object -Property Name,CreationTime,LastAccessTime,LastWriteTime | Sort-Object -Property CreationTime

## 7

    > Get-ChildItem . | Select-Object -Property Name,CreationTime,LastWriteTime | Sort-Object -Property LastWriteTime | ConvertTo-Csv | Out-File times.csv
    > Get-ChildItem . | Select-Object -Property Name,CreationTime,LastWriteTime | Sort-Object -Property LastWriteTime | ConvertTo-Html | Out-File times.html
