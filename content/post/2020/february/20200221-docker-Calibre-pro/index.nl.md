+++
date = "2020-02-21"
title = "Geweldige dingen met containers: Calibre draaien met Docker Compose (Synology pro setup)"
difficulty = "level-3"
tags = ["calibre", "calibre-web", "Docker", "docker-compose", "Synology", "linux"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200221-docker-Calibre-pro/index.nl.md"
+++
Er is al een eenvoudiger handleiding op deze blog: [Synology-Nas: Installeer Calibre Web als een ebook bibliotheek]({{< ref "post/2020/february/20200213-synology-calibreweb" >}} "Synology-Nas: Installeer Calibre Web als een ebook bibliotheek"). Deze handleiding is voor alle Synology DS-professionals.
## Stap 1: Synology voorbereiden
Eerst moet de SSH-aanmelding op het DiskStation worden geactiveerd. Om dit te doen, ga naar het "Configuratiescherm" > "Terminal
{{< gallery match="images/1/*.png" >}}
Vervolgens kunt u inloggen via "SSH", de opgegeven poort en het beheerderswachtwoord (Windows-gebruikers gebruiken Putty of WinSCP).
{{< gallery match="images/2/*.png" >}}
Ik log in via Terminal, winSCP of Putty en laat deze console open voor later.
## Stap 2: Maak een boekenmap aan
Ik maak een nieuwe map voor de Calibre bibliotheek. Om dit te doen, roep ik "System Control" -> "Shared Folder" op en maak een nieuwe map genaamd "Books". Als er nog geen "Docker" map is, dan moet deze ook aangemaakt worden.
{{< gallery match="images/3/*.png" >}}

## Stap 3: Maak de boekenmap klaar
Nu moet het volgende bestand worden gedownload en uitgepakt: https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view. De inhoud ("metadata.db") moet in de nieuwe boekenmap worden geplaatst, zie:
{{< gallery match="images/4/*.png" >}}

## Stap 4: Docker map klaarmaken
Ik maak een nieuwe map genaamd "calibre" in de Docker map:
{{< gallery match="images/5/*.png" >}}
Dan ga ik naar de nieuwe directory en maak een nieuw bestand genaamd "calibre.yml" met de volgende inhoud:
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre:/briefkaste
    ports:
      - 8055:8083
    restart: unless-stopped

```
In dit nieuwe bestand moeten op verschillende plaatsen de volgende aanpassingen worden aangebracht:* PUID/PGID: In PUID/PGID moeten de gebruikers- en groeps-ID van de DS-gebruiker worden ingevoerd. Hier gebruik ik de console van "Stap 1" en de commando's "id -u" om de gebruikers-ID te zien. Met het commando "id -g" krijg ik de groep ID.* ports: Voor de poort moet het voorste deel "8055:" aangepast worden.directoriesAlle directories in dit bestand moeten gecorrigeerd worden. De juiste adressen zijn te zien in het eigenschappenvenster van de DS. (Schermafbeelding volgt)
{{< gallery match="images/6/*.png" >}}

## Stap 5: Proefstart
Ik kan ook goed gebruik maken van de console in deze stap. Ik ga naar de Calibre directory en start de Calibre server daar via Docker Compose.
{{< terminal >}}
cd /volume1/docker/calibre
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}

{{< gallery match="images/7/*.png" >}}

## Stap 6: Instelling
Dan kan ik mijn Calibre server oproepen met het IP van het diskstation en de toegewezen poort van "Stap 4". In de setup, gebruik ik mijn "/books" koppelpunt. Daarna is de server al bruikbaar.
{{< gallery match="images/8/*.png" >}}

## Stap 7: De installatie afronden
De console is ook nodig in deze stap. Ik gebruik het commando "exec" om de container-interne applicatie database op te slaan.
{{< terminal >}}
sudo docker exec -it calibre-web-server cp /app/calibre-web/app.db /briefkaste/app.db

{{</ terminal >}}
Daarna zie ik een nieuw "app.db" bestand in de Calibre directory:
{{< gallery match="images/9/*.png" >}}
Dan stop ik de Calibre server:
{{< terminal >}}
sudo docker-compose -f calibre.yml down

{{</ terminal >}}
Nu verander ik het brievenbus pad en persisteer de applicatie database er overheen.
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre/app.db:/app/calibre-web/app.db
    ports:
      - 8055:8083
    restart: unless-stopped

```
Daarna kan de server opnieuw worden opgestart:
{{< terminal >}}
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}
