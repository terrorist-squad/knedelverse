+++
date = "2021-04-25T09:28:11+01:00"
title = "Geweldige dingen met containers: Portainer als alternatief voor Synology Docker GUI"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Portainer/index.nl.md"
+++

## Stap 1: Synology voorbereiden
Eerst moet de SSH-aanmelding op het DiskStation worden geactiveerd. Om dit te doen, ga naar het "Configuratiescherm" > "Terminal
{{< gallery match="images/1/*.png" >}}
Vervolgens kunt u inloggen via "SSH", de opgegeven poort en het beheerderswachtwoord (Windows-gebruikers gebruiken Putty of WinSCP).
{{< gallery match="images/2/*.png" >}}
Ik log in via Terminal, winSCP of Putty en laat deze console open voor later.
## Stap 2: Creëer portainer map
Ik maak een nieuwe map genaamd "portainer" in de Docker map.
{{< gallery match="images/3/*.png" >}}
Dan ga ik naar de portainer map met de console en maak daar een map en een nieuw bestand genaamd "portainer.yml".
{{< terminal >}}
cd /volume1/docker/portainer
mkdir portainer_data
vim portainer.yml

{{</ terminal >}}
Hier is de inhoud van het "portainer.yml" bestand:
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
Meer nuttige Docker images voor thuisgebruik zijn te vinden in de [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Stap 3: Start van de draagwijdte
Ik kan ook goed gebruik maken van de console in deze stap. Ik start de portainer server via Docker Compose.
{{< terminal >}}
sudo docker-compose -f portainer.yml up -d

{{</ terminal >}}
Dan kan ik mijn Portainer server oproepen met het IP van het diskstation en de toegewezen poort van "Stap 2". Ik voer mijn admin wachtwoord in en selecteer de lokale variant.
{{< gallery match="images/4/*.png" >}}
Zoals je kunt zien, werkt alles geweldig!
{{< gallery match="images/5/*.png" >}}
