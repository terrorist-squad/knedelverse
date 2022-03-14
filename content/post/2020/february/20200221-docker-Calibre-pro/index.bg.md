+++
date = "2020-02-21"
title = "Страхотни неща с контейнери: стартиране на Calibre с Docker Compose (настройка на Synology pro)"
difficulty = "level-3"
tags = ["calibre", "calibre-web", "Docker", "docker-compose", "Synology", "linux"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200221-docker-Calibre-pro/index.bg.md"
+++
В този блог вече има по-лесен урок: [Synology-Nas: Инсталиране на Calibre Web като библиотека за електронни книги]({{< ref "post/2020/february/20200213-synology-calibreweb" >}} "Synology-Nas: Инсталиране на Calibre Web като библиотека за електронни книги"). Този урок е предназначен за всички специалисти по Synology DS.
## Стъпка 1: Подготовка на Synology
Първо, SSH входът трябва да бъде активиран на DiskStation. За да направите това, отидете в "Контролен панел" > "Терминал
{{< gallery match="images/1/*.png" >}}
След това можете да влезете в системата чрез "SSH", посочения порт и паролата на администратора (потребителите на Windows използват Putty или WinSCP).
{{< gallery match="images/2/*.png" >}}
Влизам в системата чрез терминал, winSCP или Putty и оставям тази конзола отворена за по-късно.
## Стъпка 2: Създаване на папка с книги
Създавам нова папка за библиотеката на Calibre. За да направя това, извиквам "Контрол на системата" -> "Споделена папка" и създавам нова папка, наречена "Книги". Ако все още няма папка "Docker", тя също трябва да бъде създадена.
{{< gallery match="images/3/*.png" >}}

## Стъпка 3: Подготвяне на папка за книги
Сега трябва да се изтегли и разопакова следният файл: https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view. Съдържанието ("metadata.db") трябва да бъде поставено в новата директория на книгата, вж:
{{< gallery match="images/4/*.png" >}}

## Стъпка 4: Подготовка на папката Docker
Създавам нова директория, наречена "calibre", в директорията на Docker:
{{< gallery match="images/5/*.png" >}}
След това преминавам в новата директория и създавам нов файл, наречен "calibre.yml", със следното съдържание:
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre:/briefkaste
    ports:
      - 8055:8083
    restart: unless-stopped

```
В този нов файл трябва да се коригират няколко места, както следва: * PUID/PGID: Идентификаторът на потребителя и групата на потребителя DS трябва да се въведе в PUID/PGID. Тук използвам конзолата от "Стъпка 1" и командата "id -u", за да видя идентификатора на потребителя. С командата "id -g" получавам идентификатора на групата.* ports: За порта трябва да се коригира предната част "8055:".directoriesВсички директории в този файл трябва да се коригират. Правилните адреси могат да се видят в прозореца за свойства на DS. (Следва екранна снимка)
{{< gallery match="images/6/*.png" >}}

## Стъпка 5: Стартиране на теста
В тази стъпка мога да използвам добре и конзолата. Преминавам към директорията Calibre и стартирам сървъра на Calibre там чрез Docker Compose.
{{< terminal >}}
cd /volume1/docker/calibre
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}

{{< gallery match="images/7/*.png" >}}

## Стъпка 6: Настройка
След това мога да се обадя на моя сървър Calibre с IP адреса на дисковата станция и назначения порт от стъпка 4. Използвам моята точка за монтиране "/books" в настройката. След това сървърът вече може да се използва.
{{< gallery match="images/8/*.png" >}}

## Стъпка 7: Финализиране на настройките
Конзолата е необходима и в тази стъпка. Използвам командата "exec", за да запазя базата данни на вътрешното приложение на контейнера.
{{< terminal >}}
sudo docker exec -it calibre-web-server cp /app/calibre-web/app.db /briefkaste/app.db

{{</ terminal >}}
След това виждам нов файл "app.db" в директорията на Calibre:
{{< gallery match="images/9/*.png" >}}
След това спирам сървъра на Calibre:
{{< terminal >}}
sudo docker-compose -f calibre.yml down

{{</ terminal >}}
Сега променям пътя на кутията за писма и запазвам базата данни на приложението върху нея.
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre/app.db:/app/calibre-web/app.db
    ports:
      - 8055:8083
    restart: unless-stopped

```
След това сървърът може да бъде рестартиран:
{{< terminal >}}
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}