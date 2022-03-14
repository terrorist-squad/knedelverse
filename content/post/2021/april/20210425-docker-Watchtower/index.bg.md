+++
date = "2021-04-25T09:28:11+01:00"
title = "Кратка история: Автоматично актуализиране на контейнери с Watchtower"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Watchtower/index.bg.md"
+++
Ако използвате контейнери Docker на дисковата си станция, естествено искате те винаги да са актуални. Watchtower актуализира образите и контейнерите автоматично. По този начин можете да се възползвате от най-новите функции и най-съвременната защита на данните. Днес ще ви покажа как да инсталирате Watchtower на дисковата станция на Synology.
## Стъпка 1: Подготовка на Synology
Първо, SSH входът трябва да бъде активиран на DiskStation. За да направите това, отидете в "Контролен панел" > "Терминал
{{< gallery match="images/1/*.png" >}}
След това можете да влезете в системата чрез "SSH", посочения порт и паролата на администратора (потребителите на Windows използват Putty или WinSCP).
{{< gallery match="images/2/*.png" >}}
Влизам в системата чрез терминал, winSCP или Putty и оставям тази конзола отворена за по-късно.
## Стъпка 2: Инсталиране на Watchtower
За целта използвам конзолата:
{{< terminal >}}
docker run --name watchtower --restart always -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower

{{</ terminal >}}
След това програмата Watchtower винаги работи във фонов режим.
{{< gallery match="images/3/*.png" >}}
