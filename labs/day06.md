# Day 6

## 1

File `data/a.txt`:

    This is a file.
    A real file.
    Like any other.

File `data/b.txt`:

    This is a file.
    A real file.
    Unlike the other.

    > Compare-Object -Reference (Get-Content data/a.txt) -Difference (Get-Content data/b.txt)

## 2

    > Get-Command | Export-Csv commands.csv | Out-File
    Out-File: Cannot process argument because the value of argument "path" is null. Change the value of argument "path" to a non-null value.

An output path (e.g. `-Path foo.txt`) needs to be defined.

## 3

A job can be stopped by `-Id`, by `-Name`, or by `-State`.

## 4

    > Get-Process -Name *thunder* | Export-Csv -Delimier '|' -Path procs.csv

## 5

    > Get-Process -Name *thunder* | Export-Csv -IncludeTypeInformation -Path typed.csv

## 6

    -NoClobber
    -Confirm

## 7

    -UseCulture