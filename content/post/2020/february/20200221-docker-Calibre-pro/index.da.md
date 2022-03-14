+++
date = "2020-02-21"
title = "Store ting med containere: Kørsel af Calibre med Docker Compose (Synology pro-opsætning)"
difficulty = "level-3"
tags = ["calibre", "calibre-web", "Docker", "docker-compose", "Synology", "linux"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200221-docker-Calibre-pro/index.da.md"
+++
Der findes allerede en lettere vejledning på denne blog: [Synology-Nas: Installer Calibre Web som et e-bogbibliotek]({{< ref "post/2020/february/20200213-synology-calibreweb" >}} "Synology-Nas: Installer Calibre Web som et e-bogbibliotek"). Denne vejledning er for alle Synology DS-fagfolk.
## Trin 1: Forbered Synology
Først skal SSH-login være aktiveret på DiskStationen. Du kan gøre dette ved at gå til "Kontrolpanel" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Derefter kan du logge ind via "SSH", den angivne port og administratoradgangskoden (Windows-brugere bruger Putty eller WinSCP).
{{< gallery match="images/2/*.png" >}}
Jeg logger ind via Terminal, winSCP eller Putty og lader denne konsol være åben til senere.
## Trin 2: Opret en bogmappe
Jeg opretter en ny mappe til Calibre-biblioteket. For at gøre dette kalder jeg "System Control" -> "Shared Folder" og opretter en ny mappe kaldet "Books". Hvis der endnu ikke er nogen "Docker"-mappe, skal denne også oprettes.
{{< gallery match="images/3/*.png" >}}

## Trin 3: Forbered bogmappe
Nu skal følgende fil downloades og udpakkes: https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view. Indholdet ("metadata.db") skal placeres i den nye bogmappe, se:
{{< gallery match="images/4/*.png" >}}

## Trin 4: Forbered Docker-mappen
Jeg opretter en ny mappe med navnet "calibre" i Docker-mappen:
{{< gallery match="images/5/*.png" >}}
Derefter skifter jeg til den nye mappe og opretter en ny fil med navnet "calibre.yml" med følgende indhold:
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
I denne nye fil skal der justeres flere steder som følger:* PUID/PGID: Bruger- og gruppe-ID for DS-brugeren skal angives i PUID/PGID. Her bruger jeg konsollen fra "Trin 1" og kommandoerne "id -u" til at se bruger-id'et. Med kommandoen "id -g" får jeg gruppens ID.* ports: For porten skal den forreste del "8055:" justeres.directoriesAlle mapper i denne fil skal korrigeres. De korrekte adresser kan ses i DS'ens egenskabsvindue. (Skærmbillede følger)
{{< gallery match="images/6/*.png" >}}

## Trin 5: Teststart
Jeg kan også gøre god brug af konsollen i dette trin. Jeg skifter til Calibre-mappen og starter Calibre-serveren der via Docker Compose.
{{< terminal >}}
cd /volume1/docker/calibre
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}

{{< gallery match="images/7/*.png" >}}

## Trin 6: Opsætning
Derefter kan jeg ringe til min Calibre-server med diskstationens IP og den tildelte port fra "Trin 4". Jeg bruger mit "/books"-monteringspunkt i opsætningen. Herefter kan serveren allerede bruges.
{{< gallery match="images/8/*.png" >}}

## Trin 7: Færdiggørelse af opsætningen
Konsollen er også nødvendig i dette trin. Jeg bruger kommandoen "exec" til at gemme den container-interne programdatabase.
{{< terminal >}}
sudo docker exec -it calibre-web-server cp /app/calibre-web/app.db /briefkaste/app.db

{{</ terminal >}}
Derefter kan jeg se en ny "app.db"-fil i Calibre-mappen:
{{< gallery match="images/9/*.png" >}}
Derefter stopper jeg Calibre-serveren:
{{< terminal >}}
sudo docker-compose -f calibre.yml down

{{</ terminal >}}
Nu ændrer jeg brevkassestien og opretholder programdatabasen over den.
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
Herefter kan serveren genstartes:
{{< terminal >}}
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}