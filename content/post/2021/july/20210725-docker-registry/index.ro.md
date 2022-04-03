+++
date = "2021-07-25"
title = "Lucruri grozave cu containere: Registrul Docker cu UI"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "registry", "images", "ui", "interface"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/july/20210725-docker-registry/index.ro.md"
+++
Aflați cum să faceți ca imaginile Docker să fie disponibile în întreaga rețea prin intermediul propriului registru.
## Instalare
Creez un nou director numit "docker-registry" pe serverul meu:
{{< terminal >}}
mkdir docker-registry

{{</ terminal >}}
Apoi intru în directorul docker-registry ("cd docker-registry") și creez un nou fișier numit "registry.yml" cu următorul conținut:
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
Mai multe imagini Docker utile pentru uz casnic pot fi găsite în secțiunea [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Comanda de pornire
Acest fișier este pornit prin Docker Compose. Ulterior, instalația este accesibilă sub domeniul/portul dorit.
{{< terminal >}}
docker-compose -f registry.yml up -d

{{</ terminal >}}
Ulterior, registrul propriu poate fi utilizat cu IP-ul și portul țintă ale containerului UI.
{{< gallery match="images/1/*.png" >}}
Acum pot construi, împinge și popula imagini din registrul meu:
{{< terminal >}}
docker build -t 192.168.178.61:5000/mein-image:version .
docker push 192.168.178.61:5000/mein-image:version
docker pull 192.168.178.61:5000/mein-image:version

{{</ terminal >}}

