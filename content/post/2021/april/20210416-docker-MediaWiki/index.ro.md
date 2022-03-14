+++
date = "2021-04-16"
title = "Lucruri grozave cu containere: Instalarea propriului MediaWiki pe stația de discuri Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "mediawiki", "wiki"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210416-docker-MediaWiki/index.ro.md"
+++
MediaWiki este un sistem wiki bazat pe PHP care este disponibil gratuit ca produs open source. Astăzi vă arăt cum să instalați un serviciu MediaWiki pe stația de discuri Synology.
## Opțiune pentru profesioniști
În calitate de utilizator experimentat Synology, vă puteți, desigur, conecta cu SSH și instala întreaga configurație prin intermediul fișierului Docker Compose.
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
Mai multe imagini Docker utile pentru uz casnic pot fi găsite în secțiunea [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Pasul 1: Pregătiți dosarul MediaWiki
Creez un nou director numit "wiki" în directorul Docker.
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
|TZ	| Europe/Berlin	|Fusul orar|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass	|Parola principală a bazei de date.|
|MYSQL_DATABASE |	my_wiki	|Acesta este numele bazei de date.|
|MYSQL_USER	| wikiuser |Numele de utilizator al bazei de date wiki.|
|MYSQL_PASSWORD	| my_wiki_pass |Parola utilizatorului bazei de date wiki.|
{{</table>}}
În cele din urmă, introduc aceste variabile de mediu:Vezi:
{{< gallery match="images/6/*.png" >}}
După aceste setări, serverul Mariadb poate fi pornit! Am apăsat "Apply" peste tot.
## Pasul 3: Instalați MediaWiki
Fac clic pe fila "Înregistrare" din fereastra Synology Docker și caut "mediawiki". Selectez imaginea Docker "mediawiki" și apoi fac clic pe eticheta "latest".
{{< gallery match="images/7/*.png" >}}
Fac dublu clic pe imaginea mea Mediawiki.
{{< gallery match="images/8/*.png" >}}
Apoi fac clic pe "Setări avansate" și activez și aici "Repornire automată". Selectez fila "Volume" și fac clic pe "Add Folder". Acolo creez un nou folder cu această cale de montare "/var/www/html/images".
{{< gallery match="images/9/*.png" >}}
Atribui porturi fixe pentru containerul "MediaWiki". Fără porturi fixe, s-ar putea ca "serverul MediaWiki" să ruleze pe un port diferit după o repornire.
{{< gallery match="images/10/*.png" >}}
În plus, mai trebuie creată o "legătură" către containerul "mariadb". Fac clic pe fila "Links" (Legături) și selectez containerul bazei de date. Numele alias trebuie reținut pentru instalarea wiki.
{{< gallery match="images/11/*.png" >}}
În cele din urmă, introduc o variabilă de mediu "TZ" cu valoarea "Europe/Berlin".
{{< gallery match="images/12/*.png" >}}
Containerul poate fi pornit acum. Chem serverul Mediawiki cu adresa IP a Synology și portul containerului meu. La Server de baze de date introduc numele alias al containerului de baze de date. De asemenea, introduc numele bazei de date, numele de utilizator și parola de la "Pasul 2".
{{< gallery match="images/13/*.png" >}}