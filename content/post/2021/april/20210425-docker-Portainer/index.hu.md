+++
date = "2021-04-25T09:28:11+01:00"
title = "Nagyszerű dolgok konténerekkel: Portainer a Synology Docker GUI alternatívájaként"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Portainer/index.hu.md"
+++

## 1. lépés: A Synology előkészítése
Először is aktiválni kell az SSH bejelentkezést a DiskStationön. Ehhez menjen a "Vezérlőpult" > "Terminál" > "Terminál" menüpontba.
{{< gallery match="images/1/*.png" >}}
Ezután bejelentkezhet az "SSH"-n keresztül, a megadott porton és a rendszergazdai jelszóval (Windows felhasználók a Putty vagy a WinSCP segítségével).
{{< gallery match="images/2/*.png" >}}
Terminal, winSCP vagy Putty segítségével jelentkezem be, és ezt a konzolt későbbre nyitva hagyom.
## 2. lépés: Portainer mappa létrehozása
Létrehozok egy új könyvtárat "portainer" néven a Docker könyvtárban.
{{< gallery match="images/3/*.png" >}}
Ezután a konzollal belépek a portainer könyvtárba, és létrehozok ott egy mappát és egy új fájlt "portainer.yml" néven.
{{< terminal >}}
cd /volume1/docker/portainer
mkdir portainer_data
vim portainer.yml

{{</ terminal >}}
Íme a "portainer.yml" fájl tartalma:
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
További hasznos Docker-képek otthoni használatra az [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## 3. lépés: Portainer indítása
Ebben a lépésben is jól tudom használni a konzolt. A portainer kiszolgálót a Docker Compose-on keresztül indítom el.
{{< terminal >}}
sudo docker-compose -f portainer.yml up -d

{{</ terminal >}}
Ezután a Portainer-kiszolgálót a lemezállomás IP-címével és a "2. lépésből" kiosztott porttal hívhatom meg. Megadom az admin jelszavamat, és kiválasztom a helyi változatot.
{{< gallery match="images/4/*.png" >}}
Mint láthatod, minden remekül működik!
{{< gallery match="images/5/*.png" >}}