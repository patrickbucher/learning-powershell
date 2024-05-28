# Day 14

## 1

    > Start-Job -Name FindAllTextFiles -ScriptBlock { Get-ChildItem -Path / -Recurse -File -Name '*.txt' }

## 2

    > Invoke-Command -AsJob -ScriptBlock { ... } -Computername A,B,C,...

## 3

    > Receive-Job -Name FindAllTextFiles -Keep
