# Day 5

## 1

    > New-Item -ItemType Directory -Path Labs

## 2

    > New-Item -ItemType File -Path Labs/Test.txt

## 3

    > Set-Item -Path Labs/Test.txt -Value -TESTING
    Set-Item: Provider operation stopped because the provider does not support this operation.

## 4

    > Get-Item -Path Env:/PATH

## 5

    > Help Get-ChildItem -Parameter Filter
    > Help Get-ChildItem -Parameter Include
    > Help Get-ChildItem -Parameter Exclude

`Filter` accepts a single pattern, whereas `Include` and `Exclude` both accept an array of string patterns to be matched or not matched, respectively.