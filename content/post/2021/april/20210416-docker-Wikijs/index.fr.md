+++
date = "2021-04-16"
title = "Du grand avec les conteneurs : installer Wiki.js sur le disque dur Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "wikijs", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-Wikijs/index.fr.md"
+++
Wiki.js est un puissant logiciel wiki open source dont l'interface simple fait de la documentation un plaisir. Aujourd'hui, je montre comment installer un service Wiki.js sur le diskstation Synology.
## Option pour les professionnels
En tant qu'utilisateur expérimenté de Synology, on peut bien sûr se connecter directement avec SSH et installer l'ensemble du setup via un fichier Docker Compose.
```
version: '3'
services:
  wikijs:
    image: requarks/wiki:latest
    restart: always
    ports:
      - 8082:3000
    links:
      - database
    environment:
      DB_TYPE: mysql
      DB_HOST: database
      DB_PORT: 3306
      DB_NAME: my_wiki
      DB_USER: wikiuser
      DB_PASS: my_wiki_pass
      TZ: 'Europe/Berlin'

  database:
    image: mysql
    restart: always
    expose:
      - 3306
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: my_wiki_pass
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
Vous trouverez d'autres images Docker utiles pour une utilisation à domicile dans le Dockerverse.
## Étape 1 : Préparer le dossier wiki
Je crée un nouveau répertoire appelé "wiki" dans le répertoire Docker.
{{< gallery match="images/1/*.png" >}}

## Étape 2 : Installer la base de données
Ensuite, il faut créer une base de données. Je clique sur l'onglet "Registre" dans la fenêtre docker de Synology et je recherche "mysql". Je sélectionne l'image docker "mysql" et je clique ensuite sur le tag "latest".
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
|TZ	| Europe/Berlin |Fuseau horaire|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass |Mot de passe principal de la base de données.|
|MYSQL_DATABASE |	my_wiki |C'est le nom de la base de données.|
|MYSQL_USER	| wikiuser |Nom d'utilisateur de la base de données wiki.|
|MYSQL_PASSWORD |	my_wiki_pass	|Mot de passe de l'utilisateur de la base de données wiki.|
{{</table>}}
Pour finir, j'inscris ces quatre variables d'environnement:Voir :
{{< gallery match="images/6/*.png" >}}
Après ces réglages, le serveur Mariadb peut être démarré ! J'appuie partout sur "Appliquer".
## Étape 3 : Installer Wiki.js
Je clique sur l'onglet "Registre" dans la fenêtre docker de Synology et je recherche "wiki". Je sélectionne l'image docker "requarks/wiki" et je clique ensuite sur le tag "latest".
{{< gallery match="images/7/*.png" >}}
Je double-clique sur mon image WikiJS. Ensuite, je clique sur "Paramètres avancés" et j'active ici aussi le "Redémarrage automatique".
{{< gallery match="images/8/*.png" >}}
J'attribue des ports fixes pour le conteneur "WikiJS". Sans ports fixes, il se pourrait que le "serveur bookstack" tourne sur un autre port après un redémarrage.
{{< gallery match="images/9/*.png" >}}
En outre, il faut encore créer un "lien" vers le conteneur "mysql". Je clique sur l'onglet "Liens" et sélectionne le conteneur de la base de données. Il faut bien se souvenir de l'alias pour l'installation du wiki.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nom de la variable|Valeur|Qu'est-ce que c'est ?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Fuseau horaire|
|DB_HOST	| wiki-db	|Alias / Lien du conteneur|
|DB_TYPE	| mysql	||
|DB_PORT	| 3306	 ||
|DB_PASSWORD	| my_wiki	|Données de l'étape 2|
|DB_USER	| wikiuser |Données de l'étape 2|
|DB_PASS	| my_wiki_pass	|Données de l'étape 2|
{{</table>}}
Pour finir, je saisis ces variables d'environnement:Voir :
{{< gallery match="images/11/*.png" >}}
Le conteneur peut maintenant être lancé. J'appelle le serveur Wiki.js avec l'adresse IP de Synology et mon port de conteneur/3000.
{{< gallery match="images/12/*.png" >}}
