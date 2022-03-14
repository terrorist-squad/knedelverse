+++
date = "2021-04-16"
title = "Lucruri grozave cu containere: Instalarea Wiki.js pe Synology Diskstation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "wikijs", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-Wikijs/index.ro.md"
+++
Wiki.js este un software wiki open source puternic, care face din documentare o plăcere cu interfața sa simplă. Astăzi vă arăt cum să instalați un serviciu Wiki.js pe Synology DiskStation.
## Opțiune pentru profesioniști
În calitate de utilizator experimentat Synology, vă puteți, desigur, conecta cu SSH și instala întreaga configurație prin intermediul fișierului Docker Compose.
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
Puteți găsi mai multe imagini Docker utile pentru uz casnic în Dockerverse.
## Pasul 1: Pregătiți dosarul wiki
Creez un nou director numit "wiki" în directorul Docker.
{{< gallery match="images/1/*.png" >}}

## Pasul 2: Instalarea bazei de date
După aceea, trebuie creată o bază de date. Fac clic pe fila "Înregistrare" din fereastra Synology Docker și caut "mysql". Selectez imaginea Docker "mysql" și apoi fac clic pe eticheta "latest".
{{< gallery match="images/2/*.png" >}}
După descărcarea imaginii, aceasta este disponibilă ca imagine. Docker face distincție între 2 stări, containerul "stare dinamică" și imaginea (stare fixă). Înainte de a crea un container din imagine, trebuie făcute câteva setări. Fac dublu clic pe imaginea mea mysql.
{{< gallery match="images/3/*.png" >}}
Apoi fac clic pe "Setări avansate" și activez "Repornire automată". Selectez fila "Volume" și fac clic pe "Add Folder". Acolo creez un nou dosar pentru baza de date cu această cale de montare "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
La "Port settings" (Setări porturi) se șterg toate porturile. Aceasta înseamnă că selectez portul "3306" și îl șterg cu butonul "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Numele variabilei|Valoare|Ce este?|
|--- | --- |---|
|TZ	| Europe/Berlin |Fusul orar|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass |Parola principală a bazei de date.|
|MYSQL_DATABASE |	my_wiki |Acesta este numele bazei de date.|
|MYSQL_USER	| wikiuser |Numele de utilizator al bazei de date wiki.|
|MYSQL_PASSWORD |	my_wiki_pass	|Parola utilizatorului bazei de date wiki.|
{{</table>}}
În cele din urmă, introduc aceste patru variabile de mediu:Vezi:
{{< gallery match="images/6/*.png" >}}
După aceste setări, serverul Mariadb poate fi pornit! Am apăsat "Apply" peste tot.
## Pasul 3: Instalați Wiki.js
Fac clic pe fila "Înregistrare" din fereastra Synology Docker și caut "wiki". Selectez imaginea Docker "requarks/wiki" și apoi fac clic pe eticheta "latest".
{{< gallery match="images/7/*.png" >}}
Fac dublu clic pe imaginea mea WikiJS. Apoi fac clic pe "Setări avansate" și activez și aici "Repornire automată".
{{< gallery match="images/8/*.png" >}}
Am atribuit porturi fixe pentru containerul "WikiJS". Fără porturi fixe, s-ar putea ca "serverul bookstack" să ruleze pe un port diferit după o repornire.
{{< gallery match="images/9/*.png" >}}
În plus, mai trebuie creată o "legătură" către containerul "mysql". Fac clic pe fila "Links" (Legături) și selectez containerul bazei de date. Numele alias trebuie reținut pentru instalarea wiki.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Numele variabilei|Valoare|Ce este?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Fusul orar|
|DB_HOST	| wiki-db	|Nume alias / link container|
|DB_TYPE	| mysql	||
|DB_PORT	| 3306	 ||
|DB_PASSWORD	| my_wiki	|Datele din etapa 2|
|DB_USER	| wikiuser |Datele din etapa 2|
|DB_PASS	| my_wiki_pass	|Datele din etapa 2|
{{</table>}}
În cele din urmă, introduc aceste variabile de mediu:Vezi:
{{< gallery match="images/11/*.png" >}}
Containerul poate fi pornit acum. Chem serverul Wiki.js cu adresa IP a Synology și portul meu de container/3000.
{{< gallery match="images/12/*.png" >}}