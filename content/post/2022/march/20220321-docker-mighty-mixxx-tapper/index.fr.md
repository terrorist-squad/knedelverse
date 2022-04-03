+++
date = "2022-03-21"
title = "De grandes choses avec les conteneurs : enregistrer des MP3 à partir de la radio"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "radio", "mp3", "ripp", "streamripper", "radiorecorder"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220321-docker-mighty-mixxx-tapper/index.fr.md"
+++
Streamripper est un outil en ligne de commande qui permet d'enregistrer des flux MP3 ou OGG/Vorbis et de les sauvegarder directement sur le disque dur. Les chansons sont automatiquement nommées d'après l'interprète et enregistrées individuellement, le format utilisé est celui qui a été envoyé à l'origine (dans les faits, on obtient donc des fichiers avec l'extension .mp3 ou .ogg). J'ai trouvé une interface radiorecorder géniale et j'ai construit une image docker à partir de celle-ci, voir : https://github.com/terrorist-squad/mightyMixxxTapper/
{{< gallery match="images/1/*.png" >}}

## Option pour les professionnels
En tant qu'utilisateur expérimenté de Synology, on peut bien sûr se connecter directement avec SSH et installer l'ensemble du setup via un fichier Docker Compose.
```
version: "2.0"
services:
  mealie:
    container_name: mighty-mixxx-tapper
    image: chrisknedel/mighty-mixxx-tapper:latest
    restart: always
    ports:
      - 9000:80
    environment:
      TZ: Europa/Berlin
    volumes:
      - ./ripps/:/tmp/ripps/

```

## Étape 1 : Trouver une image Docker
Je clique sur l'onglet "Registre" dans la fenêtre docker de Synology et je recherche "mighty-mixxx-tapper". Je sélectionne l'image docker "chrisknedel/mighty-mixxx-tapper" et je clique ensuite sur le tag "latest".
{{< gallery match="images/2/*.png" >}}
Après le téléchargement de l'image, celle-ci est disponible sous forme d'image. Docker fait la distinction entre deux états, le conteneur "état dynamique" et l'image/image (état fixe). Avant de créer un conteneur à partir de l'image, il faut encore procéder à quelques réglages.
## Étape 2 : Mettre l'image en service :
Je double-clique sur mon image "mighty-mixxx-tapper".
{{< gallery match="images/3/*.png" >}}
Ensuite, je clique sur "Paramètres avancés" et j'active le "Redémarrage automatique". Je sélectionne l'onglet "Volume" et clique sur "Ajouter un dossier". Là, je crée un nouveau dossier avec ce chemin de montage "/tmp/ripps/".
{{< gallery match="images/4/*.png" >}}
J'attribue des ports fixes pour le conteneur "mighty-mixxx-tapper". Sans ports fixes, il se peut que le "serveur mighty-mixxx-tapper" s'exécute sur un autre port après un redémarrage.
{{< gallery match="images/5/*.png" >}}
Après ces réglages, le serveur mighty-mixxx-tapper peut être lancé ! Ensuite, on peut appeler mighty-mixxx-tapper en utilisant l'adresse Ip de la disctance Synology et le port attribué, par exemple http://192.168.21.23:8097.
{{< gallery match="images/6/*.png" >}}
