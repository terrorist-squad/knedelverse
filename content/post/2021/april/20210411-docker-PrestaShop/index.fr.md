+++
date = "2021-04-11"
title = "Sortir de la crise de manière créative : une boutique en ligne professionnelle avec PrestaShop"
difficulty = "level-4"
tags = ["corona", "Docker", "docker-compose", "kreativ", "krise", "online-shop", "presta", "shop", "shopsystem"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210411-docker-PrestaShop/index.fr.md"
+++
PrestaShop est une plateforme européenne de commerce électronique open source qui, selon ses propres dires, compte actuellement plus de 300.000 installations. Aujourd'hui, j'installe ce logiciel PHP sur mon serveur. Ce tutoriel nécessite quelques connaissances de Linux, Docker et Docker Compose.
## Étape 1 : Installer PrestaShop
Je crée un nouveau répertoire nommé "prestashop" sur mon serveur :
{{< terminal >}}
mkdir prestashop
cd prestashop

{{</ terminal >}}
Ensuite, je vais dans le répertoire prestashop et j'y crée un nouveau fichier nommé "prestashop.yml" avec le contenu suivant.
```
version: '2'

services:
  mariadb:
    image: mysql:5.7
    environment:
      - MYSQL_ROOT_PASSWORD=admin
      - MYSQL_DATABASE=prestashop
      - MYSQL_USER=prestashop
      - MYSQL_PASSWORD=prestashop
    volumes:
      - ./mysql:/var/lib/mysql
    expose:
      - 3306
    networks:
      - shop-network
    restart: always

  prestashop:
    image: prestashop/prestashop:1.7.7.2
    ports:
      - 8090:80
    depends_on:
      - mariadb
    volumes:
      - ./prestadata:/var/www/html
      - ./prestadata/modules:/var/www/html/modules
      - ./prestadata/themes:/var/www/html/themes
      - ./prestadata/override:/var/www/html/override
    environment:
      - PS_INSTALL_AUTO=0
    networks:
      - shop-network
    restart: always

networks:
  shop-network:

```
Malheureusement, la version actuelle du Lastest n'a pas fonctionné pour moi, c'est pourquoi j'ai installé la version "1.7.7.2". Ce fichier est lancé via Docker-Compose :
{{< terminal >}}
docker-compose -f prestashop.yml up

{{</ terminal >}}
Le mieux est d'aller chercher un café frais, car le processus est très long. Ce n'est que lorsque le texte suivant apparaît que l'interface peut être utilisée.
{{< gallery match="images/1/*.png" >}}
Ensuite, je peux accéder à mon serveur PrestaShop et poursuivre l'installation via l'interface.
{{< gallery match="images/2/*.png" >}}
Je quitte Docker-Compose avec "Ctrl C" et j'appelle le sous-dossier "prestadata" ("cd prestadata"). Là, le dossier "install" doit être supprimé avec "rm -r install".
{{< gallery match="images/3/*.png" >}}
En outre, on y voit un dossier "admin", pour moi "admin697vqoryt". Je me souviendrai de ce code pour plus tard et je redémarrerai le serveur via Docker-Compose :
{{< terminal >}}
docker-compose -f prestashop.yml up -d

{{</ terminal >}}

## Étape 2 : Tester la boutique
Après le redémarrage, je teste mon installation Presta-Shop et j'appelle également l'interface admin sous "shop-url/Admin-Kürzel".
{{< gallery match="images/4/*.png" >}}