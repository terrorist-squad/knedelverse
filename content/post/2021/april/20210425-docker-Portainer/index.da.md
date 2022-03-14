+++
date = "2021-04-25T09:28:11+01:00"
title = "Store ting med containere: Portainer som et alternativ til Synology Docker GUI"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Portainer/index.da.md"
+++

## Trin 1: Forbered Synology
Først skal SSH-login være aktiveret på DiskStationen. Du kan gøre dette ved at gå til "Kontrolpanel" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Derefter kan du logge ind via "SSH", den angivne port og administratoradgangskoden (Windows-brugere bruger Putty eller WinSCP).
{{< gallery match="images/2/*.png" >}}
Jeg logger ind via Terminal, winSCP eller Putty og lader denne konsol være åben til senere.
## Trin 2: Opret portainer-mappe
Jeg opretter en ny mappe med navnet "portainer" i Docker-mappen.
{{< gallery match="images/3/*.png" >}}
Derefter går jeg til portainer-mappen med konsollen og opretter en mappe og en ny fil med navnet "portainer.yml" der.
{{< terminal >}}
cd /volume1/docker/portainer
mkdir portainer_data
vim portainer.yml

{{</ terminal >}}
Her er indholdet af filen "portainer.yml":
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
Flere nyttige Docker-aftryk til hjemmebrug findes i [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Trin 3: Start af portene
Jeg kan også gøre god brug af konsollen i dette trin. Jeg starter portainer-serveren via Docker Compose.
{{< terminal >}}
sudo docker-compose -f portainer.yml up -d

{{</ terminal >}}
Derefter kan jeg kalde min Portainer-server op med diskstationens IP og den tildelte port fra "Trin 2". Jeg indtaster min administratoradgangskode og vælger den lokale variant.
{{< gallery match="images/4/*.png" >}}
Som du kan se, fungerer alting fint!
{{< gallery match="images/5/*.png" >}}