+++
date = "2022-03-21"
title = "Lucruri grozave cu containere: Înregistrarea de MP3-uri de la radio"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "radio", "mp3", "ripp", "streamripper", "radiorecorder"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220321-docker-mighty-mixxx-tapper/index.ro.md"
+++
Streamripper este un instrument pentru linia de comandă care poate fi folosit pentru a înregistra fluxuri MP3 sau OGG/Vorbis și a le salva direct pe hard disk. Melodiile sunt denumite automat în funcție de artist și salvate individual, formatul fiind cel trimis inițial (deci, de fapt, sunt create fișiere cu extensia .mp3 sau .ogg). Am găsit o interfață excelentă pentru radiorecorder și am construit o imagine Docker din ea, vezi: https://github.com/terrorist-squad/mightyMixxxTapper/
{{< gallery match="images/1/*.png" >}}

## Opțiune pentru profesioniști
În calitate de utilizator experimentat Synology, vă puteți, desigur, conecta cu SSH și instala întreaga configurație prin intermediul fișierului Docker Compose.
```
version: "2.0"
services:
  mealie:
    container_name: mighty-mixxx-tapper
    image: chrisknedel/mighty-mixxx-tapper:latest
    restart: always
    ports:
      - 9000:80
    environment:
      TZ: Europa/Berlin
    volumes:
      - ./ripps/:/tmp/ripps/

```

## Pasul 1: Căutați imaginea Docker
Fac clic pe fila "Înregistrare" din fereastra Synology Docker și caut "mighty-mixxx-tapper". Selectez imaginea Docker "chrisknedel/mighty-mixxx-tapper" și apoi fac clic pe eticheta "latest".
{{< gallery match="images/2/*.png" >}}
După descărcarea imaginii, aceasta este disponibilă ca imagine. Docker face distincție între 2 stări, container "stare dinamică" și imagine/imagine (stare fixă). Înainte de a putea crea un container din imagine, trebuie să se facă câteva setări.
## Pasul 2: Puneți imaginea în funcțiune:
Dau dublu clic pe imaginea mea "mighty-mixxx-tapper".
{{< gallery match="images/3/*.png" >}}
Apoi fac clic pe "Setări avansate" și activez "Repornire automată". Selectez fila "Volume" și fac clic pe "Add Folder". Acolo creez un nou folder cu această cale de montare "/tmp/ripps/".
{{< gallery match="images/4/*.png" >}}
Atribui porturi fixe pentru containerul "mighty-mixxx-tapper". Fără porturi fixe, s-ar putea ca "mighty-mixxx-tapper-server" să ruleze pe un port diferit după o repornire.
{{< gallery match="images/5/*.png" >}}
După aceste setări, mighty-mixxx-tapper-server poate fi pornit! Ulterior, puteți apela mighty-mixxx-tapper prin intermediul adresei Ip a stației Synology și a portului atribuit, de exemplu http://192.168.21.23:8097.
{{< gallery match="images/6/*.png" >}}