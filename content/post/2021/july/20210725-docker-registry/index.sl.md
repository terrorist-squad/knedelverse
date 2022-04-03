+++
date = "2021-07-25"
title = "Velike stvari s posodami: register Docker z uporabniškim vmesnikom"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "registry", "images", "ui", "interface"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/july/20210725-docker-registry/index.sl.md"
+++
Naučite se, kako lahko slike Docker prek lastnega registra omogočite, da so na voljo v celotnem omrežju.
## Namestitev
V strežniku ustvarim nov imenik z imenom "docker-registry":
{{< terminal >}}
mkdir docker-registry

{{</ terminal >}}
Nato grem v imenik docker-registry ("cd docker-registry") in ustvarim novo datoteko z imenom "registry.yml" z naslednjo vsebino:
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
Več uporabnih slik Docker za domačo uporabo najdete v [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Ukaz Start
Ta datoteka se zažene prek programa Docker Compose. Nato je namestitev dostopna v predvideni domeni/portalu.
{{< terminal >}}
docker-compose -f registry.yml up -d

{{</ terminal >}}
Nato lahko lastni register uporabite s ciljnim IP in vratom vsebnika uporabniškega vmesnika.
{{< gallery match="images/1/*.png" >}}
Zdaj lahko gradim, potiskam in polnim slike iz svojega registra:
{{< terminal >}}
docker build -t 192.168.178.61:5000/mein-image:version .
docker push 192.168.178.61:5000/mein-image:version
docker pull 192.168.178.61:5000/mein-image:version

{{</ terminal >}}

