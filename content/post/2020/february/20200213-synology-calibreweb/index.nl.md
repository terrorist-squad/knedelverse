+++
date = "2020-02-13"
title = "Synology-Nas: Installeer Calibre Web als een ebook bibliotheek"
difficulty = "level-1"
tags = ["calbre-web", "calibre", "Docker", "ds918", "ebook", "epub", "nas", "pdf", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200213-synology-calibreweb/index.nl.md"
+++
Hoe installeer ik Calibre-Web als een Docker container op mijn Synology NAS? Let op: Deze installatiemethode is verouderd en is niet compatibel met de huidige Calibre software. Kijk eens naar deze nieuwe tutorial:[Geweldige dingen met containers: Calibre draaien met Docker Compose]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Geweldige dingen met containers: Calibre draaien met Docker Compose"). Deze handleiding is voor alle Synology DS-professionals.
## Stap 1: Map maken
Eerst maak ik een map voor de Calibre bibliotheek.  Ik roep de "System control" -> "Shared folder" op en maak een nieuwe map "Books".
{{< gallery match="images/1/*.png" >}}

##  Stap 2: Calibre-bibliotheek maken
Nu kopieer ik een bestaande bibliotheek of "[deze lege voorbeeldbibliotheek](https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view)" naar de nieuwe map. Ik heb zelf de bestaande bibliotheek van de desktop applicatie gekopieerd.
{{< gallery match="images/2/*.png" >}}

## Stap 3: Zoek naar Docker image
Ik klik op het tabblad "Registratie" in het Synology Docker venster en zoek naar "Calibre". Ik selecteer de Docker image "janeczku/calibre-web" en klik dan op de tag "latest".
{{< gallery match="images/3/*.png" >}}
Na het downloaden van de afbeelding, is de afbeelding beschikbaar als een afbeelding. Docker maakt onderscheid tussen 2 toestanden, container "dynamische toestand" en image/image (vaste toestand). Voordat we een container kunnen maken van de image, moeten een paar instellingen worden gemaakt.
## Stap 4: Zet het beeld in werking:
Ik dubbelklik op mijn Calibre beeld.
{{< gallery match="images/4/*.png" >}}
Dan klik ik op "Geavanceerde instellingen" en activeer de "Automatische herstart". Ik selecteer de tab "Volume" en klik op "Map toevoegen". Daar maak ik een nieuwe database map aan met dit mount pad "/calibre".
{{< gallery match="images/5/*.png" >}}
Ik wijs vaste poorten toe voor de Calibre container. Zonder vaste poorten, kan het zijn dat Calibre op een andere poort draait na een herstart.
{{< gallery match="images/6/*.png" >}}
Na deze instellingen, kan Calibre gestart worden!
{{< gallery match="images/7/*.png" >}}
Ik roep nu mijn Synology IP op met de toegewezen Calibre poort en zie de volgende afbeelding. Ik voer "/calibre" in als de "Locatie van de Calibre Database". De overige instellingen zijn een kwestie van smaak.
{{< gallery match="images/8/*.png" >}}
De standaard login is "admin" met wachtwoord "admin123".
{{< gallery match="images/9/*.png" >}}
Klaar! Natuurlijk kan ik nu ook de desktop app verbinden via mijn "boekenmap". Ik verwissel de bibliotheek in mijn app en selecteer dan mijn Nas map.
{{< gallery match="images/10/*.png" >}}
Zoiets als dit:
{{< gallery match="images/11/*.png" >}}
Als ik nu meta-info's bewerk in de desktop app, worden ze ook automatisch bijgewerkt in de web app.
{{< gallery match="images/12/*.png" >}}