+++
date = "2020-02-21"
title = "Stora saker med containrar: Kör Calibre med Docker Compose (Synology pro setup)"
difficulty = "level-3"
tags = ["calibre", "calibre-web", "Docker", "docker-compose", "Synology", "linux"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200221-docker-Calibre-pro/index.sv.md"
+++
Det finns redan en enklare handledning på den här bloggen: [Synology-Nas: Installera Calibre Web som ett e-boksbibliotek]({{< ref "post/2020/february/20200213-synology-calibreweb" >}} "Synology-Nas: Installera Calibre Web som ett e-boksbibliotek"). Den här handledningen är avsedd för alla som arbetar med Synology DS.
## Steg 1: Förbered Synology
Först måste SSH-inloggningen aktiveras på DiskStationen. Detta gör du genom att gå till "Kontrollpanelen" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Därefter kan du logga in via "SSH", den angivna porten och administratörslösenordet (Windows-användare använder Putty eller WinSCP).
{{< gallery match="images/2/*.png" >}}
Jag loggar in via Terminal, winSCP eller Putty och lämnar denna konsol öppen för senare.
## Steg 2: Skapa en bokmapp
Jag skapar en ny mapp för Calibre-biblioteket. För att göra detta öppnar jag "System Control" -> "Shared Folder" och skapar en ny mapp som heter "Books". Om det ännu inte finns någon mapp "Docker" måste den också skapas.
{{< gallery match="images/3/*.png" >}}

## Steg 3: Förbered bokmappen
Nu måste följande fil laddas ner och packas upp: https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view. Innehållet ("metadata.db") måste placeras i den nya bokkatalogen, se:
{{< gallery match="images/4/*.png" >}}

## Steg 4: Förbered Docker-mappen
Jag skapar en ny katalog som heter "calibre" i Docker-katalogen:
{{< gallery match="images/5/*.png" >}}
Sedan byter jag till den nya katalogen och skapar en ny fil som heter "calibre.yml" med följande innehåll:
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
I denna nya fil måste flera ställen justeras enligt följande:* PUID/PGID: Användar- och grupp-ID för DS-användaren måste anges i PUID/PGID. Här använder jag konsolen från "Steg 1" och kommandot "id -u" för att se användar-ID. Med kommandot "id -g" får jag fram grupp-ID.* ports: För porten måste den främre delen "8055:" justeras.directoriesAlla kataloger i den här filen måste korrigeras. De korrekta adresserna kan ses i DS:s egenskapsfönster. (Skärmdump följer)
{{< gallery match="images/6/*.png" >}}

## Steg 5: Teststart
Jag kan också utnyttja konsolen i det här steget. Jag byter till Calibre-katalogen och startar Calibre-servern där via Docker Compose.
{{< terminal >}}
cd /volume1/docker/calibre
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}

{{< gallery match="images/7/*.png" >}}

## Steg 6: Inställning
Sedan kan jag ringa min Calibre-server med diskstationens IP och den tilldelade porten från "Steg 4". Jag använder min monteringspunkt "/books" i installationen. Därefter är servern redan användbar.
{{< gallery match="images/8/*.png" >}}

## Steg 7: Slutföra installationen
Konsolen behövs också i detta steg. Jag använder kommandot "exec" för att spara den behållarinterna programdatabasen.
{{< terminal >}}
sudo docker exec -it calibre-web-server cp /app/calibre-web/app.db /briefkaste/app.db

{{</ terminal >}}
Därefter ser jag en ny "app.db"-fil i Calibre-katalogen:
{{< gallery match="images/9/*.png" >}}
Därefter stoppar jag Calibre-servern:
{{< terminal >}}
sudo docker-compose -f calibre.yml down

{{</ terminal >}}
Nu ändrar jag brevlådans sökväg och upprätthåller programdatabasen över den.
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
Därefter kan servern startas om:
{{< terminal >}}
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}