# Day 23

## 1

    > $n = 0
    > foreach ($f in Get-ChildItem -Path ./labs/) { $n += $f.Name.Length }
    > Write-Host $n

## 2

    > Start-Process leafpad
    > do { Write-Host 'running'; Start-Sleep -Seconds 1 } while ((Get-Process).Name -Contains 'leafpad')
