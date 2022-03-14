+++
date = "2021-04-11"
title = "Накратко: Свързване на томове на Synology с ESXi."
difficulty = "level-1"
tags = ["dos", "esxi", "khk-kaufmann-v1", "nuc", "pc-kaufmann", "Synology", "vmware"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210411-esxi-mount/index.bg.md"
+++

## Стъпка 1: Активиране на услугата "NFS"
Първо, услугата "NFS" трябва да бъде активирана в Diskstation. За да направя това, отивам в "Control Panel" (Контролен панел) > "File Services" (Файлови услуги) и щраквам върху "Enable NFS" (Включване на NFS).
{{< gallery match="images/1/*.png" >}}
След това щраквам върху "Споделена папка" и избирам директория.
{{< gallery match="images/2/*.png" >}}

## Стъпка 2: Монтиране на директории в ESXi
В ESXi щраквам върху "Storage" (Съхранение) > "New datastore" (Ново хранилище за данни) и въвеждам данните си там.
{{< gallery match="images/3/*.png" >}}

## Готов
Сега паметта може да се използва.
{{< gallery match="images/4/*.png" >}}
За целите на тестването инсталирах инсталация на DOS и стар счетоводен софтуер чрез тази точка за монтиране.
{{< gallery match="images/5/*.png" >}}
