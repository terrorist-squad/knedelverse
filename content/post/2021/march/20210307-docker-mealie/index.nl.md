+++
date = "2021-03-07"
title = "Geweldige dingen met containers: recepten beheren en archiveren op het Synology DiskStation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "rezepte", "speisen", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-docker-mealie/index.nl.md"
+++
Verzamel al je favoriete recepten in de Docker container en organiseer ze zoals je wilt. Schrijf uw eigen recepten of importeer recepten van websites, bijvoorbeeld "Chefkoch", "Essen
{{< gallery match="images/1/*.png" >}}

## Optie voor professionals
Als ervaren Synology gebruiker kunt u natuurlijk inloggen met SSH en de hele setup installeren via Docker Compose bestand.
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

## Stap 1: Zoek naar Docker image
Ik klik op het tabblad "Registratie" in het Synology Docker venster en zoek naar "mealie". Ik selecteer de Docker image "hkotel/mealie:latest" en klik dan op de tag "latest".
{{< gallery match="images/2/*.png" >}}
Na het downloaden van de afbeelding, is de afbeelding beschikbaar als een afbeelding. Docker maakt onderscheid tussen 2 toestanden, container "dynamische toestand" en image/image (vaste toestand). Voordat we een container kunnen maken van de image, moeten een paar instellingen worden gemaakt.
## Stap 2: Zet het beeld in werking:
Ik dubbelklik op mijn "mealie" plaatje.
{{< gallery match="images/3/*.png" >}}
Dan klik ik op "Geavanceerde instellingen" en activeer de "Automatische herstart". Ik selecteer de tab "Volume" en klik op "Map toevoegen". Daar maak ik een nieuwe map aan met dit mount pad "/app/data".
{{< gallery match="images/4/*.png" >}}
Ik wijs vaste poorten toe voor de "Mealie" container. Zonder vaste poorten, zou het kunnen dat de "Mealie server" op een andere poort draait na een herstart.
{{< gallery match="images/5/*.png" >}}
Tenslotte voer ik twee omgevingsvariabelen in. De variabele "db_type" is het databasetype en "TZ" is de tijdzone "Europa/Berlijn".
{{< gallery match="images/6/*.png" >}}
Na deze instellingen kan Mealie Server worden opgestart! Daarna kunt u Mealie bellen via het Ip-adres van het Synology disctation en de toegewezen poort, bijvoorbeeld http://192.168.21.23:8096 .
{{< gallery match="images/7/*.png" >}}

## Hoe werkt Mealie?
Als ik de muis beweeg over de "Plus" knop rechts/onder en dan klik op het "Ketting" symbool, kan ik een url invoeren. De Mealie-toepassing zoekt dan automatisch naar de vereiste meta- en schema-informatie.
{{< gallery match="images/8/*.png" >}}
De import werkt geweldig (ik heb deze functies gebruikt met url's van Chef, Food
{{< gallery match="images/9/*.png" >}}
In de bewerkingsmodus kan ik ook een categorie toevoegen. Het is belangrijk dat ik na elke categorie één keer op de "Enter" toets druk. Anders wordt deze instelling niet toegepast.
{{< gallery match="images/10/*.png" >}}

## Speciale kenmerken
Ik heb gemerkt dat de menu categorieën niet automatisch worden bijgewerkt. Je moet hier helpen met een browser te herladen.
{{< gallery match="images/11/*.png" >}}

## Andere kenmerken
Natuurlijk kunt u recepten zoeken en ook menu's samenstellen. Bovendien kunt u "Mealie" zeer uitgebreid aanpassen.
{{< gallery match="images/12/*.png" >}}
Mealie ziet er ook goed uit op mobiel:
{{< gallery match="images/13/*.*" >}}

## Rest-Api
De API-documentatie is te vinden op "http://gewaehlte-ip:und-port ... /docs". Hier vindt u vele methoden die voor automatisering kunnen worden gebruikt.
{{< gallery match="images/14/*.png" >}}

## Api-voorbeeld
Stelt u zich de volgende fictie voor: "Gruner und Jahr lanceert het internetportaal Essen
{{< terminal >}}
wget --spider --force-html -r -l12  "https://www.essen-und-trinken.de/rezepte/archiv/"  2>&1 | grep '/rezepte/' | grep '^--' | awk '{ print $3 }' > liste.txt

{{</ terminal >}}
Maak dan deze lijst schoon en vuur het af tegen de rest api, voorbeeld:
```
#!/bin/bash
sort -u liste.txt > clear.txt

while read p; do
  echo "import url: $p"
  curl -d "{\"url\":\"$p\"}" -H "Content-Type: application/json" http://synology-ip:8096/api/recipes/create-url
  sleep 1
done < clear.txt

```
Nu kunt u de recepten ook offline bekijken:
{{< gallery match="images/15/*.png" >}}
