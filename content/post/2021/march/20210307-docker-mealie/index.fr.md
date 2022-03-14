+++
date = "2021-03-07"
title = "Du grand avec les conteneurs : gérer et archiver des recettes sur le diskstation de Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "rezepte", "speisen", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-docker-mealie/index.fr.md"
+++
Rassemblez toutes vos recettes préférées dans le conteneur Docker et organisez-les comme vous le souhaitez. Écrivez vos propres recettes ou importez des recettes de sites web, par exemple "Chefkoch", "Essen", etc.
{{< gallery match="images/1/*.png" >}}

## Option pour les professionnels
En tant qu'utilisateur expérimenté de Synology, on peut bien sûr se connecter directement avec SSH et installer l'ensemble du setup via un fichier Docker Compose.
```
version: "2.0"
services:
  mealie:
    container_name: mealie
    image: hkotel/mealie:latest
    restart: always
    ports:
      - 9000:80
    environment:
      db_type: sqlite
      TZ: Europa/Berlin
    volumes:
      - ./mealie/data/:/app/data

```

## Étape 1 : Trouver une image Docker
Je clique sur l'onglet "Registre" dans la fenêtre docker de Synology et je recherche "mealie". Je sélectionne l'image docker "hkotel/mealie:latest" et je clique ensuite sur le tag "latest".
{{< gallery match="images/2/*.png" >}}
Après le téléchargement de l'image, celle-ci est disponible sous forme d'image. Docker fait la distinction entre deux états, le conteneur "état dynamique" et l'image/image (état fixe). Avant de créer un conteneur à partir de l'image, il faut encore procéder à quelques réglages.
## Étape 2 : Mettre l'image en service :
Je double-clique sur mon image "mealie".
{{< gallery match="images/3/*.png" >}}
Ensuite, je clique sur "Paramètres avancés" et j'active le "Redémarrage automatique". Je sélectionne l'onglet "Volume" et clique sur "Ajouter un dossier". Là, je crée un nouveau dossier avec ce chemin de montage "/app/data".
{{< gallery match="images/4/*.png" >}}
J'attribue des ports fixes pour le conteneur "Mealie". Sans ports fixes, il se pourrait que le "serveur Mealie" tourne sur un autre port après un redémarrage.
{{< gallery match="images/5/*.png" >}}
Pour finir, je saisis encore deux variables d'environnement. La variable "db_type" est le type de base de données et "TZ" le fuseau horaire "Europe/Berlin".
{{< gallery match="images/6/*.png" >}}
Après ces réglages, le serveur Mealie peut être démarré ! Ensuite, il est possible d'appeler Mealie via l'adresse Ip de la dictée Synology et le port attribué, par exemple http://192.168.21.23:8096 .
{{< gallery match="images/7/*.png" >}}

## Comment fonctionne Mealie ?
Si je passe la souris sur le bouton "plus" à droite/en bas et que je clique ensuite sur le symbole "chaîne", je peux saisir une url. L'application Mealie recherche alors elle-même les méta-informations et les informations de schéma dont elle a besoin.
{{< gallery match="images/8/*.png" >}}
L'importation fonctionne très bien (j'ai utilisé ces fonctions avec des urls de Chefkoch, Essen
{{< gallery match="images/9/*.png" >}}
En mode édition, je peux aussi ajouter une catégorie. Il est important que j'appuie une fois sur la touche "Entrée" après chaque catégorie. Sinon, ce paramètre n'est pas pris en compte.
{{< gallery match="images/10/*.png" >}}

## Particularités
J'ai remarqué que les catégories de menu ne s'actualisent pas automatiquement. Il faut y remédier par un rechargement du navigateur.
{{< gallery match="images/11/*.png" >}}

## Autres caractéristiques
Il est bien sûr possible de rechercher des recettes et de créer des menus. En outre, il est possible de personnaliser "Mealie" de manière très étendue.
{{< gallery match="images/12/*.png" >}}
Mealie est également superbe sur le téléphone portable :
{{< gallery match="images/13/*.*" >}}

## Api résiduelle
Sous "http://gewaehlte-ip:und-port ... /docs", on trouve la documentation de l'API. On y trouve de nombreuses méthodes qui peuvent être utilisées pour une automatisation.
{{< gallery match="images/14/*.png" >}}

## Exemple d'api
Imaginez la fiction suivante : "Gruner und Jahr lance le portail Internet Essen
{{< terminal >}}
wget --spider --force-html -r -l12  "https://www.essen-und-trinken.de/rezepte/archiv/"  2>&1 | grep '/rezepte/' | grep '^--' | awk '{ print $3 }' > liste.txt

{{</ terminal >}}
Ensuite, vous nettoyez cette liste et la tirez contre l'api résiduelle, exemple :
```
#!/bin/bash
sort -u liste.txt > clear.txt

while read p; do
  echo "import url: $p"
  curl -d "{\"url\":\"$p\"}" -H "Content-Type: application/json" http://synology-ip:8096/api/recipes/create-url
  sleep 1
done < clear.txt

```
Désormais, vous pouvez également accéder aux recettes hors ligne :
{{< gallery match="images/15/*.png" >}}
