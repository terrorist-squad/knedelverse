+++
date = "2021-04-18"
title = "De grandes choses avec les conteneurs : son propre WallaBag sur le poste de disque Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "archiv", "wallabag"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210418-docker-WallaBag/index.fr.md"
+++
Wallabag est un programme permettant d'archiver des pages web ou des articles intéressants. Aujourd'hui, je montre comment installer un service Wallabag sur le disque dur Synology.
## Option pour les professionnels
En tant qu'utilisateur expérimenté de Synology, on peut bien sûr se connecter directement avec SSH et installer l'ensemble du setup via un fichier Docker Compose.
```
version: '3'
services:
  wallabag:
    image: wallabag/wallabag
    environment:
      - MYSQL_ROOT_PASSWORD=wallaroot
      - SYMFONY__ENV__DATABASE_DRIVER=pdo_mysql
      - SYMFONY__ENV__DATABASE_HOST=db
      - SYMFONY__ENV__DATABASE_PORT=3306
      - SYMFONY__ENV__DATABASE_NAME=wallabag
      - SYMFONY__ENV__DATABASE_USER=wallabag
      - SYMFONY__ENV__DATABASE_PASSWORD=wallapass
      - SYMFONY__ENV__DATABASE_CHARSET=utf8mb4
      - SYMFONY__ENV__DOMAIN_NAME=http://192.168.178.50:8089
      - SYMFONY__ENV__SERVER_NAME="Your wallabag instance"
      - SYMFONY__ENV__FOSUSER_CONFIRMATION=false
      - SYMFONY__ENV__TWOFACTOR_AUTH=false
    ports:
      - "8089:80"
    volumes:
      - ./wallabag/images:/var/www/wallabag/web/assets/images

  db:
    image: mariadb
    environment:
      - MYSQL_ROOT_PASSWORD=wallaroot
    volumes:
      - ./mariadb:/var/lib/mysql

```
Vous trouverez d'autres images Docker utiles pour une utilisation à domicile dans le [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Étape 1 : préparer le classeur wallabag
Je crée un nouveau répertoire appelé "wallabag" dans le répertoire Docker.
{{< gallery match="images/1/*.png" >}}

## Étape 2 : Installer la base de données
Ensuite, il faut créer une base de données. Je clique sur l'onglet "Registre" dans la fenêtre docker de Synology et je recherche "mariadb". Je sélectionne l'image docker "mariadb" et je clique ensuite sur le tag "latest".
{{< gallery match="images/2/*.png" >}}
Après le téléchargement de l'image, celle-ci est disponible sous forme d'image. Docker fait la distinction entre deux états, le conteneur "état dynamique" et l'image/image (état fixe). Avant de créer un conteneur à partir de l'image, il faut encore procéder à quelques réglages.
{{< gallery match="images/3/*.png" >}}
Ensuite, je clique sur "Paramètres avancés" et j'active le "Redémarrage automatique". Je sélectionne l'onglet "Volume" et clique sur "Ajouter un dossier". Là, je crée un nouveau dossier de base de données avec ce chemin de montage "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
Sous "Paramètres de port", tous les ports sont supprimés. Cela signifie que je sélectionne le port "3306" et que je le supprime en cliquant sur le bouton "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nom de la variable|Valeur|Qu'est-ce que c'est ?|
|--- | --- |---|
|TZ| Europe/Berlin	|Fuseau horaire|
|MYSQL_ROOT_PASSWORD	 | wallaroot |Mot de passe principal de la base de données.|
{{</table>}}
Pour finir, je saisis ces variables d'environnement:Voir :
{{< gallery match="images/6/*.png" >}}
Après ces réglages, le serveur Mariadb peut être démarré ! J'appuie partout sur "Appliquer".
{{< gallery match="images/7/*.png" >}}

## Étape 3 : installer le Wallabag
Je clique sur l'onglet "Registre" dans la fenêtre docker de Synology et je recherche "wallabag". Je sélectionne l'image docker "wallabag/wallabag" et je clique ensuite sur le tag "latest".
{{< gallery match="images/8/*.png" >}}
Je double-clique sur mon image wallabag. Ensuite, je clique sur "Paramètres avancés" et j'active ici aussi le "Redémarrage automatique".
{{< gallery match="images/9/*.png" >}}
Je choisis l'onglet "Volume" et je clique sur "Ajouter un dossier". Là, je crée un nouveau dossier avec ce chemin de montage "/var/www/wallabag/web/assets/images".
{{< gallery match="images/10/*.png" >}}
J'attribue des ports fixes pour le conteneur "wallabag". Sans ports fixes, il se pourrait que le "serveur wallabag" tourne sur un autre port après un redémarrage. Le premier port du conteneur peut être supprimé. L'autre port doit être mémorisé.
{{< gallery match="images/11/*.png" >}}
En outre, il faut encore créer un "lien" vers le conteneur "mariadb". Je clique sur l'onglet "Liens" et sélectionne le conteneur de la base de données. Il faut bien se souvenir de l'alias pour l'installation de wallabag.
{{< gallery match="images/12/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Umgebungsvariable	|Valeur|
|--- |---|
|MYSQL_ROOT_PASSWORD	|wallaroot|
|SYMFONY__ENV__DATABASE_DRIVER	|pdo_mysql|
|SYMFONY__ENV__DATABASE_HOST	|db|
|SYMFONY__ENV__DATABASE_PORT	|3306|
|SYMFONY__ENV__DATABASE_NAME	|wallabag|
|SYMFONY__ENV__DATABASE_USER	|wallabag|
|SYMFONY__ENV__DATABASE_PASSWORD	|wallapass|
|SYMFONY__ENV__DATABASE_CHARSET |utf8mb4|
|SYMFONY__ENV__DOMAIN_NAME	|"http://synology-ip:container-port" <- Veuillez modifier|
|SYMFONY__ENV__SERVER_NAME	|"Wallabag - Serveur"|
|SYMFONY__ENV__FOSUSER_CONFIRMATION	|false|
|SYMFONY__ENV__TWOFACTOR_AUTH	|false|
{{</table>}}
Pour finir, je saisis ces variables d'environnement:Voir :
{{< gallery match="images/13/*.png" >}}
Le conteneur peut maintenant être démarré. La création de la base de données peut éventuellement prendre un certain temps. Le comportement peut être observé dans les détails du conteneur.
{{< gallery match="images/14/*.png" >}}
J'appelle le serveur wallabag avec l'adresse IP de Synology et mon port de conteneur.
{{< gallery match="images/15/*.png" >}}
