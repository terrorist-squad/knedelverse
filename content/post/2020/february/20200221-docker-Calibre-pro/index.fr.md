+++
date = "2020-02-21"
title = "De grandes choses avec les conteneurs : faire fonctionner Calibre avec Docker-Compose (Synology-Profi-Setup)"
difficulty = "level-3"
tags = ["calibre", "calibre-web", "Docker", "docker-compose", "Synology", "linux"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200221-docker-Calibre-pro/index.fr.md"
+++
Il existe déjà un tutoriel plus simple sur ce blog : [Synology-Nas : Installer Calibre Web comme bibliothèque d'ebooks]({{< ref "post/2020/february/20200213-synology-calibreweb" >}} "Synology-Nas : Installer Calibre Web comme bibliothèque d'ebooks"). Ce tutoriel est destiné à tous les professionnels de Synology-DS.
## Étape 1 : Préparer Synology
La première chose à faire est d'activer le login SSH sur le Diskstation. Pour cela, il faut aller dans le "Panneau de configuration" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Ensuite, on peut se connecter via "SSH", le port indiqué et le mot de passe de l'administrateur (les utilisateurs de Windows utilisent Putty ou WinSCP).
{{< gallery match="images/2/*.png" >}}
Je me connecte via Terminal, winSCP ou Putty et je laisse cette console ouverte pour plus tard.
## Étape 2 : Créer un dossier de livres
Je crée un nouveau dossier pour la bibliothèque Calibre. Pour cela, je vais dans "Contrôle du système" -> "Dossier partagé" et je crée un nouveau dossier "Buecher". S'il n'y a pas encore de dossier "Docker", il faut le créer.
{{< gallery match="images/3/*.png" >}}

## Étape 3 : Préparer le dossier de livres
Il faut maintenant télécharger et décompresser le fichier suivant : https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view. Le contenu ("metadata.db") doit être placé dans le nouveau répertoire de livres, voir :
{{< gallery match="images/4/*.png" >}}

## Étape 4 : Préparer le dossier Docker
Je crée un nouveau répertoire appelé "calibre" dans le répertoire Docker :
{{< gallery match="images/5/*.png" >}}
Ensuite, je passe dans le nouveau répertoire et j'y crée un nouveau fichier appelé "calibre.yml" avec le contenu suivant :
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre:/briefkaste
    ports:
      - 8055:8083
    restart: unless-stopped

```
Dans ce nouveau fichier, plusieurs endroits doivent être adaptés comme suit:* PUID/PGID : dans PUID/PGID, l'ID d'utilisateur et de groupe de l'utilisateur DS doit être saisi. J'utilise ici la console de "l'étape 1" et les commandes "id -u" pour voir l'ID de l'utilisateur. Avec la commande "id -g", j'obtiens l'ID de groupe.* ports : pour les ports, la partie avant "8055 :" doit être adaptée.RépertoiresTous les répertoires de ce fichier doivent être corrigés. Les adresses correctes sont visibles dans la fenêtre de propriétés de la DS. (Capture d'écran à venir)
{{< gallery match="images/6/*.png" >}}

## Étape 5 : Démarrage du test
Pour cette étape également, je peux utiliser la console. Je passe dans le répertoire Calibre et j'y démarre le serveur Calibre via Docker-Compose.
{{< terminal >}}
cd /volume1/docker/calibre
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}

{{< gallery match="images/7/*.png" >}}

## Étape 6 : Mise en place
Ensuite, je peux appeler mon serveur Calibre avec l'IP de la station de disques et le port attribué à l'"étape 4". Dans le setup, j'utilise mon point de montage "/books". Ensuite, le serveur est déjà utilisable.
{{< gallery match="images/8/*.png" >}}

## Étape 7 : Finalisation de la configuration
La console est également nécessaire à cette étape. J'utilise la commande "exec" pour sauvegarder la base de données de l'application interne au conteneur.
{{< terminal >}}
sudo docker exec -it calibre-web-server cp /app/calibre-web/app.db /briefkaste/app.db

{{</ terminal >}}
Ensuite, je vois un nouveau fichier "app.db" dans le répertoire Calibre :
{{< gallery match="images/9/*.png" >}}
Ensuite, j'arrête le serveur Calibre :
{{< terminal >}}
sudo docker-compose -f calibre.yml down

{{</ terminal >}}
Je modifie maintenant le chemin d'accès à la boîte aux lettres et je persiste dans la base de données de l'application.
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre/app.db:/app/calibre-web/app.db
    ports:
      - 8055:8083
    restart: unless-stopped

```
Le serveur peut ensuite être redémarré :
{{< terminal >}}
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}