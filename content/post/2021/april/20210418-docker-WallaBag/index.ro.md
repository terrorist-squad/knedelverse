+++
date = "2021-04-18"
title = "Lucruri grozave cu containere: WallaBag propriu pe stația de discuri Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "archiv", "wallabag"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210418-docker-WallaBag/index.ro.md"
+++
Wallabag este un program de arhivare a site-urilor sau articolelor interesante. Astăzi vă arăt cum să instalați un serviciu Wallabag pe stația de discuri Synology.
## Opțiune pentru profesioniști
În calitate de utilizator experimentat Synology, vă puteți, desigur, conecta cu SSH și instala întreaga configurație prin intermediul fișierului Docker Compose.
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
Mai multe imagini Docker utile pentru uz casnic pot fi găsite în secțiunea [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Pasul 1: Pregătiți dosarul wallabag
Creez un nou director numit "wallabag" în directorul Docker.
{{< gallery match="images/1/*.png" >}}

## Pasul 2: Instalarea bazei de date
După aceea, trebuie creată o bază de date. Fac clic pe fila "Înregistrare" din fereastra Synology Docker și caut "mariadb". Selectez imaginea Docker "mariadb" și apoi fac clic pe eticheta "latest".
{{< gallery match="images/2/*.png" >}}
După descărcarea imaginii, aceasta este disponibilă ca imagine. Docker face distincție între 2 stări, containerul "stare dinamică" și imaginea (stare fixă). Înainte de a crea un container din imagine, trebuie făcute câteva setări. Fac dublu clic pe imaginea mea mariadb.
{{< gallery match="images/3/*.png" >}}
Apoi fac clic pe "Setări avansate" și activez "Repornire automată". Selectez fila "Volume" și fac clic pe "Add Folder". Acolo creez un nou dosar pentru baza de date cu această cale de montare "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
La "Port settings" (Setări porturi) se șterg toate porturile. Aceasta înseamnă că selectez portul "3306" și îl șterg cu butonul "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Numele variabilei|Valoare|Ce este?|
|--- | --- |---|
|TZ| Europe/Berlin	|Fusul orar|
|MYSQL_ROOT_PASSWORD	 | wallaroot |Parola principală a bazei de date.|
{{</table>}}
În cele din urmă, introduc aceste variabile de mediu:Vezi:
{{< gallery match="images/6/*.png" >}}
După aceste setări, serverul Mariadb poate fi pornit! Am apăsat "Apply" peste tot.
{{< gallery match="images/7/*.png" >}}

## Pasul 3: Instalați Wallabag
Fac clic pe fila "Înregistrare" din fereastra Synology Docker și caut "wallabag". Selectez imaginea Docker "wallabag/wallabag" și apoi fac clic pe eticheta "latest".
{{< gallery match="images/8/*.png" >}}
Dau dublu clic pe imaginea mea de pe wallabag. Apoi fac clic pe "Setări avansate" și activez și aici "Repornire automată".
{{< gallery match="images/9/*.png" >}}
Selectez fila "Volume" și fac clic pe "Add Folder". Acolo creez un nou folder cu această cale de montare "/var/www/wallabag/web/assets/images".
{{< gallery match="images/10/*.png" >}}
Atribui porturi fixe pentru containerul "wallabag". Fără porturi fixe, s-ar putea ca "serverul wallabag" să ruleze pe un port diferit după o repornire. Primul port container poate fi șters. Celălalt port trebuie reținut.
{{< gallery match="images/11/*.png" >}}
În plus, mai trebuie creată o "legătură" către containerul "mariadb". Fac clic pe fila "Links" (Legături) și selectez containerul bazei de date. Numele de alias ar trebui să fie reținut pentru instalarea wallabag.
{{< gallery match="images/12/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Umgebungsvariable	|Valoare|
|--- |---|
|MYSQL_ROOT_PASSWORD	|wallaroot|
|SYMFONY__ENV__DATABASE_DRIVER	|pdo_mysql|
|SYMFONY__ENV__DATABASE_HOST	|db|
|SYMFONY__ENV__DATABASE_PORT	|3306|
|SYMFONY__ENV__DATABASE_NAME	|wallabag|
|SYMFONY__ENV__DATABASE_USER	|wallabag|
|SYMFONY__ENV__DATABASE_PASSWORD	|wallapass|
|SYMFONY__ENV__DATABASE_CHARSET |utf8mb4|
|SYMFONY__ENV__DOMAIN_NAME	|"http://synology-ip:container-port" <- Vă rugăm să schimbați|
|SYMFONY__ENV__SERVER_NAME	|"Wallabag - Server"|
|SYMFONY__ENV__FOSUSER_CONFIRMATION	|fals|
|SYMFONY__ENV__TWOFACTOR_AUTH	|fals|
{{</table>}}
În cele din urmă, introduc aceste variabile de mediu:Vezi:
{{< gallery match="images/13/*.png" >}}
Containerul poate fi pornit acum. Crearea bazei de date poate dura ceva timp. Comportamentul poate fi observat prin intermediul detaliilor containerului.
{{< gallery match="images/14/*.png" >}}
Sun la serverul wallabag cu adresa IP a Synology și portul containerului meu.
{{< gallery match="images/15/*.png" >}}
