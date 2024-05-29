# Day 16

## 1

    > Start-Job -ScriptBlock { Get-Process | Where-Object -Property Name -Like 'pwsh*' }
    Job1

## 2

    > $result = Receive-Job -Name Job1 -Keep

## 3

    > Write-Output $result

## 4

    > Write-Output $result | Export-Clixml -Path result.xml

## 5

    > $processes = Get-Service

## 6

    > $processes = Get-Service -Name bits,spooler

## 7

    > Write-Output $processes

## 8

    > Write-Output $processes | Export-Csv -Path processes.xml
