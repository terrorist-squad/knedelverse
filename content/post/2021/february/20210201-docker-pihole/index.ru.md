+++
date = "2021-02-01"
title = "Великие дела с контейнерами: Pihole на Synology DiskStation"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dns", "adblocker", "fritzbox"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/february/20210201-docker-pihole/index.ru.md"
+++
Сегодня я покажу, как установить службу Pihole на дисковую станцию Synology и подключить ее к Fritzbox.
## Шаг 1: Подготовьте Synology
Во-первых, на DiskStation должен быть активирован вход SSH. Для этого перейдите в "Панель управления" > "Терминал
{{< gallery match="images/1/*.png" >}}
Затем вы можете войти в систему через "SSH", указанный порт и пароль администратора (пользователи Windows используют Putty или WinSCP).
{{< gallery match="images/2/*.png" >}}
Я вхожу в систему через Terminal, winSCP или Putty и оставляю эту консоль открытой на потом.
## Шаг 2: Создайте папку Pihole
Я создаю новый каталог под названием "pihole" в каталоге Docker.
{{< gallery match="images/3/*.png" >}}
Затем я перехожу в новый каталог и создаю две папки "etc-pihole" и "etc-dnsmasq.d":
{{< terminal >}}
cd /volume1/docker/
mkdir -p {etc-pihole,etc-dnsmasq.d}

{{</ terminal >}}
Теперь следующий файл Docker Compose с именем "pihole.yml" должен быть помещен в каталог Pihole:
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
Теперь контейнер можно запустить:
{{< terminal >}}
sudo docker-compose up -d

{{</ terminal >}}
Я вызываю сервер Pihole с IP-адресом Synology и портом моего контейнера и вхожу в систему с паролем WEBPASSWORD.
{{< gallery match="images/4/*.png" >}}
Теперь адрес DNS можно изменить в Fritzbox в разделе "Домашняя сеть" > "Сеть" > "Настройки сети".
{{< gallery match="images/5/*.png" >}}
