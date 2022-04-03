+++
date = "2021-04-18"
title = "Grandiose avec les conteneurs : installer son propre dokuWiki sur la station de disque Synology"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dokuwiki", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-dokuWiki/index.fr.md"
+++
DokuWiki est un logiciel wiki open source conforme aux standards, facile à utiliser et en même temps extrêmement polyvalent. Aujourd'hui, je montre comment installer un service dokuWiki sur le disque dur Synology.
## Option pour les professionnels
En tant qu'utilisateur expérimenté de Synology, on peut bien sûr se connecter directement avec SSH et installer l'ensemble du setup via un fichier Docker Compose.
```
version: '3'
services:
  dokuwiki:
    image:  bitnami/dokuwiki:latest
    restart: always
    ports:
      - 8080:8080
      - 8443:8443
    environment:
      TZ: 'Europe/Berlin'
      DOKUWIKI_USERNAME: 'admin'
      DOKUWIKI_FULL_NAME: 'wiki'
      DOKUWIKI_PASSWORD: 'password'
    volumes:
      - ./data:/bitnami/dokuwiki

```
Vous trouverez d'autres images Docker utiles pour une utilisation à domicile dans le [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Étape 1 : Préparer le dossier wiki
Je crée un nouveau répertoire appelé "wiki" dans le répertoire Docker.
{{< gallery match="images/1/*.png" >}}

## Étape 2 : Installer DokuWiki
Ensuite, il faut créer une base de données. Je clique sur l'onglet "Registre" dans la fenêtre docker de Synology et je recherche "dokuwiki". Je sélectionne l'image docker "bitnami/dokuwiki" et je clique ensuite sur le tag "latest".
{{< gallery match="images/2/*.png" >}}
Après le téléchargement de l'image, celle-ci est disponible sous forme d'image. Docker fait la distinction entre deux états, le conteneur "état dynamique" et l'image/image (état fixe). Je double-clique sur mon image dokuwiki.
{{< gallery match="images/3/*.png" >}}
J'attribue des ports fixes pour le conteneur "dokuwiki". Sans ports fixes, il se pourrait que le "serveur dokuwiki" tourne sur un autre port après un redémarrage.
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nom de la variable|Valeur|Qu'est-ce que c'est ?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Fuseau horaire|
|DOKUWIKI_USERNAME	| admin|Nom d'utilisateur admin|
|DOKUWIKI_FULL_NAME |	wiki	|Nom de Wiki|
|DOKUWIKI_PASSWORD	| password	|Mot de passe administrateur|
{{</table>}}
Pour finir, je saisis ces variables d'environnement:Voir :
{{< gallery match="images/5/*.png" >}}
Le conteneur peut maintenant être démarré. J'appelle le serveur dokuWIki avec l'adresse IP de Synology et mon port de conteneur.
{{< gallery match="images/6/*.png" >}}

