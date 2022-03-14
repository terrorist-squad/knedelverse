+++
date = "2021-07-25"
title = "Grandi cose con i contenitori: registro Docker con UI"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "registry", "images", "ui", "interface"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/july/20210725-docker-registry/index.it.md"
+++
Impara come rendere le tue immagini Docker disponibili in tutta la rete tramite il tuo registro.
## Installazione
Creo una nuova directory chiamata "docker-registry" sul mio server:
{{< terminal >}}
mkdir docker-registry

{{</ terminal >}}
Poi vado nella directory docker-registry ("cd docker-registry") e creo un nuovo file chiamato "registry.yml" con il seguente contenuto:
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
Altre immagini Docker utili per uso domestico possono essere trovate nella [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Il comando start
Questo file viene avviato tramite Docker Compose. In seguito, l'installazione è accessibile sotto il dominio/la porta previsti.
{{< terminal >}}
docker-compose -f registry.yml up -d

{{</ terminal >}}
In seguito, il proprio registro può essere utilizzato con l'IP e la porta di destinazione del contenitore UI.
{{< gallery match="images/1/*.png" >}}
Ora posso costruire, spingere e popolare le immagini dal mio registro:
{{< terminal >}}
docker build -t 192.168.178.61:5000/mein-image:version .
docker push 192.168.178.61:5000/mein-image:version
docker pull 192.168.178.61:5000/mein-image:version

{{</ terminal >}}
