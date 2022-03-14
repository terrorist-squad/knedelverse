+++
date = "2021-07-25"
title = "Skvělé věci s kontejnery: Registr Docker s uživatelským rozhraním"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "registry", "images", "ui", "interface"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/july/20210725-docker-registry/index.cs.md"
+++
Zjistěte, jak zpřístupnit obrazy nástroje Docker v celé síti prostřednictvím vlastního registru.
## Instalace
Na serveru vytvořím nový adresář s názvem "docker-registry":
{{< terminal >}}
mkdir docker-registry

{{</ terminal >}}
Pak přejdu do adresáře docker-registry ("cd docker-registry") a vytvořím nový soubor s názvem "registry.yml" s následujícím obsahem:
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
Další užitečné obrazy Docker pro domácí použití najdete v [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Příkaz start
Tento soubor se spouští pomocí nástroje Docker Compose. Poté je instalace přístupná pod určenou doménou/portem.
{{< terminal >}}
docker-compose -f registry.yml up -d

{{</ terminal >}}
Poté lze použít vlastní registr s cílovou IP adresou a portem kontejneru uživatelského rozhraní.
{{< gallery match="images/1/*.png" >}}
Nyní mohu vytvářet, odesílat a doplňovat obrazy z registru:
{{< terminal >}}
docker build -t 192.168.178.61:5000/mein-image:version .
docker push 192.168.178.61:5000/mein-image:version
docker pull 192.168.178.61:5000/mein-image:version

{{</ terminal >}}
