+++
date = "2021-03-07"
title = "Zainstaluj ESXi na komputerze NUC. Przygotuj pamięć USB za pomocą komputera MacBook."
difficulty = "level-4"
tags = ["esxi", "homelab", "hypervisor", "linux", "nuc", "vmware"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-esxi-nuc/index.pl.md"
+++
Dzięki ESXi "intel NUC" może zostać podzielony na dowolną liczbę komputerów. W tym poradniku pokażę, jak zainstalowałem VMware ESXi na moim NUC-u.Mała uwaga wstępna: przed instalacją ESXi zalecam aktualizację BIOS-u. Potrzebna będzie także pamięć USB o pojemności 32 GB. Kupiłem cały pakiet za mniej niż 5 euro za sztukę w sklepie Amazon.
{{< gallery match="images/1/*.jpg" >}}
Mój NUC-8I7BEH ma 2x 16 GB HyperX Impact Ram, 1x 256 GB moduł Samsung 970 EVO M2 i 1 TB 2,5-calowy dysk twardy WD-RED.
{{< gallery match="images/2/*.jpg" >}}

## Krok 1: Znajdź pamięć USB
Poniższe polecenie pokazuje wszystkie dyski:
{{< terminal >}}
diskutil list

{{</ terminal >}}
Widać tu, że moja pamięć USB ma identyfikator "disk2":
{{< gallery match="images/3/*.png" >}}

## Krok 2: Przygotowanie systemu plików
Teraz mogę użyć następującego polecenia, aby przygotować system plików:
{{< terminal >}}
$ diskutil eraseDisk MS-DOS "ESXI" MBR disk2

{{</ terminal >}}
Następnie identyfikator jest widoczny także w Finderze:
{{< gallery match="images/4/*.png" >}}

## Krok 3: Wysuń pamięć USB
Do usunięcia woluminu używam polecenia "unmountDisk":
{{< terminal >}}
$ diskutil unmountDisk /dev/disk2

{{</ terminal >}}
Zobacz:
{{< gallery match="images/5/*.png" >}}

## Krok 4: Przygotuj nośnik startowy
Teraz wpisujemy polecenie "sudo fdisk -e /dev/disk2", a następnie wpisujemy "f 1", "write" i "quit", zob:
{{< gallery match="images/6/*.png" >}}

## Krok 5: Kopiowanie danych
Teraz muszę pobrać ESXi-ISO: https://www.vmware.com/de/try-vmware.html. Następnie mogę zamontować ESXi-ISO i skopiować jego zawartość do pamięci USB.
{{< gallery match="images/7/*.png" >}}
Gdy wszystko zostanie skopiowane, wyszukuję plik "ISOLINUX.CFG" i zmieniam jego nazwę na "SYSLINUX.CFG". Dodałem także "-p 1" do wiersza "APPEND -c boot.cfg".
{{< gallery match="images/8/*.png" >}}
ertig! Teraz drążek nadaje się do użytku. Miłej zabawy!
{{< gallery match="images/9/*.png" >}}
