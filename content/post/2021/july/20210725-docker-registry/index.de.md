+++
date = "2021-07-25"
title = "Großartiges mit Containern: Docker-Registry mit UI"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "registry", "images", "ui", "interface"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/july/20210725-docker-registry/index.de.md"
+++

Erfahren Sie, wie Sie Ihre Docker-Images Netzwerkweit über eine eigene Registry verfügbar machen. 

## Installation
Ich erstelle ein neues Verzeichnis namens „docker-registry“ auf meinem Server:
{{< terminal >}}
mkdir docker-registry
{{</ terminal >}}

Danach gehe ich in das docker-registry–Verzeichnis ("cd docker-registry") und erstelle dort neue Datei namens „registry.yml“ mit folgendem Inhalt:
```
version: '3'

services:
  registry:
    restart: always
    image: registry:2
    ports:
    - "5000:5000"
    environment:
      REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY: /data
    volumes:
      - ./data:/data
    networks:
      - registry-ui-net

  ui:
    restart: always
    image: joxit/docker-registry-ui:static
    ports:
      - 8080:80
    environment:
      - REGISTRY_TITLE=My Private Docker Registry
      - REGISTRY_URL=http://registry:5000
    depends_on:
      - registry
    networks:
      - registry-ui-net

networks:
  registry-ui-net:
```
Weitere nützliche Docker-Images für den Heimgebrauch finden Sie im [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").

## Der Startbefehl
Diese Datei wird via Docker-Compose gestartet. Danach ist die Installation unter der vorgesehenen Domain/port erreichbar.
{{< terminal >}}
docker-compose -f registry.yml up -d
{{</ terminal >}}

Danach kann die eigene Registry mit der Ziel-IP und dem Port des UI-Container genutzt werden.
{{< gallery match="images/1/*.png" >}}


Nun kann ich images aus meine Registry builden, pushen und pullen:
{{< terminal >}}
docker build -t 192.168.178.61:5000/mein-image:version .
docker push 192.168.178.61:5000/mein-image:version
docker pull 192.168.178.61:5000/mein-image:version
{{</ terminal >}}

