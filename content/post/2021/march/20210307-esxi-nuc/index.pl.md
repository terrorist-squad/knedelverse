+++
date = "2021-03-07"
title = "Zainstaluj ESXi na komputerze NUC. Przygotuj pamięć USB za pomocą MacBooka."
difficulty = "level-4"
tags = ["esxi", "homelab", "hypervisor", "linux", "nuc", "vmware"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-esxi-nuc/index.pl.md"
+++
Dzięki ESXi, "intel NUC" może być podzielony na dowolną liczbę komputerów. W tym poradniku pokażę, jak zainstalowałem VMware ESXi na moim NUC-u.Mała uwaga wstępna: zalecam aktualizację BIOS-u przed instalacją ESXi. Potrzebna będzie również pamięć USB o pojemności 32 GB. Kupiłem cały pakiet za mniej niż 5 euro za sztukę z Amazon.
{{< gallery match="images/1/*.jpg" >}}
Mój NUC-8I7BEH ma 2x 16GB HyperX Impact Ram, 1x 256GB moduł Samsung 970 EVO M2 i 1TB 2,5-calowy dysk twardy WD-RED.
{{< gallery match="images/2/*.jpg" >}}

## Krok 1: Znajdź USB - Stick
Poniższe polecenie pokazuje mi wszystkie dyski:
{{< terminal >}}
diskutil list

{{</ terminal >}}
Tutaj możesz zobaczyć, że moja pamięć USB ma identyfikator "disk2":
{{< gallery match="images/3/*.png" >}}

## Krok 2: Przygotuj system plików
Teraz mogę użyć następującego polecenia, aby przygotować system plików:
{{< terminal >}}
$ diskutil eraseDisk MS-DOS "ESXI" MBR disk2

{{</ terminal >}}
Po tym, widzę również identyfikator w Finderze:
{{< gallery match="images/4/*.png" >}}

## Krok 3: Wysuń pamięć USB
Używam polecenia "unmountDisk", aby wysunąć wolumin:
{{< terminal >}}
$ diskutil unmountDisk /dev/disk2

{{</ terminal >}}
Zobacz:
{{< gallery match="images/5/*.png" >}}

## Krok 4: Zrób bootowalny stick
Teraz wpisujemy komendę "sudo fdisk -e /dev/disk2", a następnie wpisujemy "f 1", "write" i "quit", patrz:
{{< gallery match="images/6/*.png" >}}

## Krok 5: Kopiowanie danych
Teraz muszę pobrać ESXi-ISO: https://www.vmware.com/de/try-vmware.html. Po tym mogę zamontować ESXi-ISO i skopiować zawartość do pamięci USB.
{{< gallery match="images/7/*.png" >}}
Kiedy wszystko jest skopiowane, wyszukuję plik "ISOLINUX.CFG" i zmieniam jego nazwę na "SYSLINUX.CFG". Dodaję również "-p 1" do linii "APPEND -c boot.cfg".
{{< gallery match="images/8/*.png" >}}
ertig! Teraz kij jest zdatny do użytku. Miłej zabawy!
{{< gallery match="images/9/*.png" >}}