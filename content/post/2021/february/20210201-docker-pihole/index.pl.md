+++
date = "2021-02-01"
title = "Wspaniałe rzeczy z kontenerami: Pihole na stacji Synology DiskStation"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dns", "adblocker", "fritzbox"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/february/20210201-docker-pihole/index.pl.md"
+++
Dziś pokażę jak zainstalować usługę Pihole na stacji dysków Synology i podłączyć ją do Fritzboxa.
## Krok 1: Przygotuj Synology
Najpierw należy aktywować logowanie SSH na serwerze DiskStation. W tym celu należy wejść w "Panel sterowania" > "Terminal
{{< gallery match="images/1/*.png" >}}
Następnie można zalogować się poprzez "SSH", podany port i hasło administratora (użytkownicy Windows używają Putty lub WinSCP).
{{< gallery match="images/2/*.png" >}}
Loguję się przez Terminal, winSCP lub Putty i zostawiam tę konsolę otwartą na później.
## Krok 2: Utwórz folder Pihole
Tworzę nowy katalog o nazwie "pihole" w katalogu Dockera.
{{< gallery match="images/3/*.png" >}}
Następnie przechodzę do nowego katalogu i tworzę dwa foldery "etc-pihole" i "etc-dnsmasq.d":
{{< terminal >}}
cd /volume1/docker/
mkdir -p {etc-pihole,etc-dnsmasq.d}

{{</ terminal >}}
Teraz następujący plik Docker Compose o nazwie "pihole.yml" musi zostać umieszczony w katalogu Pihole:
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
Kontener może być teraz uruchomiony:
{{< terminal >}}
sudo docker-compose up -d

{{</ terminal >}}
Wywołuję serwer Pihole, podając adres IP Synology i port mojego kontenera, a następnie loguję się, podając hasło WEBPASSWORD.
{{< gallery match="images/4/*.png" >}}
Teraz adres DNS może być zmieniony w Fritzboxie pod "Sieć domowa" > "Sieć" > "Ustawienia sieci".
{{< gallery match="images/5/*.png" >}}