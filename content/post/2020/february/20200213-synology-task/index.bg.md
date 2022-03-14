+++
date = "2020-02-13"
title = "Synology-Nas: Как мога да стартирам задачи или crons?"
difficulty = "level-1"
tags = ["synology", "diskstation", "task", "cronjob", "cron", "aufgabe"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200213-synology-task/index.bg.md"
+++
Искате ли да зададете автоматични задачи в Synology NAS? Щракнете върху "Task Scheduler" (Планиране на задачи) в "Control Panel" (Контролен панел).
{{< gallery match="images/1/*.png" >}}

## Времена и повторения
В "планирането на задачи" могат да се създават нови "задачи", които са почти като задачи на cron. Времената и повторенията са определени тук.
{{< gallery match="images/2/*.png" >}}

## Скрипт
Целевият скрипт се съхранява в "Настройки на задачите". В моя случай се създава архив zip. Трябва сами да тествате тази функция.
{{< gallery match="images/3/*.png" >}}