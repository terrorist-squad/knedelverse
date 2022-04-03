+++
date = "2020-02-28"
title = "Geweldige dingen met containers: Papermerge DMS draaien op een Synology NAS"
difficulty = "level-3"
tags = ["archiv", "automatisch", "dms", "Docker", "Document-Managment-System", "google", "ocr", "papermerge", "Synology", "tesseract", "texterkennung"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200228-docker-papermerge/index.nl.md"
+++
Papermerge is een jong documentbeheersysteem (DMS) dat documenten automatisch kan toewijzen en verwerken. In deze tutorial laat ik zien hoe ik Papermerge op mijn Synology diskstation heb geïnstalleerd en hoe de DMS werkt.
## Optie voor professionals
Als ervaren Synology gebruiker kunt u natuurlijk inloggen met SSH en de hele setup installeren via Docker Compose bestand.
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

## Stap 1: Map maken
Eerst maak ik een map aan voor de paper merge. Ik ga naar "System Control" -> "Shared Folder" en maak een nieuwe map aan genaamd "Document Archive".
{{< gallery match="images/1/*.png" >}}
Stap 2: Zoek naar Docker imageIk klik op het tabblad "Registratie" in het Synology Docker venster en zoek naar "Papermerge". Ik selecteer de Docker image "linuxserver/papermerge" en klik dan op de tag "latest".
{{< gallery match="images/2/*.png" >}}
Na het downloaden van de afbeelding, is de afbeelding beschikbaar als een afbeelding. Docker maakt onderscheid tussen 2 toestanden, container "dynamische toestand" en image/image (vaste toestand). Voordat we een container van het image kunnen maken, moeten een paar instellingen worden gemaakt.
## Stap 3: Zet het beeld in werking:
Ik dubbelklik op mijn paper merge image.
{{< gallery match="images/3/*.png" >}}
Dan klik ik op "Geavanceerde instellingen" en activeer de "Automatische herstart". Ik selecteer de tab "Volume" en klik op "Map toevoegen". Daar maak ik een nieuwe database map aan met dit mount pad "/data".
{{< gallery match="images/4/*.png" >}}
Ik bewaar hier ook een tweede map die ik opneem met het mount pad "/config". Het maakt niet echt uit waar deze map is. Het is echter belangrijk dat het behoort tot de Synology admin gebruiker.
{{< gallery match="images/5/*.png" >}}
Ik wijs vaste poorten toe voor de "Papermerge" container. Zonder vaste poorten kan het zijn dat de "Papermerge server" na een herstart op een andere poort draait.
{{< gallery match="images/6/*.png" >}}
Tenslotte voer ik drie omgevingsvariabelen in. De variabele "PUID" is de gebruikers-ID en "PGID" is de groeps-ID van mijn admin-gebruiker. U kunt de PGID/PUID achterhalen via SSH met het commando "cat /etc/passwd | grep admin".
{{< gallery match="images/7/*.png" >}}
Na deze instellingen kan de Papermerge server worden opgestart! Daarna kan Papermerge worden opgeroepen via het Ip-adres van het Synology disctation en de toegewezen poort, bijvoorbeeld http://192.168.21.23:8095.
{{< gallery match="images/8/*.png" >}}
De standaard login is admin met wachtwoord admin.
## Hoe werkt Papermerge?
Papermerge analyseert de tekst van documenten en afbeeldingen. Papermerge gebruikt een OCR/"optical character recognition" bibliotheek genaamd tesseract, uitgegeven door Goolge.
{{< gallery match="images/9/*.png" >}}
Ik heb een map gemaakt met de naam "Alles met Lorem" om de automatische documenttoewijzing te testen. Daarna klikte ik een nieuw herkenningspatroon samen in het menu-item "Automaten".
{{< gallery match="images/10/*.png" >}}
Alle nieuwe documenten die het woord "Lorem" bevatten, worden in de map "Alles met Lorem" geplaatst en krijgen de tag "heeft-lorem". Het is belangrijk om een komma te gebruiken in de tags, anders wordt de tag niet gezet. Als u een corresponderend document uploadt, wordt het getagd en gesorteerd.
{{< gallery match="images/11/*.png" >}}
