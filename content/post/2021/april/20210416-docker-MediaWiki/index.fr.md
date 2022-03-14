+++
date = "2021-04-16"
title = "De grandes choses avec les conteneurs : installer son propre MediaWiki sur le disque dur Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "mediawiki", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-MediaWiki/index.fr.md"
+++
MediaWiki est un système wiki basé sur PHP, qui est disponible gratuitement en tant que produit open source. Aujourd'hui, je montre comment installer un service MediaWiki sur le Diskstation de Synology.
## Option pour les professionnels
En tant qu'utilisateur expérimenté de Synology, on peut bien sûr se connecter directement avec SSH et installer l'ensemble du setup via un fichier Docker Compose.
```
version: '3'
services:
  mediawiki:
    image: mediawiki
    restart: always
    ports:
      - 8081:80
    links:
      - database
    volumes:
      - ./images:/var/www/html/images
      # After initial setup, download LocalSettings.php to the same directory as
      # this yaml and uncomment the following line and use compose to restart
      # the mediawiki service
      # - ./LocalSettings.php:/var/www/html/LocalSettings.php

  database:
    image: mariadb
    restart: always
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      # @see https://phabricator.wikimedia.org/source/mediawiki/browse/master/includes/DefaultSettings.php
      MYSQL_ROOT_PASSWORD: my_wiki_pass1
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
Vous trouverez d'autres images Docker utiles pour une utilisation à domicile dans le [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Étape 1 : Préparer le dossier MediaWiki
Je crée un nouveau répertoire appelé "wiki" dans le répertoire Docker.
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
|TZ	| Europe/Berlin	|Fuseau horaire|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass	|Mot de passe principal de la base de données.|
|MYSQL_DATABASE |	my_wiki	|C'est le nom de la base de données.|
|MYSQL_USER	| wikiuser |Nom d'utilisateur de la base de données wiki.|
|MYSQL_PASSWORD	| my_wiki_pass |Mot de passe de l'utilisateur de la base de données wiki.|
{{</table>}}
Pour finir, je saisis ces variables d'environnement:Voir :
{{< gallery match="images/6/*.png" >}}
Après ces réglages, le serveur Mariadb peut être démarré ! J'appuie partout sur "Appliquer".
## Étape 3 : installer MediaWiki
Je clique sur l'onglet "Registre" dans la fenêtre docker de Synology et je recherche "mediawiki". Je sélectionne l'image docker "mediawiki" et je clique ensuite sur le tag "latest".
{{< gallery match="images/7/*.png" >}}
Je double-clique sur mon image Mediawiki.
{{< gallery match="images/8/*.png" >}}
Ensuite, je clique sur "Paramètres avancés" et j'active ici aussi le "Redémarrage automatique". Je sélectionne l'onglet "Volume" et clique sur "Ajouter un dossier". Là, je crée un nouveau dossier avec ce chemin de montage "/var/www/html/images".
{{< gallery match="images/9/*.png" >}}
J'attribue des ports fixes pour le conteneur "MediaWiki". Sans ports fixes, il se pourrait que le "serveur MediaWiki" s'exécute sur un autre port après un redémarrage.
{{< gallery match="images/10/*.png" >}}
En outre, il faut encore créer un "lien" vers le conteneur "mariadb". Je clique sur l'onglet "Liens" et sélectionne le conteneur de la base de données. Il faut bien se souvenir du nom d'alias pour l'installation du wiki.
{{< gallery match="images/11/*.png" >}}
Pour finir, je saisis une variable d'environnement "TZ" avec la valeur "Europe/Berlin".
{{< gallery match="images/12/*.png" >}}
Le conteneur peut maintenant être démarré. J'appelle le serveur Mediawiki avec l'adresse IP de Synology et mon port de conteneur. Pour le serveur de base de données, je saisis l'alias du conteneur de base de données. Je saisis également le nom de la base de données, le nom d'utilisateur et le mot de passe de "l'étape 2".
{{< gallery match="images/13/*.png" >}}