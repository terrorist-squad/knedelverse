+++
date = "2021-07-25"
title = "Nagyszerű dolgok konténerekkel: Docker Registry UI-val"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "registry", "images", "ui", "interface"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/july/20210725-docker-registry/index.hu.md"
+++
Ismerje meg, hogyan teheti Docker-képeit hálózatszerte elérhetővé saját nyilvántartásán keresztül.
## Telepítés
Létrehozok egy új könyvtárat "docker-registry" néven a szerveremen:
{{< terminal >}}
mkdir docker-registry

{{</ terminal >}}
Ezután bemegyek a docker-registry könyvtárba ("cd docker-registry") és létrehozok egy új fájlt "registry.yml" néven a következő tartalommal:
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
További hasznos Docker-képek otthoni használatra az [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## A start parancs
Ez a fájl a Docker Compose segítségével indul. Ezt követően a telepítés a kívánt tartomány/port alatt elérhetővé válik.
{{< terminal >}}
docker-compose -f registry.yml up -d

{{</ terminal >}}
Ezután a saját registry használható az UI konténer cél IP címével és portjával.
{{< gallery match="images/1/*.png" >}}
Most már tudok képeket készíteni, tolni és feltölteni a rendszerleíró adatbázisból:
{{< terminal >}}
docker build -t 192.168.178.61:5000/mein-image:version .
docker push 192.168.178.61:5000/mein-image:version
docker pull 192.168.178.61:5000/mein-image:version

{{</ terminal >}}
