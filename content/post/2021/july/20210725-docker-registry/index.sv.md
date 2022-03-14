+++
date = "2021-07-25"
title = "Stora saker med containrar: Docker Registry med användargränssnitt"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "registry", "images", "ui", "interface"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/july/20210725-docker-registry/index.sv.md"
+++
Lär dig hur du gör dina Docker-avbildningar tillgängliga i hela nätverket via ditt eget register.
## Installation
Jag skapar en ny katalog som heter "docker-registry" på min server:
{{< terminal >}}
mkdir docker-registry

{{</ terminal >}}
Sedan går jag in i docker-registry-katalogen ("cd docker-registry") och skapar en ny fil som heter "registry.yml" med följande innehåll:
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
Fler användbara Docker-avbildningar för hemmabruk finns i [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Startkommando
Den här filen startas via Docker Compose. Därefter är installationen tillgänglig under den avsedda domänen/porten.
{{< terminal >}}
docker-compose -f registry.yml up -d

{{</ terminal >}}
Därefter kan det egna registret användas med mål-IP och port för UI-behållaren.
{{< gallery match="images/1/*.png" >}}
Nu kan jag bygga, skicka och fylla på bilder från mitt register:
{{< terminal >}}
docker build -t 192.168.178.61:5000/mein-image:version .
docker push 192.168.178.61:5000/mein-image:version
docker pull 192.168.178.61:5000/mein-image:version

{{</ terminal >}}
