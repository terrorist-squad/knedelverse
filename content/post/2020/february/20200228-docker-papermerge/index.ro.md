+++
date = "2020-02-28"
title = "Lucruri grozave cu containere: Rularea Papermerge DMS pe un NAS Synology"
difficulty = "level-3"
tags = ["archiv", "automatisch", "dms", "Docker", "Document-Managment-System", "google", "ocr", "papermerge", "Synology", "tesseract", "texterkennung"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200228-docker-papermerge/index.ro.md"
+++
Papermerge este un sistem tânăr de gestionare a documentelor (DMS) care poate atribui și procesa automat documente. În acest tutorial vă arăt cum am instalat Papermerge pe stația mea de discuri Synology și cum funcționează DMS.
## Opțiune pentru profesioniști
În calitate de utilizator experimentat Synology, vă puteți, desigur, conecta cu SSH și instala întreaga configurație prin intermediul fișierului Docker Compose.
```
version: "2.1"
services:
  papermerge:
    image: ghcr.io/linuxserver/papermerge
    container_name: papermerge
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./config>:/config
      - ./appdata/data>:/data
    ports:
      - 8090:8000
    restart: unless-stopped

```

## Pasul 1: Creați un dosar
În primul rând, creez un dosar pentru îmbinarea hârtiilor. Mă duc la "System Control" -> "Shared Folder" și creez un nou dosar numit "Document Archive".
{{< gallery match="images/1/*.png" >}}
Pasul 2: Căutați imaginea DockerAccesați fila "Registration" din fereastra Synology Docker și căutați "Papermerge". Selectez imaginea Docker "linuxserver/papermerge" și apoi fac clic pe eticheta "latest".
{{< gallery match="images/2/*.png" >}}
După descărcarea imaginii, aceasta este disponibilă ca imagine. Docker face distincție între 2 stări, container "stare dinamică" și imagine/imagine (stare fixă). Înainte de a putea crea un container din imagine, trebuie să se facă câteva setări.
## Pasul 3: Puneți imaginea în funcțiune:
Fac dublu clic pe imaginea mea de îmbinare a hârtiei.
{{< gallery match="images/3/*.png" >}}
Apoi fac clic pe "Setări avansate" și activez "Repornire automată". Selectez fila "Volum" și fac clic pe "Adaugă folder". Acolo creez un nou folder pentru baza de date cu această cale de montare "/data".
{{< gallery match="images/4/*.png" >}}
De asemenea, aici stochez un al doilea folder pe care îl includ în calea de montare "/config". Nu prea contează unde se află acest dosar. Cu toate acestea, este important ca acesta să aparțină utilizatorului administrator Synology.
{{< gallery match="images/5/*.png" >}}
Atribui porturi fixe pentru containerul "Papermerge". Fără porturi fixe, s-ar putea ca "serverul Papermerge" să ruleze pe un port diferit după o repornire.
{{< gallery match="images/6/*.png" >}}
În cele din urmă, introduc trei variabile de mediu. Variabila "PUID" este ID-ul utilizatorului și "PGID" este ID-ul grupului utilizatorului meu administrator. Puteți afla PGID/PUID prin SSH cu ajutorul comenzii "cat /etc/passwd | grep admin".
{{< gallery match="images/7/*.png" >}}
După aceste setări, serverul Papermerge poate fi pornit! Ulterior, Papermerge poate fi apelat prin intermediul adresei Ip a stației Synology și a portului atribuit, de exemplu http://192.168.21.23:8095.
{{< gallery match="images/8/*.png" >}}
Autentificarea implicită este admin cu parola admin.
## Cum funcționează Papermerge?
Papermerge analizează textul documentelor și al imaginilor. Papermerge utilizează o bibliotecă OCR/"recunoaștere optică a caracterelor" numită tesseract, publicată de Goolge.
{{< gallery match="images/9/*.png" >}}
Am creat un dosar numit "Totul cu Lorem" pentru a testa atribuirea automată a documentelor. Apoi am făcut clic împreună pe un nou model de recunoaștere în meniul "Automatizări".
{{< gallery match="images/10/*.png" >}}
Toate documentele noi care conțin cuvântul "Lorem" sunt plasate în dosarul "Totul cu Lorem" și etichetate "has-lorem". Este important să folosiți o virgulă în etichete, altfel eticheta nu va fi setată. Dacă încărcați un document, acesta va fi etichetat și sortat.
{{< gallery match="images/11/*.png" >}}
