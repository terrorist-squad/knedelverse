+++
date = "2021-03-07"
title = "Store ting med containere: administrer og arkiver opskrifter på Synology DiskStation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "rezepte", "speisen", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210307-docker-mealie/index.da.md"
+++
Saml alle dine yndlingsopskrifter i Docker-containeren, og organiser dem som du ønsker det. Skriv dine egne opskrifter eller importer opskrifter fra websteder, f.eks. "Chefkoch", "Essen
{{< gallery match="images/1/*.png" >}}

## Mulighed for fagfolk
Som erfaren Synology-bruger kan du naturligvis logge ind med SSH og installere hele opsætningen via Docker Compose-filen.
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

## Trin 1: Søg efter Docker-aftryk
Jeg klikker på fanen "Registration" i Synology Docker-vinduet og søger efter "mealie". Jeg vælger Docker-image "hkotel/mealie:latest" og klikker derefter på tagget "latest".
{{< gallery match="images/2/*.png" >}}
Når billedet er downloadet, er det tilgængeligt som et billede. Docker skelner mellem 2 tilstande, container "dynamisk tilstand" og image/image (fast tilstand). Før vi kan oprette en container fra billedet, skal der foretages et par indstillinger.
## Trin 2: Sæt billedet i drift:
Jeg dobbeltklikker på mit "mealie"-billede.
{{< gallery match="images/3/*.png" >}}
Derefter klikker jeg på "Avancerede indstillinger" og aktiverer "Automatisk genstart". Jeg vælger fanen "Volume" og klikker på "Add Folder" (tilføj mappe). Der opretter jeg en ny mappe med denne monteringssti "/app/data".
{{< gallery match="images/4/*.png" >}}
Jeg tildeler faste porte til "Mealie"-containeren. Uden faste porte kan det være, at "Mealie-serveren" kører på en anden port efter en genstart.
{{< gallery match="images/5/*.png" >}}
Endelig indtaster jeg to miljøvariabler. Variablen "db_type" er databasetypen, og "TZ" er tidszonen "Europe/Berlin".
{{< gallery match="images/6/*.png" >}}
Efter disse indstillinger kan Mealie Server startes! Herefter kan du ringe til Mealie via Ip-adressen på Synology-disken og den tildelte port, f.eks. http://192.168.21.23:8096 .
{{< gallery match="images/7/*.png" >}}

## Hvordan virker Mealie?
Hvis jeg bevæger musen over "Plus"-knappen til højre/nedre og derefter klikker på "Chain"-symbolet, kan jeg indtaste en url. Mealie-applikationen søger derefter automatisk efter de nødvendige meta- og skemaoplysninger.
{{< gallery match="images/8/*.png" >}}
Importen fungerer fint (jeg har brugt disse funktioner med urls fra Chef, Food
{{< gallery match="images/9/*.png" >}}
I redigeringstilstand kan jeg også tilføje en kategori. Det er vigtigt, at jeg trykker på "Enter"-tasten én gang efter hver kategori. Ellers anvendes denne indstilling ikke.
{{< gallery match="images/10/*.png" >}}

## Særlige funktioner
Jeg har bemærket, at menukategorierne ikke opdateres automatisk. Du er nødt til at hjælpe her med at genindlæse din browser.
{{< gallery match="images/11/*.png" >}}

## Andre funktioner
Du kan naturligvis søge efter opskrifter og også oprette menuer. Desuden kan du tilpasse "Mealie" meget omfattende.
{{< gallery match="images/12/*.png" >}}
Mealie ser også godt ud på mobilen:
{{< gallery match="images/13/*.*" >}}

## Rest-Api
API-dokumentationen kan findes på "http://gewaehlte-ip:und-port ... /docs". Her finder du mange metoder, der kan bruges til automatisering.
{{< gallery match="images/14/*.png" >}}

## Api eksempel
Forestil dig følgende fiktion: "Gruner und Jahr lancerer internetportalen Essen
{{< terminal >}}
wget --spider --force-html -r -l12  "https://www.essen-und-trinken.de/rezepte/archiv/"  2>&1 | grep '/rezepte/' | grep '^--' | awk '{ print $3 }' > liste.txt

{{</ terminal >}}
Derefter ryddes denne liste op, og den affyres mod resten af api'en, f.eks:
```
#!/bin/bash
sort -u liste.txt > clear.txt

while read p; do
  echo "import url: $p"
  curl -d "{\"url\":\"$p\"}" -H "Content-Type: application/json" http://synology-ip:8096/api/recipes/create-url
  sleep 1
done < clear.txt

```
Nu kan du også få adgang til opskrifterne offline:
{{< gallery match="images/15/*.png" >}}
