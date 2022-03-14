+++
date = "2020-02-13"
title = "Synology-Nas: Instalați Calibre Web ca o bibliotecă de cărți electronice"
difficulty = "level-1"
tags = ["calbre-web", "calibre", "Docker", "ds918", "ebook", "epub", "nas", "pdf", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200213-synology-calibreweb/index.ro.md"
+++
Cum instalez Calibre-Web ca un container Docker pe Synology NAS? Atenție: Această metodă de instalare este depășită și nu este compatibilă cu software-ul Calibre actual. Vă rugăm să aruncați o privire la acest nou tutorial:[Lucruri grozave cu containere: Rularea Calibre cu Docker Compose]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Lucruri grozave cu containere: Rularea Calibre cu Docker Compose"). Acest tutorial se adresează tuturor profesioniștilor Synology DS.
## Pasul 1: Creați un dosar
În primul rând, creez un dosar pentru biblioteca Calibre.  Apelez la "System control" -> "Shared folder" și creez un nou folder "Books".
{{< gallery match="images/1/*.png" >}}

##  Pasul 2: Creați biblioteca Calibre
Acum copiez o bibliotecă existentă sau "[această bibliotecă de exemple goală](https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view)" în noul director. Eu însumi am copiat biblioteca existentă a aplicației desktop.
{{< gallery match="images/2/*.png" >}}

## Pasul 3: Căutați imaginea Docker
Fac clic pe fila "Înregistrare" din fereastra Synology Docker și caut "Calibre". Selectez imaginea Docker "janeczku/calibre-web" și apoi fac clic pe eticheta "latest".
{{< gallery match="images/3/*.png" >}}
După descărcarea imaginii, aceasta este disponibilă ca imagine. Docker face distincție între 2 stări, container "stare dinamică" și imagine/imagine (stare fixă). Înainte de a putea crea un container din imagine, trebuie să se facă câteva setări.
## Pasul 4: Puneți imaginea în funcțiune:
Fac dublu clic pe imaginea mea din Calibre.
{{< gallery match="images/4/*.png" >}}
Apoi fac clic pe "Setări avansate" și activez "Repornire automată". Selectez fila "Volume" și fac clic pe "Add Folder". Acolo creez un nou folder pentru baza de date cu această cale de montare "/calibre".
{{< gallery match="images/5/*.png" >}}
Atribui porturi fixe pentru containerul Calibre. Fără porturi fixe, s-ar putea ca Calibre să ruleze pe un port diferit după o repornire.
{{< gallery match="images/6/*.png" >}}
După aceste setări, Calibre poate fi pornit!
{{< gallery match="images/7/*.png" >}}
Acum apelez la IP-ul Synology cu portul Calibre atribuit și văd următoarea imagine. Introduc "/calibre" ca "Locație a bazei de date Calibre". Celelalte setări sunt o chestiune de gust.
{{< gallery match="images/8/*.png" >}}
Autentificarea implicită este "admin" cu parola "admin123".
{{< gallery match="images/9/*.png" >}}
Gata! Bineînțeles, acum pot conecta și aplicația de pe desktop prin intermediul "folderului meu de cărți". Schimb biblioteca din aplicația mea și apoi selectez dosarul Nas.
{{< gallery match="images/10/*.png" >}}
Ceva de genul acesta:
{{< gallery match="images/11/*.png" >}}
Dacă editez acum meta-info în aplicația desktop, acestea sunt actualizate automat și în aplicația web.
{{< gallery match="images/12/*.png" >}}