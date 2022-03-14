+++
date = "2021-07-25"
title = "Store ting med containere: Docker Registry med brugergrænseflade"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "registry", "images", "ui", "interface"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/july/20210725-docker-registry/index.da.md"
+++
Lær, hvordan du gør dine Docker-aftryk tilgængelige i hele netværket via dit eget register.
## Installation
Jeg opretter en ny mappe med navnet "docker-registry" på min server:
{{< terminal >}}
mkdir docker-registry

{{</ terminal >}}
Derefter går jeg ind i docker-registry-mappen ("cd docker-registry") og opretter en ny fil kaldet "registry.yml" med følgende indhold:
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
Flere nyttige Docker-aftryk til hjemmebrug findes i [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Startkommandoen
Denne fil startes via Docker Compose. Herefter er installationen tilgængelig under det ønskede domæne/port.
{{< terminal >}}
docker-compose -f registry.yml up -d

{{</ terminal >}}
Herefter kan det eget register bruges med mål-IP og -port for UI-containeren.
{{< gallery match="images/1/*.png" >}}
Nu kan jeg bygge, skubbe og udfylde billeder fra mit register:
{{< terminal >}}
docker build -t 192.168.178.61:5000/mein-image:version .
docker push 192.168.178.61:5000/mein-image:version
docker pull 192.168.178.61:5000/mein-image:version

{{</ terminal >}}
