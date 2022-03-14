+++
date = "2020-02-27"
title = "Lucruri grozave cu containere: Rularea Youtube downloader pe Synology Diskstation"
difficulty = "level-1"
tags = ["Docker", "docker-compose", "download", "linux", "Synology", "video", "youtube"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200227-docker-youtube-dl/index.ro.md"
+++
Mulți dintre prietenii mei știu că am un portal video privat de învățare pe rețeaua mea Homelab - Network. Am salvat cursuri video de la abonamentele anterioare la portaluri de învățare și tutoriale bune de pe Youtube pentru utilizare offline pe NAS-ul meu.
{{< gallery match="images/1/*.png" >}}
De-a lungul timpului, am adunat 8845 de cursuri video cu 282616 videoclipuri individuale. Durata totală de funcționare este de aproximativ 2 ani. Absolut nebunesc! În acest tutorial vă arăt cum să faceți o copie de rezervă a tutorialelor bune de pe Youtube cu un serviciu de descărcare Docker pentru scopuri offline.
## Opțiune pentru profesioniști
În calitate de utilizator experimentat Synology, vă puteți, desigur, conecta cu SSH și instala întreaga configurație prin intermediul fișierului Docker Compose.
```
version: "2"
services:
  youtube-dl:
    image: modenaf360/youtube-dl-nas
    container_name: youtube-dl
    environment:
      - MY_ID=admin
      - MY_PW=admin
    volumes:
      - ./YouTube:/downfolder
    ports:
      - 8080:8080
    restart: unless-stopped

```

## Pasul 1
În primul rând, creez un dosar pentru descărcări. Mă duc la "System Control" -> "Shared Folder" și creez un nou dosar numit "Downloads".
{{< gallery match="images/2/*.png" >}}

## Pasul 2: Căutați imaginea Docker
Fac clic pe fila "Înregistrare" din fereastra Synology Docker și caut "youtube-dl-nas". Selectez imaginea Docker "modenaf360/youtube-dl-nas" și apoi fac clic pe eticheta "latest".
{{< gallery match="images/3/*.png" >}}
După descărcarea imaginii, aceasta este disponibilă ca imagine. Docker face distincție între 2 stări, container "stare dinamică" și imagine/imagine (stare fixă). Înainte de a putea crea un container din imagine, trebuie să se facă câteva setări.
## Pasul 3: Puneți imaginea în funcțiune:
Dau dublu clic pe imaginea mea youtube-dl-nas.
{{< gallery match="images/4/*.png" >}}
Apoi fac clic pe "Setări avansate" și activez "Repornire automată". Selectez fila "Volum" și fac clic pe "Adaugă folder". Acolo creez un nou dosar pentru baza de date cu această cale de montare "/downfolder".
{{< gallery match="images/5/*.png" >}}
Am atribuit porturi fixe pentru containerul "Youtube Downloader". Fără porturi fixe, s-ar putea ca "Youtube Downloader" să ruleze pe un port diferit după o repornire.
{{< gallery match="images/6/*.png" >}}
În cele din urmă, introduc două variabile de mediu. Variabila "MY_ID" este numele meu de utilizator, iar "MY_PW" este parola mea.
{{< gallery match="images/7/*.png" >}}
După aceste setări, Downloader poate fi pornit! După aceea, puteți apela descărcătorul prin intermediul adresei IP a stației Synology și a portului atribuit, de exemplu http://192.168.21.23:8070 .
{{< gallery match="images/8/*.png" >}}
Pentru autentificare, luați numele de utilizator și parola din MY_ID și MY_PW.
## Pasul 4: Să mergem
Acum, în câmpul "URL" pot fi introduse uralele video Youtube și uralele listelor de redare, iar toate videoclipurile ajung automat în folderul de descărcare al stației de disc Synology.
{{< gallery match="images/9/*.png" >}}
Descarcă dosarul de descărcare:
{{< gallery match="images/10/*.png" >}}