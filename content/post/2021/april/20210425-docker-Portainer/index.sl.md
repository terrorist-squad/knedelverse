+++
date = "2021-04-25T09:28:11+01:00"
title = "Velike stvari s kontejnerji: Portainer kot alternativa grafičnemu vmesniku Synology Docker GUI"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Portainer/index.sl.md"
+++

## Korak 1: Pripravite Synology
Najprej je treba na napravi DiskStation aktivirati prijavo SSH. To storite tako, da greste v "Nadzorna plošča" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Nato se lahko prijavite prek SSH, določenih vrat in skrbniškega gesla (uporabniki Windows uporabljajo Putty ali WinSCP).
{{< gallery match="images/2/*.png" >}}
Prijavim se prek terminala, winSCP ali Puttyja in pustim to konzolo odprto za pozneje.
## Korak 2: Ustvarite mapo z vsebnikom
V imeniku programa Docker ustvarim nov imenik z imenom "portainer".
{{< gallery match="images/3/*.png" >}}
Nato grem v imenik portainer s konzolo in tam ustvarim mapo in novo datoteko z imenom "portainer.yml".
{{< terminal >}}
cd /volume1/docker/portainer
mkdir portainer_data
vim portainer.yml

{{</ terminal >}}
Tukaj je vsebina datoteke "portainer.yml":
```
version: '3'

services:
  portainer:
    image: portainer/portainer:latest
    container_name: portainer
    restart: always
    ports:
      - 90070:9000
      - 9090:8000
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./portainer_data:/data

```
Več uporabnih slik Docker za domačo uporabo najdete v [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Korak 3: Začetek uporabe zaves
V tem koraku lahko dobro izkoristim tudi konzolo. Strežnik portainer zaženem prek programa Docker Compose.
{{< terminal >}}
sudo docker-compose -f portainer.yml up -d

{{</ terminal >}}
Nato lahko prikličem strežnik Portainer z naslovom IP diskovne postaje in dodeljenimi vrati iz koraka 2. Vnesem geslo upravitelja in izberem lokalno različico.
{{< gallery match="images/4/*.png" >}}
Kot lahko vidite, vse deluje odlično!
{{< gallery match="images/5/*.png" >}}