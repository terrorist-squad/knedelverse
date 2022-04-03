+++
date = "2021-07-25"
title = "Lucruri grozave cu containere: gestionarea frigiderului cu Grocy"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "kühlschrank", "erp", "mhd", "Speispläne", "cms", "Cafe", "Bistro"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/july/20210725-docker-grocy/index.ro.md"
+++
Cu Grocy puteți gestiona o întreagă gospodărie, un restaurant, o cafenea, un bistro sau o piață alimentară. Puteți gestiona frigiderele, meniurile, sarcinile, listele de cumpărături și durata de valabilitate a alimentelor.
{{< gallery match="images/1/*.png" >}}
Astăzi vă arăt cum să instalați un serviciu Grocy pe stația de discuri Synology.
## Opțiune pentru profesioniști
În calitate de utilizator experimentat Synology, vă puteți, desigur, conecta cu SSH și instala întreaga configurație prin intermediul fișierului Docker Compose.
```
version: "2.1"
services:
  grocy:
    image: ghcr.io/linuxserver/grocy
    container_name: grocy
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./data:/config
    ports:
      - 9283:80
    restart: unless-stopped

```
Mai multe imagini Docker utile pentru uz casnic pot fi găsite în secțiunea [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Pasul 1: Pregătiți dosarul Grocy
Creez un nou director numit "grocy" în directorul Docker.
{{< gallery match="images/2/*.png" >}}

## Pasul 2: Instalați Grocy
Fac clic pe fila "Înregistrare" din fereastra Synology Docker și caut "Grocy". Selectez imaginea Docker "linuxserver/grocy:latest" și apoi fac clic pe eticheta "latest".
{{< gallery match="images/3/*.png" >}}
Fac dublu clic pe imaginea mea Grocy.
{{< gallery match="images/4/*.png" >}}
Apoi fac clic pe "Setări avansate" și activez și aici "Repornire automată". Selectez fila "Volume" și fac clic pe "Add Folder". Acolo creez un nou folder cu această cale de montare "/config".
{{< gallery match="images/5/*.png" >}}
Atribui porturi fixe pentru containerul "Grocy". Fără porturi fixe, s-ar putea ca "serverul Grocy" să ruleze pe un port diferit după o repornire.
{{< gallery match="images/6/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Numele variabilei|Valoare|Ce este?|
|--- | --- |---|
|TZ | Europe/Berlin |Fusul orar|
|PUID | 1024 |ID-ul de utilizator de la Synology Admin User|
|PGID |	100 |ID-ul grupului de la Utilizator administrator Synology|
{{</table>}}
În cele din urmă, introduc aceste variabile de mediu:Vezi:
{{< gallery match="images/7/*.png" >}}
Containerul poate fi pornit acum. Sun la serverul Grocy cu adresa IP a Synology și portul containerului meu și mă conectez cu numele de utilizator "admin" și parola "admin".
{{< gallery match="images/8/*.png" >}}

