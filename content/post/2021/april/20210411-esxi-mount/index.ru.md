+++
date = "2021-04-11"
title = "Краткая история: Подключение томов Synology к ESXi."
difficulty = "level-1"
tags = ["dos", "esxi", "khk-kaufmann-v1", "nuc", "pc-kaufmann", "Synology", "vmware"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210411-esxi-mount/index.ru.md"
+++

## Шаг 1: Активируйте службу "NFS"
Во-первых, на Diskstation должна быть активирована служба "NFS". Для этого я перехожу в настройки "Панель управления" > "Файловые службы" и нажимаю на "Включить NFS".
{{< gallery match="images/1/*.png" >}}
Затем я нажимаю "Общая папка" и выбираю каталог.
{{< gallery match="images/2/*.png" >}}

## Шаг 2: Смонтируйте каталоги в ESXi
В ESXi я нажимаю "Storage" > "New datastore" и ввожу туда свои данные.
{{< gallery match="images/3/*.png" >}}

## Готовый
Теперь память можно использовать.
{{< gallery match="images/4/*.png" >}}
Для тестирования я установил установку DOS и старую бухгалтерскую программу через эту точку монтирования.
{{< gallery match="images/5/*.png" >}}
