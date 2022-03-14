+++
date = "2021-07-25"
title = "Du grand avec les conteneurs : le registre Docker avec UI"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "registry", "images", "ui", "interface"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/july/20210725-docker-registry/index.fr.md"
+++
Découvrez comment rendre vos images Docker disponibles sur l'ensemble du réseau via votre propre registre.
## Installation
Je crée un nouveau répertoire appelé "docker-registry" sur mon serveur :
{{< terminal >}}
mkdir docker-registry

{{</ terminal >}}
Ensuite, je vais dans le répertoire docker-registry ("cd docker-registry") et j'y crée un nouveau fichier nommé "registry.yml" avec le contenu suivant :
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
Vous trouverez d'autres images Docker utiles pour une utilisation à domicile dans le [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## La commande de démarrage
Ce fichier est lancé via Docker-Compose. L'installation est ensuite accessible sous le domaine/port prévu.
{{< terminal >}}
docker-compose -f registry.yml up -d

{{</ terminal >}}
Ensuite, il est possible d'utiliser son propre registre avec l'IP cible et le port du conteneur UI.
{{< gallery match="images/1/*.png" >}}
Maintenant, je peux construire, pousser et puller des images à partir de mon registre :
{{< terminal >}}
docker build -t 192.168.178.61:5000/mein-image:version .
docker push 192.168.178.61:5000/mein-image:version
docker pull 192.168.178.61:5000/mein-image:version

{{</ terminal >}}
