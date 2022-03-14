+++
date = "2021-04-18"
title = "Lucruri grozave cu containere: Instalarea propriului dokuWiki pe stația de discuri Synology"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dokuwiki", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-dokuWiki/index.ro.md"
+++
DokuWiki este un software wiki cu sursă deschisă compatibil cu standardele, ușor de utilizat și, în același timp, extrem de versatil. Astăzi vă arăt cum să instalați un serviciu DokuWiki pe stația de discuri Synology.
## Opțiune pentru profesioniști
În calitate de utilizator experimentat Synology, vă puteți, desigur, conecta cu SSH și instala întreaga configurație prin intermediul fișierului Docker Compose.
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
Mai multe imagini Docker utile pentru uz casnic pot fi găsite în secțiunea [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Pasul 1: Pregătiți dosarul wiki
Creez un nou director numit "wiki" în directorul Docker.
{{< gallery match="images/1/*.png" >}}

## Pasul 2: Instalați DokuWiki
După aceea, trebuie creată o bază de date. Fac clic pe fila "Înregistrare" din fereastra Synology Docker și caut "dokuwiki". Selectez imaginea Docker "bitnami/dokuwiki" și apoi fac clic pe eticheta "latest".
{{< gallery match="images/2/*.png" >}}
După descărcarea imaginii, aceasta este disponibilă ca imagine. Docker face distincție între 2 stări, containerul "stare dinamică" și imaginea (stare fixă). Înainte de a crea un container din imagine, trebuie făcute câteva setări. Fac dublu clic pe imaginea mea dokuwiki.
{{< gallery match="images/3/*.png" >}}
Atribui porturi fixe pentru containerul "dokuwiki". Fără porturi fixe, s-ar putea ca "serverul dokuwiki" să ruleze pe un port diferit după o repornire.
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Numele variabilei|Valoare|Ce este?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Fusul orar|
|DOKUWIKI_USERNAME	| admin|Nume de utilizator administrator|
|DOKUWIKI_FULL_NAME |	wiki	|Numele WIki|
|DOKUWIKI_PASSWORD	| password	|Parola de administrator|
{{</table>}}
În cele din urmă, introduc aceste variabile de mediu:Vezi:
{{< gallery match="images/5/*.png" >}}
Containerul poate fi pornit acum. Chem serverul dokuWIki cu adresa IP a Synology și portul containerului meu.
{{< gallery match="images/6/*.png" >}}
