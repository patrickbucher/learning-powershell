# Day 11

## 1

    > Get-Process | Format-Table -Property Name,Id,Responding -Wrap

## 2

    > Get-Process | Format-Table -Property Name,Id,@{l='VirtualMB';e={$_.vm/1MB}},@{l='PhysicalMB';e={$_.workingset/1MB}}

## 3

    > Get-Module | Format-Table -Property @{l='ModuleName';e={$_.Name}},@{l='ModuleVersion';e={$_.Version}}

## 4

    > Get-AzStorageAccount | Get-AzStorageContainer | Format-Table -GroupBy PublicAccess

## 5

    > Get-ChildItem -Directory | Format-Wide -Column 4

## 6

    > Get-ChildItem -File -Path $PSHOME | Where-Object -Property Name -Like -Value '*.dll' | Format-Table -Property Name,VersionInfo,@{Name='Size';Expression={$_.Length}}
