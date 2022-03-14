+++
date = "2021-07-25"
title = "Veľké veci s kontajnermi: Register Docker s používateľským rozhraním"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "registry", "images", "ui", "interface"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/july/20210725-docker-registry/index.sk.md"
+++
Naučte sa, ako sprístupniť svoje obrazy Docker v celej sieti prostredníctvom vlastného registra.
## Inštalácia
Na svojom serveri vytvorím nový adresár s názvom "docker-registry":
{{< terminal >}}
mkdir docker-registry

{{</ terminal >}}
Potom prejdem do adresára docker-registry ("cd docker-registry") a vytvorím nový súbor s názvom "registry.yml" s nasledujúcim obsahom:
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
Ďalšie užitočné obrazy Docker na domáce použitie nájdete v [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Príkaz Štart
Tento súbor sa spúšťa prostredníctvom nástroja Docker Compose. Potom je inštalácia prístupná pod určenou doménou/portom.
{{< terminal >}}
docker-compose -f registry.yml up -d

{{</ terminal >}}
Potom je možné použiť vlastný register s cieľovou IP adresou a portom kontajnera používateľského rozhrania.
{{< gallery match="images/1/*.png" >}}
Teraz môžem vytvárať, odosielať a napĺňať obrazy z môjho registra:
{{< terminal >}}
docker build -t 192.168.178.61:5000/mein-image:version .
docker push 192.168.178.61:5000/mein-image:version
docker pull 192.168.178.61:5000/mein-image:version

{{</ terminal >}}
