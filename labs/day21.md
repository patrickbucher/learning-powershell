# Day 21

## 1

    > Get-ChildItem -Recurse -Path /usr -File | Where-Object -Property Name -Match '\d{2}'

## 2

    > Get-Module | Where-Object -Property CompanyName -Match 'Microsoft' | Select-Object -Property Name,Version,Author,CompanyName

## 3

On Arch Linux (which I use, btw.):

    > (Get-Content /var/log/pacman.log | Select-String -Pattern 'installed (.+) ').Matches.Groups | Where-Object -Property Name -Eq 1 | Select-Object -Property Value

## 4

TODO: do on Windows

## 5

    > Get-Content /etc/hosts | Where-Object { $_ -Match '^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}' }
