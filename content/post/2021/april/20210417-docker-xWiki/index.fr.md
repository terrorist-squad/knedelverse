+++
date = "2021-04-17"
title = "De grandes choses avec les conteneurs : faire fonctionner son propre xWiki sur le disque dur Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "xwiki", "wiki",]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210417-docker-xWiki/index.fr.md"
+++
XWiki est une plate-forme logicielle wiki gratuite, écrite en Java et dont la conception est axée sur l'extensibilité. Aujourd'hui, je montre comment installer un service xWiki sur le disque dur de Synology.
## Option pour les professionnels
En tant qu'utilisateur expérimenté de Synology, on peut bien sûr se connecter directement avec SSH et installer l'ensemble du setup via un fichier Docker Compose.
```
version: '3'
services:
  xwiki:
    image: xwiki:10-postgres-tomcat
    restart: always
    ports:
      - 8080:8080
    links:
      - db
    environment:
      DB_HOST: db
      DB_DATABASE: xwiki
      DB_DATABASE: xwiki
      DB_PASSWORD: xwiki
      TZ: 'Europe/Berlin'

  db:
    image: postgres:latest
    restart: always
    volumes:
      - ./postgresql:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=xwiki
      - POSTGRES_PASSWORD=xwiki
      - POSTGRES_DB=xwiki
      - TZ='Europe/Berlin'

```
Vous trouverez d'autres images Docker utiles pour une utilisation à domicile dans le [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Étape 1 : Préparer le dossier wiki
Je crée un nouveau répertoire appelé "wiki" dans le répertoire Docker.
{{< gallery match="images/1/*.png" >}}

## Étape 2 : Installer la base de données
Ensuite, il faut créer une base de données. Je clique sur l'onglet "Registre" dans la fenêtre docker de Synology et je recherche "postgres". Je sélectionne l'image docker "postgres" et je clique ensuite sur le tag "latest".
{{< gallery match="images/2/*.png" >}}
Après le téléchargement de l'image, celle-ci est disponible sous forme d'image. Docker fait la distinction entre deux états, le conteneur "état dynamique" et l'image/image (état fixe). Avant de créer un conteneur à partir de l'image, il faut encore procéder à quelques réglages.
{{< gallery match="images/3/*.png" >}}
Ensuite, je clique sur "Paramètres avancés" et j'active le "Redémarrage automatique". Je sélectionne l'onglet "Volume" et clique sur "Ajouter un dossier". Là, je crée un nouveau dossier de base de données avec ce chemin de montage "/var/lib/postgresql/data".
{{< gallery match="images/4/*.png" >}}
Sous "Paramètres de port", tous les ports sont supprimés. Cela signifie que je sélectionne le port "5432" et que je le supprime en cliquant sur le bouton "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nom de la variable|Valeur|Qu'est-ce que c'est ?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Fuseau horaire|
|POSTGRES_DB	| xwiki |C'est le nom de la base de données.|
|POSTGRES_USER	| xwiki |Nom d'utilisateur de la base de données wiki.|
|POSTGRES_PASSWORD	| xwiki |Mot de passe de l'utilisateur de la base de données wiki.|
{{</table>}}
Pour finir, j'inscris ces quatre variables d'environnement:Voir :
{{< gallery match="images/6/*.png" >}}
Après ces réglages, le serveur Mariadb peut être démarré ! J'appuie partout sur "Appliquer".
## Étape 3 : installer xWiki
Je clique sur l'onglet "Registre" dans la fenêtre docker de Synology et je recherche "xwiki". Je sélectionne l'image docker "xwiki" et je clique ensuite sur le tag "10-postgres-tomcat".
{{< gallery match="images/7/*.png" >}}
Je double-clique sur mon image xwiki. Ensuite, je clique sur "Paramètres avancés" et j'active ici aussi le "Redémarrage automatique".
{{< gallery match="images/8/*.png" >}}
J'attribue des ports fixes pour le conteneur "xwiki". Sans ports fixes, il se pourrait que le "serveur xwiki" tourne sur un autre port après un redémarrage.
{{< gallery match="images/9/*.png" >}}
En outre, il faut encore créer un "lien" vers le conteneur "postgres". Je clique sur l'onglet "Liens" et sélectionne le conteneur de la base de données. Il faut bien se souvenir de l'alias pour l'installation du wiki.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nom de la variable|Valeur|Qu'est-ce que c'est ?|
|--- | --- |---|
|TZ |	Europe/Berlin	|Fuseau horaire|
|DB_HOST	| db |Alias / Lien du conteneur|
|DB_DATABASE	| xwiki	|Données de l'étape 2|
|DB_USER	| xwiki	|Données de l'étape 2|
|DB_PASSWORD	| xwiki |Données de l'étape 2|
{{</table>}}
Pour finir, je saisis ces variables d'environnement:Voir :
{{< gallery match="images/11/*.png" >}}
Le conteneur peut maintenant être démarré. J'appelle le serveur xWiki avec l'adresse IP de Synology et mon port de conteneur.
{{< gallery match="images/12/*.png" >}}