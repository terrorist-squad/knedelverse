+++
date = "2021-04-16"
title = "De grandes choses avec les conteneurs : un propre wiki Bookstack sur le disque dur Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "bookstack", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-Bookstack/index.fr.md"
+++
Bookstack est une alternative "open source" à MediaWiki ou Confluence. Aujourd'hui, je montre comment installer un service Bookstack sur le disque dur Synology.
## Option pour les professionnels
En tant qu'utilisateur expérimenté de Synology, on peut bien sûr se connecter directement avec SSH et installer l'ensemble du setup via un fichier Docker Compose.
```
version: '3'
services:
  bookstack:
    image: solidnerd/bookstack:0.27.4-1
    restart: always
    ports:
      - 8080:8080
    links:
      - database
    environment:
      DB_HOST: database:3306
      DB_DATABASE: my_wiki
      DB_USERNAME: wikiuser
      DB_PASSWORD: my_wiki_pass
      
  database:
    image: mariadb
    restart: always
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: my_wiki_pass1
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
Vous trouverez d'autres images Docker utiles pour une utilisation à domicile dans le [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Étape 1 : Préparer le dossier Bookstack
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
|TZ	| Europe/Berlin |Fuseau horaire|
|MYSQL_ROOT_PASSWORD	|  my_wiki_pass |Mot de passe principal de la base de données.|
|MYSQL_DATABASE | 	my_wiki	|C'est le nom de la base de données.|
|MYSQL_USER	|  wikiuser	|Nom d'utilisateur de la base de données wiki.|
|MYSQL_PASSWORD	|  my_wiki_pass	|Mot de passe de l'utilisateur de la base de données wiki.|
{{</table>}}
Pour finir, je saisis ces variables d'environnement:Voir :
{{< gallery match="images/6/*.png" >}}
Après ces réglages, le serveur Mariadb peut être démarré ! J'appuie partout sur "Appliquer".
## Étape 3 : installer Bookstack
Je clique sur l'onglet "Registre" dans la fenêtre docker de Synology et je recherche "bookstack". Je sélectionne l'image docker "solidnerd/bookstack" et je clique ensuite sur le tag "latest".
{{< gallery match="images/7/*.png" >}}
Je double-clique sur mon image Bookstack. Ensuite, je clique sur "Paramètres avancés" et j'active ici aussi le "Redémarrage automatique".
{{< gallery match="images/8/*.png" >}}
J'attribue des ports fixes pour le conteneur "bookstack". Sans ports fixes, il se pourrait que le "serveur bookstack" tourne sur un autre port après un redémarrage. Le premier port du conteneur peut être supprimé. L'autre port doit être mémorisé.
{{< gallery match="images/9/*.png" >}}
En outre, il faut encore créer un "lien" vers le conteneur "mariadb". Je clique sur l'onglet "Liens" et sélectionne le conteneur de la base de données. Il faut bien se souvenir du nom d'alias pour l'installation du wiki.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nom de la variable|Valeur|Qu'est-ce que c'est ?|
|--- | --- |---|
|TZ	| Europe/Berlin |Fuseau horaire|
|DB_HOST	| wiki-db:3306	|Alias / Lien du conteneur|
|DB_DATABASE	| my_wiki |Données de l'étape 2|
|DB_USERNAME	| wikiuser |Données de l'étape 2|
|DB_PASSWORD	| my_wiki_pass	|Données de l'étape 2|
{{</table>}}
Pour finir, je saisis ces variables d'environnement:Voir :
{{< gallery match="images/11/*.png" >}}
Le conteneur peut maintenant être démarré. La création de la base de données peut éventuellement prendre un certain temps. Le comportement peut être observé dans les détails du conteneur.
{{< gallery match="images/12/*.png" >}}
J'appelle le serveur Bookstack avec l'adresse IP de Synology et mon port de conteneur. Le nom de connexion est "admin@admin.com" et le mot de passe est "password".
{{< gallery match="images/13/*.png" >}}

