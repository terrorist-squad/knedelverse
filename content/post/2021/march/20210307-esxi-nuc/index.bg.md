+++
date = "2021-03-07"
title = "Инсталиране на ESXi в NUC. Подгответе USB стик чрез MacBook."
difficulty = "level-4"
tags = ["esxi", "homelab", "hypervisor", "linux", "nuc", "vmware"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-esxi-nuc/index.bg.md"
+++
С ESXi "intel NUC" може да бъде разделен на произволен брой компютри. В този урок показвам как инсталирах VMware ESXi на моя NUC.Малко предисловие: препоръчвам актуализация на BIOS преди инсталацията на ESXi. Необходима ви е и 32-гигабайтова USB памет. Купих си цял пакет за по-малко от 5 евро всеки от Amazon.
{{< gallery match="images/1/*.jpg" >}}
Моят NUC-8I7BEH има 2x 16GB HyperX Impact Ram, 1x 256GB Samsung 970 EVO M2 модул и 1TB 2,5-инчов твърд диск WD-RED.
{{< gallery match="images/2/*.jpg" >}}

## Стъпка 1: Намерете USB - стик
Следната команда ми показва всички устройства:
{{< terminal >}}
diskutil list

{{</ terminal >}}
Тук можете да видите, че моята USB памет има идентификатор "disk2":
{{< gallery match="images/3/*.png" >}}

## Стъпка 2: Подготовка на файловата система
Сега мога да използвам следната команда, за да подготвя файловата система:
{{< terminal >}}
$ diskutil eraseDisk MS-DOS "ESXI" MBR disk2

{{</ terminal >}}
След това виждам идентификатора и във Finder:
{{< gallery match="images/4/*.png" >}}

## Стъпка 3: Изваждане на USB стик
Използвам командата "unmountDisk", за да извадя тома:
{{< terminal >}}
$ diskutil unmountDisk /dev/disk2

{{</ terminal >}}
Вижте:
{{< gallery match="images/5/*.png" >}}

## Стъпка 4: Направете флашката зареждаема
Сега въвеждаме командата "sudo fdisk -e /dev/disk2" и след това въвеждаме "f 1", "write" и "quit", вж:
{{< gallery match="images/6/*.png" >}}

## Стъпка 5: Копиране на данни
Сега трябва да изтегля ESXi-ISO: https://www.vmware.com/de/try-vmware.html. След това мога да монтирам ESXi-ISO и да копирам съдържанието на USB паметта си.
{{< gallery match="images/7/*.png" >}}
Когато всичко е копирано, търся файла "ISOLINUX.CFG" и го преименувам на "SYSLINUX.CFG". Добавям и "-p 1" към реда "APPEND -c boot.cfg".
{{< gallery match="images/8/*.png" >}}
ertig! Сега стикът може да се използва. Забавлявайте се!
{{< gallery match="images/9/*.png" >}}
