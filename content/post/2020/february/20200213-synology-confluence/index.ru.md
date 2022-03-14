+++
date = "2020-02-13"
title = "Синология-Нас: Confluence как вики-система"
difficulty = "level-4"
tags = ["atlassian", "confluence", "Docker", "ds918", "Synology", "wiki", "nas"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200213-synology-confluence/index.ru.md"
+++
Если вы хотите установить Atlassian Confluence на NAS Synology, то вы пришли по адресу.
## Шаг 1
Сначала я открываю приложение Docker в интерфейсе Synology, а затем перехожу к подпункту "Регистрация". Там я ищу "Confluence" и нажимаю на первое изображение "Atlassian Confluence".
{{< gallery match="images/1/*.png" >}}

## Шаг 2
После загрузки изображения оно доступно в виде рисунка. Docker различает 2 состояния, контейнер "динамическое состояние" и образ/изображение (фиксированное состояние). Прежде чем мы сможем создать контейнер из образа, необходимо выполнить несколько настроек.
## Автоматический перезапуск
Я дважды щелкаю по образу Confluence.
{{< gallery match="images/2/*.png" >}}
Затем я нажимаю на "Дополнительные настройки" и активирую "Автоматический перезапуск".
{{< gallery match="images/3/*.png" >}}

## Порты
Я назначаю фиксированные порты для контейнера Confluence. Без фиксированных портов Confluence может работать на другом порту после перезапуска.
{{< gallery match="images/4/*.png" >}}

## Память
Я создаю физическую папку и монтирую ее в контейнер (/var/atlassian/application-data/confluence/). Эта настройка упрощает резервное копирование и восстановление данных.
{{< gallery match="images/5/*.png" >}}
После этих настроек Confluence можно запускать!
{{< gallery match="images/6/*.png" >}}