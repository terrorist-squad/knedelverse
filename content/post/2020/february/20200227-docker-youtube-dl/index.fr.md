+++
date = "2020-02-27"
title = "De grandes choses avec les conteneurs : faire fonctionner le téléchargeur Youtube sur le Diskstation de Synology"
difficulty = "level-1"
tags = ["Docker", "docker-compose", "download", "linux", "Synology", "video", "youtube"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200227-docker-youtube-dl/index.fr.md"
+++
Beaucoup de mes amis savent que je gère un portail vidéo d'apprentissage privé sur mon réseau Homelab. J'ai sauvegardé sur mon NAS des cours vidéo issus d'adhésions passées au portail d'apprentissage et de bons tutoriels Youtube pour une utilisation hors ligne.
{{< gallery match="images/1/*.png" >}}
Au fil du temps, j'ai accumulé 8845 cours vidéo avec 282616 vidéos individuelles. La durée totale correspond à environ 2 ans. Absolument fou!Dans ce tutoriel, je montre comment on peut sauvegarder de bons tutoriels Youtube avec un service de téléchargement Docker à des fins hors ligne.
## Option pour les professionnels
En tant qu'utilisateur expérimenté de Synology, on peut bien sûr se connecter directement avec SSH et installer l'ensemble du setup via un fichier Docker Compose.
```
version: "2"
services:
  youtube-dl:
    image: modenaf360/youtube-dl-nas
    container_name: youtube-dl
    environment:
      - MY_ID=admin
      - MY_PW=admin
    volumes:
      - ./YouTube:/downfolder
    ports:
      - 8080:8080
    restart: unless-stopped

```

## Étape 1
Tout d'abord, je crée un dossier pour les téléchargements. J'accède au "Panneau de configuration" -> "Dossier partagé" et je crée un nouveau dossier "Téléchargements".
{{< gallery match="images/2/*.png" >}}

## Étape 2 : Trouver une image Docker
Je clique sur l'onglet "Registration" dans la fenêtre docker de Synology et je recherche "youtube-dl-nas". Je sélectionne l'image docker "modenaf360/youtube-dl-nas" et je clique ensuite sur le tag "latest".
{{< gallery match="images/3/*.png" >}}
Après le téléchargement de l'image, celle-ci est disponible sous forme d'image. Docker fait la distinction entre deux états, le conteneur "état dynamique" et l'image/image (état fixe). Avant de créer un conteneur à partir de l'image, il faut encore procéder à quelques réglages.
## Etape 3 : Mettre l'image en service :
Je double-clique sur mon image youtube-dl-nas.
{{< gallery match="images/4/*.png" >}}
Ensuite, je clique sur "Paramètres avancés" et j'active le "Redémarrage automatique". Je sélectionne l'onglet "Volume" et clique sur "Ajouter un dossier". Là, je crée un nouveau dossier de base de données avec ce chemin de montage "/downfolder".
{{< gallery match="images/5/*.png" >}}
J'attribue des ports fixes pour le conteneur "Youtube-Downloader". Sans ports fixes, il se peut que le "Youtube-Downloader" s'exécute sur un autre port après un redémarrage.
{{< gallery match="images/6/*.png" >}}
Pour finir, je saisis encore deux variables d'environnement. La variable "MY_ID" est mon nom d'utilisateur et "MY_PW" mon mot de passe.
{{< gallery match="images/7/*.png" >}}
Après ces réglages, Downloader peut être lancé ! Ensuite, il est possible d'appeler le downloader via l'adresse IP de la station Synology et le port attribué, par exemple http://192.168.21.23:8070 .
{{< gallery match="images/8/*.png" >}}
Pour l'authentification, on prend le nom d'utilisateur et le mot de passe de MY_ID et MY_PW.
## Étape 4 : C'est parti
Maintenant, Youtube peut entrer des urls de vidéo et des urls de liste de lecture dans le champ "URL" et toutes les vidéos arrivent automatiquement dans le dossier de téléchargement de la station de disques Synology.
{{< gallery match="images/9/*.png" >}}
Dossier de téléchargement :
{{< gallery match="images/10/*.png" >}}