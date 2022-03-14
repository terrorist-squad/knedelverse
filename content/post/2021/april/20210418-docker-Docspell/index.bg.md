+++
date = "2021-04-18"
title = "Страхотни неща с контейнери: Стартиране на Docspell DMS на Synology DiskStation"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "Document-Managment-System"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-Docspell/index.bg.md"
+++
Docspell е система за управление на документи за Synology DiskStation. Чрез Docspell документите могат да се индексират, търсят и намират много по-бързо. Днес ще покажа как да инсталирате услугата Docspell на дисковата станция на Synology.
## Стъпка 1: Подготовка на Synology
Първо, SSH входът трябва да бъде активиран на DiskStation. За да направите това, отидете в "Контролен панел" > "Терминал
{{< gallery match="images/1/*.png" >}}
След това можете да влезете в системата чрез "SSH", посочения порт и паролата на администратора (потребителите на Windows използват Putty или WinSCP).
{{< gallery match="images/2/*.png" >}}
Влизам в системата чрез терминал, winSCP или Putty и оставям тази конзола отворена за по-късно.
## Стъпка 2: Създаване на папка Docspel
Създавам нова директория, наречена "docspell", в директорията на Docker.
{{< gallery match="images/3/*.png" >}}
Сега трябва да се изтегли и разопакова следният файл в директорията: https://github.com/eikek/docspell/archive/refs/heads/master.zip . За целта използвам конзолата:
{{< terminal >}}
cd /volume1/docker/docspell/
mkdir docs
mkdir postgres_data
wget https://github.com/eikek/docspell/archive/refs/heads/master.zip 
/bin/7z x master.zip

{{</ terminal >}}
След това редактирам файла "docker/docker-compose.yml" и въвеждам адресите на Synology в "consumedir" и "db":
{{< gallery match="images/4/*.png" >}}
След това мога да стартирам файла Compose:
{{< terminal >}}
cd docspell-master/docker/
docker-compose up -d

{{</ terminal >}}
След няколко минути мога да се обадя на сървъра Docspell с IP адреса на дисковата станция и зададения порт/7878.
{{< gallery match="images/5/*.png" >}}
