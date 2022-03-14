+++
date = "2021-04-25T09:28:11+01:00"
title = "Stora saker med containrar: Portainer som ett alternativ till Synology Docker GUI"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Portainer/index.sv.md"
+++

## Steg 1: Förbered Synology
Först måste SSH-inloggningen aktiveras på DiskStationen. Detta gör du genom att gå till "Kontrollpanelen" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Därefter kan du logga in via "SSH", den angivna porten och administratörslösenordet (Windows-användare använder Putty eller WinSCP).
{{< gallery match="images/2/*.png" >}}
Jag loggar in via Terminal, winSCP eller Putty och lämnar denna konsol öppen för senare.
## Steg 2: Skapa en portainer-mapp
Jag skapar en ny katalog som heter "portainer" i Docker-katalogen.
{{< gallery match="images/3/*.png" >}}
Sedan går jag till portainer-katalogen med konsolen och skapar en mapp och en ny fil som heter "portainer.yml" där.
{{< terminal >}}
cd /volume1/docker/portainer
mkdir portainer_data
vim portainer.yml

{{</ terminal >}}
Här är innehållet i filen "portainer.yml":
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
Fler användbara Docker-avbildningar för hemmabruk finns i [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Steg 3: Start av portener
Jag kan också utnyttja konsolen i det här steget. Jag startar portainer-servern via Docker Compose.
{{< terminal >}}
sudo docker-compose -f portainer.yml up -d

{{</ terminal >}}
Sedan kan jag ringa upp min Portainer-server med diskstationens IP och den tilldelade porten från "Steg 2". Jag anger mitt administratörslösenord och väljer den lokala varianten.
{{< gallery match="images/4/*.png" >}}
Som du kan se fungerar allt utmärkt!
{{< gallery match="images/5/*.png" >}}