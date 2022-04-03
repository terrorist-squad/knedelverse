+++
date = "2020-02-13"
title = "Synology-Nas: Как я могу запускать задачи или кроны?"
difficulty = "level-1"
tags = ["synology", "diskstation", "task", "cronjob", "cron", "aufgabe"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200213-synology-task/index.ru.md"
+++
Хотите ли вы установить автоматические задачи в NAS Synology? Нажмите на "Планировщик задач" в "Панели управления".
{{< gallery match="images/1/*.png" >}}

## Установленное время и количество повторений
В "планировщике задач" новые "задачи" могут быть созданы как задания cron. Время и повторы устанавливаются здесь.
{{< gallery match="images/2/*.png" >}}

## Скрипт
Целевой сценарий хранится в разделе "Настройки задачи". В моем случае создается zip-архив. Вы должны сами проверить эту функцию.
{{< gallery match="images/3/*.png" >}}
