+++
date = "2021-07-25"
title = "Suuria asioita konttien kanssa: Docker-rekisteri ja käyttöliittymä (UI)"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "registry", "images", "ui", "interface"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/july/20210725-docker-registry/index.fi.md"
+++
Opi, miten saat Docker-kuvasi saataville koko verkon laajuisesti oman rekisterisi kautta.
## Asennus
Luon palvelimelle uuden hakemiston nimeltä "docker-registry":
{{< terminal >}}
mkdir docker-registry

{{</ terminal >}}
Sitten menen docker-registry-hakemistoon ("cd docker-registry") ja luon uuden tiedoston nimeltä "registry.yml", jonka sisältö on seuraava:
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
Lisää hyödyllisiä Docker-kuvia kotikäyttöön löytyy [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Käynnistyskomento
Tämä tiedosto käynnistetään Docker Composen kautta. Tämän jälkeen asennus on käytettävissä aiotulla toimialueella/portilla.
{{< terminal >}}
docker-compose -f registry.yml up -d

{{</ terminal >}}
Tämän jälkeen omaa rekisteriä voidaan käyttää UI-säiliön kohde-IP:n ja portin kanssa.
{{< gallery match="images/1/*.png" >}}
Nyt voin rakentaa, työntää ja täyttää kuvia rekisteristäni:
{{< terminal >}}
docker build -t 192.168.178.61:5000/mein-image:version .
docker push 192.168.178.61:5000/mein-image:version
docker pull 192.168.178.61:5000/mein-image:version

{{</ terminal >}}

