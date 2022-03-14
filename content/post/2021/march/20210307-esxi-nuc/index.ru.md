+++
date = "2021-03-07"
title = "Установите ESXi на NUC. Подготовьте USB-накопитель через MacBook."
difficulty = "level-4"
tags = ["esxi", "homelab", "hypervisor", "linux", "nuc", "vmware"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210307-esxi-nuc/index.ru.md"
+++
С помощью ESXi "intel NUC" может быть разделен на любое количество компьютеров. В этом руководстве я покажу, как я установил VMware ESXi на свой NUC.Небольшое предисловие: я рекомендую обновить BIOS перед установкой ESXi. Вам также понадобится USB-накопитель емкостью 32 ГБ. Я купил целую пачку менее чем за 5 евро каждая на Amazon.
{{< gallery match="images/1/*.jpg" >}}
Мой NUC-8I7BEH оснащен 2x 16GB HyperX Impact Ram, 1x 256GB Samsung 970 EVO M2 модулем и 1TB 2.5-дюймовым жестким диском WD-RED.
{{< gallery match="images/2/*.jpg" >}}

## Шаг 1: Найдите USB - карту
Следующая команда показывает мне все диски:
{{< terminal >}}
diskutil list

{{</ terminal >}}
Здесь видно, что мой USB-накопитель имеет идентификатор "disk2":
{{< gallery match="images/3/*.png" >}}

## Шаг 2: Подготовка файловой системы
Теперь я могу использовать следующую команду для подготовки файловой системы:
{{< terminal >}}
$ diskutil eraseDisk MS-DOS "ESXI" MBR disk2

{{</ terminal >}}
После этого я также вижу идентификатор в Finder:
{{< gallery match="images/4/*.png" >}}

## Шаг 3: Извлеките USB-накопитель
Я использую команду "unmountDisk" для извлечения тома:
{{< terminal >}}
$ diskutil unmountDisk /dev/disk2

{{</ terminal >}}
См:
{{< gallery match="images/5/*.png" >}}

## Шаг 4: Сделайте флешку загрузочной
Теперь вводим команду "sudo fdisk -e /dev/disk2" и затем вводим "f 1", "write" и "quit", см:
{{< gallery match="images/6/*.png" >}}

## Шаг 5: Копирование данных
Теперь мне нужно загрузить ESXi-ISO: https://www.vmware.com/de/try-vmware.html. После этого я могу смонтировать ESXi-ISO и скопировать содержимое на USB-накопитель.
{{< gallery match="images/7/*.png" >}}
Когда все скопировано, я ищу файл "ISOLINUX.CFG" и переименовываю его в "SYSLINUX.CFG". Я также добавил "-p 1" к строке "APPEND -c boot.cfg".
{{< gallery match="images/8/*.png" >}}
ertig! Теперь палку можно использовать. Веселитесь!
{{< gallery match="images/9/*.png" >}}