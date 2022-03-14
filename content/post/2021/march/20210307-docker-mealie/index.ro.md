+++
date = "2021-03-07"
title = "Lucruri grozave cu containere: Gestionați și arhivați rețete pe Synology DiskStation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "rezepte", "speisen", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-docker-mealie/index.ro.md"
+++
Adunați toate rețetele dvs. preferate în containerul Docker și organizați-le după cum doriți. Scrieți propriile rețete sau importați rețete de pe site-uri web, de exemplu "Chefkoch", "Essen".
{{< gallery match="images/1/*.png" >}}

## Opțiune pentru profesioniști
În calitate de utilizator experimentat Synology, vă puteți, desigur, conecta cu SSH și instala întreaga configurație prin intermediul fișierului Docker Compose.
```
version: "2.0"
services:
  mealie:
    container_name: mealie
    image: hkotel/mealie:latest
    restart: always
    ports:
      - 9000:80
    environment:
      db_type: sqlite
      TZ: Europa/Berlin
    volumes:
      - ./mealie/data/:/app/data

```

## Pasul 1: Căutați imaginea Docker
Fac clic pe fila "Înregistrare" din fereastra Synology Docker și caut "mealie". Selectez imaginea Docker "hkotel/mealie:latest" și apoi fac clic pe eticheta "latest".
{{< gallery match="images/2/*.png" >}}
După descărcarea imaginii, aceasta este disponibilă ca imagine. Docker face distincție între 2 stări, container "stare dinamică" și imagine/imagine (stare fixă). Înainte de a putea crea un container din imagine, trebuie să se facă câteva setări.
## Pasul 2: Puneți imaginea în funcțiune:
Fac dublu clic pe imaginea mea "mealie".
{{< gallery match="images/3/*.png" >}}
Apoi fac clic pe "Setări avansate" și activez "Repornire automată". Selectez fila "Volume" și fac clic pe "Add Folder". Acolo creez un nou folder cu această cale de montare "/app/data".
{{< gallery match="images/4/*.png" >}}
Atribui porturi fixe pentru containerul "Mealie". Fără porturi fixe, s-ar putea ca "serverul Mealie" să ruleze pe un port diferit după o repornire.
{{< gallery match="images/5/*.png" >}}
În cele din urmă, introduc două variabile de mediu. Variabila "db_type" este tipul de bază de date, iar "TZ" este fusul orar "Europa/Berlin".
{{< gallery match="images/6/*.png" >}}
După aceste setări, Mealie Server poate fi pornit! Ulterior, puteți apela Mealie prin intermediul adresei Ip a stației Synology și a portului atribuit, de exemplu http://192.168.21.23:8096 .
{{< gallery match="images/7/*.png" >}}

## Cum funcționează Mealie?
Dacă trec cu mouse-ul peste butonul "Plus" din dreapta/jos și apoi fac clic pe simbolul "Lanț", pot introduce o adresă URL. Aplicația Mealie caută apoi în mod automat informațiile meta și schematice necesare.
{{< gallery match="images/8/*.png" >}}
Importul funcționează foarte bine (am folosit aceste funcții cu urls din Chef, Food
{{< gallery match="images/9/*.png" >}}
În modul de editare, pot, de asemenea, să adaug o categorie. Este important să apăs tasta "Enter" o dată după fiecare categorie. În caz contrar, această setare nu se aplică.
{{< gallery match="images/10/*.png" >}}

## Caracteristici speciale
Am observat că categoriile din meniu nu se actualizează automat. Trebuie să vă ajutați aici cu o reîncărcare a browserului.
{{< gallery match="images/11/*.png" >}}

## Alte caracteristici
Bineînțeles, puteți căuta rețete și puteți crea meniuri. În plus, puteți personaliza "Mealie" foarte mult.
{{< gallery match="images/12/*.png" >}}
Mealie arată foarte bine și pe mobil:
{{< gallery match="images/13/*.*" >}}

## Rest-Api
Documentația API poate fi găsită la "http://gewaehlte-ip:und-port ... /docs". Aici veți găsi multe metode care pot fi utilizate pentru automatizare.
{{< gallery match="images/14/*.png" >}}

## Exemplu Api
Imaginați-vă următoarea ficțiune: "Gruner und Jahr lansează portalul de internet Essen
{{< terminal >}}
wget --spider --force-html -r -l12  "https://www.essen-und-trinken.de/rezepte/archiv/"  2>&1 | grep '/rezepte/' | grep '^--' | awk '{ print $3 }' > liste.txt

{{</ terminal >}}
Apoi, curățați această listă și trimiteți-o la api rest, de exemplu:
```
#!/bin/bash
sort -u liste.txt > clear.txt

while read p; do
  echo "import url: $p"
  curl -d "{\"url\":\"$p\"}" -H "Content-Type: application/json" http://synology-ip:8096/api/recipes/create-url
  sleep 1
done < clear.txt

```
Acum puteți accesa rețetele și offline:
{{< gallery match="images/15/*.png" >}}
