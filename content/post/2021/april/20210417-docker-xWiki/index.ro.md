+++
date = "2021-04-17"
title = "Lucruri grozave cu containere: Rularea propriului xWiki pe stația de discuri Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "xwiki", "wiki",]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210417-docker-xWiki/index.ro.md"
+++
XWiki este o platformă software wiki gratuită, scrisă în Java și concepută cu gândul la extensibilitate. Astăzi vă arăt cum să instalați un serviciu xWiki pe Synology DiskStation.
## Opțiune pentru profesioniști
În calitate de utilizator experimentat Synology, vă puteți, desigur, conecta cu SSH și instala întreaga configurație prin intermediul fișierului Docker Compose.
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
Mai multe imagini Docker utile pentru uz casnic pot fi găsite în secțiunea [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Pasul 1: Pregătiți dosarul wiki
Creez un nou director numit "wiki" în directorul Docker.
{{< gallery match="images/1/*.png" >}}

## Pasul 2: Instalarea bazei de date
După aceea, trebuie creată o bază de date. Fac clic pe fila "Înregistrare" din fereastra Synology Docker și caut "postgres". Selectez imaginea Docker "postgres" și apoi fac clic pe eticheta "latest".
{{< gallery match="images/2/*.png" >}}
După descărcarea imaginii, aceasta este disponibilă ca imagine. Docker face distincție între 2 stări, containerul "stare dinamică" și imaginea (stare fixă). Înainte de a crea un container din imagine, trebuie făcute câteva setări. Fac dublu clic pe imaginea mea postgres.
{{< gallery match="images/3/*.png" >}}
Apoi fac clic pe "Setări avansate" și activez "Repornire automată". Selectez fila "Volum" și fac clic pe "Adaugă folder". Acolo creez un nou folder pentru baza de date cu această cale de montare "/var/lib/postgresql/data".
{{< gallery match="images/4/*.png" >}}
La "Port settings" (Setări porturi) se șterg toate porturile. Aceasta înseamnă că selectez portul "5432" și îl șterg cu butonul "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Numele variabilei|Valoare|Ce este?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Fusul orar|
|POSTGRES_DB	| xwiki |Acesta este numele bazei de date.|
|POSTGRES_USER	| xwiki |Numele de utilizator al bazei de date wiki.|
|POSTGRES_PASSWORD	| xwiki |Parola utilizatorului bazei de date wiki.|
{{</table>}}
În cele din urmă, introduc aceste patru variabile de mediu:Vezi:
{{< gallery match="images/6/*.png" >}}
După aceste setări, serverul Mariadb poate fi pornit! Am apăsat "Apply" peste tot.
## Pasul 3: Instalați xWiki
Fac clic pe fila "Înregistrare" din fereastra Synology Docker și caut "xwiki". Selectez imaginea Docker "xwiki" și apoi fac clic pe eticheta "10-postgres-tomcat".
{{< gallery match="images/7/*.png" >}}
Fac dublu clic pe imaginea mea xwiki. Apoi fac clic pe "Setări avansate" și activez și aici "Repornire automată".
{{< gallery match="images/8/*.png" >}}
Atribui porturi fixe pentru containerul "xwiki". Fără porturi fixe, s-ar putea ca "serverul xwiki" să ruleze pe un port diferit după o repornire.
{{< gallery match="images/9/*.png" >}}
În plus, trebuie creată o "legătură" către containerul "postgres". Fac clic pe fila "Links" (Legături) și selectez containerul bazei de date. Numele alias trebuie reținut pentru instalarea wiki.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Numele variabilei|Valoare|Ce este?|
|--- | --- |---|
|TZ |	Europe/Berlin	|Fusul orar|
|DB_HOST	| db |Nume alias / link container|
|DB_DATABASE	| xwiki	|Datele din etapa 2|
|DB_USER	| xwiki	|Datele din etapa 2|
|DB_PASSWORD	| xwiki |Datele din etapa 2|
{{</table>}}
În cele din urmă, introduc aceste variabile de mediu:Vezi:
{{< gallery match="images/11/*.png" >}}
Containerul poate fi pornit acum. Chem serverul xWiki cu adresa IP a Synology și portul containerului meu.
{{< gallery match="images/12/*.png" >}}