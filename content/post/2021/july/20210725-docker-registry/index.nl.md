+++
date = "2021-07-25"
title = "Geweldige dingen met containers: Docker register met UI"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "registry", "images", "ui", "interface"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/july/20210725-docker-registry/index.nl.md"
+++
Leer hoe u uw Docker-images netwerkbreed beschikbaar kunt maken via uw eigen register.
## Installatie
Ik maak een nieuwe map genaamd "docker-registry" op mijn server:
{{< terminal >}}
mkdir docker-registry

{{</ terminal >}}
Dan ga ik naar de docker-registry directory ("cd docker-registry") en maak een nieuw bestand aan genaamd "registry.yml" met de volgende inhoud:
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
Meer nuttige Docker images voor thuisgebruik zijn te vinden in de [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Het startcommando
Dit bestand wordt gestart via Docker Compose. Daarna is de installatie toegankelijk onder het beoogde domein/poort.
{{< terminal >}}
docker-compose -f registry.yml up -d

{{</ terminal >}}
Daarna kan het eigen register worden gebruikt met het doel IP en poort van de UI container.
{{< gallery match="images/1/*.png" >}}
Nu kan ik images bouwen, pushen en vullen vanuit mijn register:
{{< terminal >}}
docker build -t 192.168.178.61:5000/mein-image:version .
docker push 192.168.178.61:5000/mein-image:version
docker pull 192.168.178.61:5000/mein-image:version

{{</ terminal >}}

