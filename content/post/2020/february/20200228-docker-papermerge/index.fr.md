+++
date = "2020-02-28"
title = "De grandes choses avec les conteneurs : faire fonctionner Papermerge DMS sur un NAS Synology"
difficulty = "level-3"
tags = ["archiv", "automatisch", "dms", "Docker", "Document-Managment-System", "google", "ocr", "papermerge", "Synology", "tesseract", "texterkennung"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200228-docker-papermerge/index.fr.md"
+++
Papermerge est un jeune système de gestion de documents (DMS) qui permet de classer et de traiter automatiquement des documents. Dans ce tutoriel, je montre comment j'ai installé Papermerge sur mon disque dur Synology et comment le DMS fonctionne.
## Option pour les professionnels
En tant qu'utilisateur expérimenté de Synology, on peut bien sûr se connecter directement avec SSH et installer l'ensemble du setup via un fichier Docker Compose.
```
version: "2.1"
services:
  papermerge:
    image: ghcr.io/linuxserver/papermerge
    container_name: papermerge
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./config>:/config
      - ./appdata/data>:/data
    ports:
      - 8090:8000
    restart: unless-stopped

```

## Étape 1 : Créer un dossier
Tout d'abord, je crée un dossier pour la paperasse. J'accède au "Contrôle du système" -> "Dossier partagé" et je crée un nouveau dossier "Archives de documents".
{{< gallery match="images/1/*.png" >}}
Étape 2 : Rechercher une image DockerDans la fenêtre Docker de Synology, je clique sur l'onglet "Registre" et je recherche "Papermerge". Je sélectionne l'image docker "linuxserver/papermerge" et je clique ensuite sur le tag "latest".
{{< gallery match="images/2/*.png" >}}
Après le téléchargement de l'image, celle-ci est disponible sous forme d'image. Docker fait la distinction entre deux états, le conteneur "état dynamique" et l'image/image (état fixe). Avant de créer un conteneur à partir de l'image, il faut encore procéder à quelques réglages.
## Etape 3 : Mettre l'image en service :
Je double-clique sur mon image Papermerge.
{{< gallery match="images/3/*.png" >}}
Ensuite, je clique sur "Paramètres avancés" et j'active le "Redémarrage automatique". Je sélectionne l'onglet "Volume" et clique sur "Ajouter un dossier". Là, je crée un nouveau dossier de base de données avec ce chemin de montage "/data".
{{< gallery match="images/4/*.png" >}}
En outre, je crée ici un deuxième dossier que j'intègre avec le chemin de montage "/config". L'endroit où il se trouve n'a pas d'importance. Il est cependant important qu'il appartienne à l'utilisateur admin de Synology.
{{< gallery match="images/5/*.png" >}}
J'attribue des ports fixes pour le conteneur "Papermerge". Sans ports fixes, il se pourrait que le "serveur Papermerge" soit exécuté sur un autre port après un redémarrage.
{{< gallery match="images/6/*.png" >}}
Pour finir, j'inscris encore trois variables d'environnement. La variable "PUID" est l'identifiant de l'utilisateur et "PGID" l'identifiant du groupe de mon utilisateur admin. On peut trouver le PGID/PUID via SSH avec la commande "cat /etc/passwd | grep admin".
{{< gallery match="images/7/*.png" >}}
Après ces réglages, le serveur Papermerge peut être démarré ! Ensuite, il est possible d'appeler Papermerge via l'adresse IP de la station Synology et le port attribué, par exemple http://192.168.21.23:8095.
{{< gallery match="images/8/*.png" >}}
Le login par défaut est admin avec le mot de passe admin.
## Comment fonctionne Papermerge ?
Papermerge analyse les textes des documents et des images. Pour ce faire, Papermerge utilise une bibliothèque OCR/"optical character recognition" publiée par Goolge et appelée tesseract.
{{< gallery match="images/9/*.png" >}}
J'ai créé un dossier appelé "Tout avec Lorem" pour tester l'attribution automatique des documents. Ensuite, j'ai cliqué sur l'option de menu "Automates" pour créer un nouveau modèle de reconnaissance.
{{< gallery match="images/10/*.png" >}}
Tous les nouveaux documents qui contiennent le mot "Lorem" sont classés dans le dossier "Tout avec Lorem" et munis de la balise "a-lorem". Il est important d'utiliser une virgule dans les tags. Si je télécharge un document correspondant, il sera tagué et classé.
{{< gallery match="images/11/*.png" >}}
