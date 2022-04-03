+++
date = "2021-02-01"
title = "Страхотни неща с контейнери: Pihole в Synology DiskStation"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dns", "adblocker", "fritzbox"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/february/20210201-docker-pihole/index.bg.md"
+++
Днес показвам как да инсталирате услугата Pihole на дисковата станция на Synology и да я свържете с Fritzbox.
## Стъпка 1: Подготовка на Synology
Първо, SSH входът трябва да бъде активиран на DiskStation. За да направите това, отидете в "Контролен панел" > "Терминал
{{< gallery match="images/1/*.png" >}}
След това можете да влезете в системата чрез "SSH", посочения порт и паролата на администратора (потребителите на Windows използват Putty или WinSCP).
{{< gallery match="images/2/*.png" >}}
Влизам в системата чрез терминал, winSCP или Putty и оставям тази конзола отворена за по-късно.
## Стъпка 2: Създаване на папка Pihole
Създавам нова директория, наречена "pihole", в директорията на Docker.
{{< gallery match="images/3/*.png" >}}
След това преминавам в новата директория и създавам две папки "etc-pihole" и "etc-dnsmasq.d":
{{< terminal >}}
cd /volume1/docker/
mkdir -p {etc-pihole,etc-dnsmasq.d}

{{</ terminal >}}
Сега в директорията Pihole трябва да бъде поставен следният Docker Compose файл с име "pihole.yml":
```
version: "3"

services:
  pihole:
    container_name: pihole
    image: pihole/pihole:latest
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "67:67/udp"
      - "8080:80/tcp"
    environment:
      TZ: 'Europe/Berlin'
      WEBPASSWORD: 'password'
    volumes:
      - './etc-pihole/:/etc/pihole/'
      - './etc-dnsmasq.d/:/etc/dnsmasq.d/'
    cap_add:
      - NET_ADMIN
    restart: unless-stopped

```
Контейнерът вече може да бъде стартиран:
{{< terminal >}}
sudo docker-compose up -d

{{</ terminal >}}
Обаждам се на сървъра Pihole с IP адреса на Synology и порта на контейнера и влизам в него с паролата WEBPASSWORD.
{{< gallery match="images/4/*.png" >}}
Сега DNS адресът може да бъде променен във Fritzbox под "Домашна мрежа" > "Мрежа" > "Настройки на мрежата".
{{< gallery match="images/5/*.png" >}}
