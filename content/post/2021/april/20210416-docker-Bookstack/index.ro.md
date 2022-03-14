+++
date = "2021-04-16"
title = "Lucruri grozave cu containere: Propria ta Bookstack Wiki pe Synology DiskStation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "bookstack", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-Bookstack/index.ro.md"
+++
Bookstack este o alternativă "open source" la MediaWiki sau Confluence. Astăzi vă arăt cum să instalați un serviciu Bookstack pe stația de discuri Synology.
## Opțiune pentru profesioniști
În calitate de utilizator experimentat Synology, vă puteți, desigur, conecta cu SSH și instala întreaga configurație prin intermediul fișierului Docker Compose.
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
Mai multe imagini Docker utile pentru uz casnic pot fi găsite în secțiunea [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Pasul 1: Pregătiți dosarul Bookstack
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
|TZ	| Europe/Berlin |Fusul orar|
|MYSQL_ROOT_PASSWORD	|  my_wiki_pass |Parola principală a bazei de date.|
|MYSQL_DATABASE | 	my_wiki	|Acesta este numele bazei de date.|
|MYSQL_USER	|  wikiuser	|Numele de utilizator al bazei de date wiki.|
|MYSQL_PASSWORD	|  my_wiki_pass	|Parola utilizatorului bazei de date wiki.|
{{</table>}}
În cele din urmă, introduc aceste variabile de mediu:Vezi:
{{< gallery match="images/6/*.png" >}}
După aceste setări, serverul Mariadb poate fi pornit! Am apăsat "Apply" peste tot.
## Pasul 3: Instalați Bookstack
Fac clic pe fila "Înregistrare" din fereastra Synology Docker și caut "bookstack". Selectez imaginea Docker "solidnerd/bookstack" și apoi fac clic pe eticheta "latest".
{{< gallery match="images/7/*.png" >}}
Fac dublu clic pe imaginea mea Bookstack. Apoi fac clic pe "Setări avansate" și activez și aici "Repornire automată".
{{< gallery match="images/8/*.png" >}}
Atribui porturi fixe pentru containerul "bookstack". Fără porturi fixe, s-ar putea ca "serverul bookstack" să ruleze pe un port diferit după o repornire. Primul port container poate fi șters. Celălalt port trebuie reținut.
{{< gallery match="images/9/*.png" >}}
În plus, mai trebuie creată o "legătură" către containerul "mariadb". Fac clic pe fila "Links" (Legături) și selectez containerul bazei de date. Numele alias trebuie reținut pentru instalarea wiki.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Numele variabilei|Valoare|Ce este?|
|--- | --- |---|
|TZ	| Europe/Berlin |Fusul orar|
|DB_HOST	| wiki-db:3306	|Nume alias / link container|
|DB_DATABASE	| my_wiki |Datele din etapa 2|
|DB_USERNAME	| wikiuser |Datele din etapa 2|
|DB_PASSWORD	| my_wiki_pass	|Datele din etapa 2|
{{</table>}}
În cele din urmă, introduc aceste variabile de mediu:Vezi:
{{< gallery match="images/11/*.png" >}}
Containerul poate fi pornit acum. Crearea bazei de date poate dura ceva timp. Comportamentul poate fi observat prin intermediul detaliilor containerului.
{{< gallery match="images/12/*.png" >}}
Chem serverul Bookstack cu adresa IP a Synology și portul containerului meu. Numele de utilizator este "admin@admin.com", iar parola este "password".
{{< gallery match="images/13/*.png" >}}
