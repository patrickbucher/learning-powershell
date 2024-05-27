# Day 10

## 1

The command works, because `-Module` can deal with an array of arguments.

## 2

The command doesn't work, because `Get-Module` has a `Name` property, and `Get-Command` requires a `-Module` parameter.

## 3

The command would set the Azure subscription repeatedly, ending up with a state where the last subscription listed by `Get-AzSubscription` would be the active subscription.

## 4

    > Get-AzSubscription | Select-Object -First 1 | Select-AzSubscription

## 5

    > Select-AzSubscription (Get-AzSubscription | Select-Object -First 1)

## 6

The command doesn't work, because `Set-AzContext` has no positional parameters or parameters with pipeline binding, and the value being piped-in has no property name.