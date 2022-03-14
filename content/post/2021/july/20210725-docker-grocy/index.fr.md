+++
date = "2021-07-25"
title = "De grandes choses avec les conteneurs : la gestion des réfrigérateurs avec Grocy"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "kühlschrank", "erp", "mhd", "Speispläne", "cms", "Cafe", "Bistro"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/july/20210725-docker-grocy/index.fr.md"
+++
Avec Grocy, on peut gérer tout un ménage, un restaurant, un café, un bistrot ou une épicerie. On peut gérer les réfrigérateurs, les menus, les tâches, les listes de courses et la durée de conservation des aliments.
{{< gallery match="images/1/*.png" >}}
Aujourd'hui, je montre comment installer un service Grocy sur le diskstation Synology.
## Option pour les professionnels
En tant qu'utilisateur expérimenté de Synology, on peut bien sûr se connecter directement avec SSH et installer l'ensemble du setup via un fichier Docker Compose.
```
version: "2.1"
services:
  grocy:
    image: ghcr.io/linuxserver/grocy
    container_name: grocy
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./data:/config
    ports:
      - 9283:80
    restart: unless-stopped

```
Vous trouverez d'autres images Docker utiles pour une utilisation à domicile dans le [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Étape 1 : Préparer le dossier Grocy
Je crée un nouveau répertoire appelé "grocy" dans le répertoire Docker.
{{< gallery match="images/2/*.png" >}}

## Étape 2 : installer Grocy
Je clique sur l'onglet "Registre" dans la fenêtre docker de Synology et je recherche "Grocy". Je sélectionne l'image docker "linuxserver/grocy:latest" et je clique ensuite sur le tag "latest".
{{< gallery match="images/3/*.png" >}}
Je double-clique sur mon image Grocy.
{{< gallery match="images/4/*.png" >}}
Ensuite, je clique sur "Paramètres avancés" et j'active ici aussi le "Redémarrage automatique". Je sélectionne l'onglet "Volume" et clique sur "Ajouter un dossier". Là, je crée un nouveau dossier avec ce chemin de montage "/config".
{{< gallery match="images/5/*.png" >}}
J'attribue des ports fixes pour le conteneur "Grocy". Sans ports fixes, il se pourrait que le "serveur Grocy" tourne sur un autre port après un redémarrage.
{{< gallery match="images/6/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nom de la variable|Valeur|Qu'est-ce que c'est ?|
|--- | --- |---|
|TZ | Europe/Berlin |Fuseau horaire|
|PUID | 1024 |ID utilisateur de l'utilisateur admin Synology|
|PGID |	100 |ID de groupe de l'utilisateur admin Synology|
{{</table>}}
Pour finir, je saisis ces variables d'environnement:Voir :
{{< gallery match="images/7/*.png" >}}
Le conteneur peut maintenant être démarré. J'appelle le serveur Grocy avec l'adresse IP de Synology et mon port de conteneur et je me connecte avec le nom d'utilisateur "admin" et le mot de passe "admin".
{{< gallery match="images/8/*.png" >}}
