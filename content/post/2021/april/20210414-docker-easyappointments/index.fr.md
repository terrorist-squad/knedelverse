+++
date = "2021-04-16"
title = "Sortir de la crise de manière créative : réserver un service avec easyappointments"
difficulty = "level-3"
tags = ["buchung", "buchungstool", "click-and-meet", "corona", "Docker", "docker-compose", "easyappointments", "krise", "einzelhandel", "geschaefte"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210414-docker-easyappointments/index.fr.md"
+++
La crise Corona frappe de plein fouet les prestataires de services en Allemagne. Les outils et solutions numériques peuvent aider à traverser la pandémie Corona de la manière la plus sûre possible. Dans cette série de tutoriels "Créer pour sortir de la crise", je présente des technologies ou des outils qui peuvent être utiles aux petites entreprises.Aujourd'hui, je présente "Easyappointments", un outil de réservation "click and meet" pour les services, par exemple les coiffeurs ou les magasins. Easyappointments se compose de deux parties :
## Domaine 1 : Backend
Un "backend" pour la gestion des services et des rendez-vous.
{{< gallery match="images/1/*.png" >}}

## Domaine 2 : Frontend
Un outil d'utilisateur final pour la réservation de rendez-vous. Tous les rendez-vous déjà réservés sont ensuite bloqués et ne peuvent pas être réservés deux fois.
{{< gallery match="images/2/*.png" >}}

## Installation
J'ai déjà installé plusieurs fois Easyappointments avec Docker-Compose et je recommande vivement ce type d'installation. Je crée un nouveau répertoire appelé "easyappointments" sur mon serveur :
{{< terminal >}}
mkdir easyappointments
cd easyappointments

{{</ terminal >}}
Ensuite, je vais dans le répertoire easyappointments et j'y crée un nouveau fichier appelé "easyappointments.yml" avec le contenu suivant :
```
version: '2'
services:
  db:
    image: mysql
    environment:
      - MYSQL_ROOT_PASSWORD=root
      - MYSQL_DATABASE=easyappointments
      - MYSQL_USER=easyappointments
      - MYSQL_PASSWORD=easyappointments
    command: mysqld --default-authentication-plugin=mysql_native_password
    volumes:
      - ./easy-appointments-data:/var/lib/mysql
    expose:
      - 3306
    networks:
      - easyappointments-network
    restart: always

  application:
    image: jamrizzi/easyappointments
    volumes:
      - ./easy-appointments:/app/www
    depends_on:
      - db
    ports:
      - 8089:8888
    environment:
      - DB_HOST=db
      - DB_USERNAME=easyappointments
      - DB_NAME=easyappointments
      - DB_PASSWORD=easyappointments
      - TZ=Europe/Berlin
      - BASE_URL=http://192.168.178.50:8089 
    networks:
      - easyappointments-network
    restart: always

networks:
  easyappointments-network:

```
Ce fichier est lancé via Docker-Compose. L'installation est ensuite accessible sous le domaine/port prévu.
{{< terminal >}}
docker-compose -f easyappointments.yml up

{{</ terminal >}}

## Créer un service
Les services peuvent être créés sous "Services". Chaque nouveau service doit ensuite être attribué à un prestataire de services/utilisateur. Cela signifie que je peux réserver des collaborateurs/prestataires de services spécialisés.
{{< gallery match="images/3/*.png" >}}
L'utilisateur final peut également choisir le service et le prestataire de services qu'il préfère.
{{< gallery match="images/4/*.png" >}}

## Horaires de travail et pauses
Les heures de service générales peuvent être réglées sous "Settings" > "Business Logic". Mais on peut aussi modifier les heures de service des prestataires de services/utilisateurs dans le "Working plan" de l'utilisateur.
{{< gallery match="images/5/*.png" >}}

## Aperçu des réservations et agenda
L'agenda rend toutes les réservations visibles. Il est bien sûr possible d'y créer ou d'y éditer des réservations.
{{< gallery match="images/6/*.png" >}}

## Adaptation des couleurs ou de la logique
Si l'on copie le répertoire "/app/www" et qu'on l'intègre comme "volume", on peut alors adapter les feuilles de style et la logique à volonté.
{{< gallery match="images/7/*.png" >}}