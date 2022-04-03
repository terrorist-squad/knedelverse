+++
date = "2022-03-21"
title = "Stora saker med containrar: Spela in MP3-filer från radion"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "radio", "mp3", "ripp", "streamripper", "radiorecorder"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220321-docker-mighty-mixxx-tapper/index.sv.md"
+++
Streamripper är ett verktyg för kommandoraden som kan användas för att spela in MP3- eller OGG/Vorbis-strömmar och spara dem direkt på hårddisken. Låtarna namnges automatiskt efter artisten och sparas individuellt, formatet är det som ursprungligen skickades (så i praktiken skapas filer med tillägget .mp3 eller .ogg). Jag hittade ett bra gränssnitt för radiobandspelare och byggde en Docker-avbildning av det, se: https://github.com/terrorist-squad/mightyMixxxTapper/
{{< gallery match="images/1/*.png" >}}

## Alternativ för yrkesverksamma
Som erfaren Synology-användare kan du naturligtvis logga in med SSH och installera hela installationen via Docker Compose-filen.
```
version: "2.0"
services:
  mealie:
    container_name: mighty-mixxx-tapper
    image: chrisknedel/mighty-mixxx-tapper:latest
    restart: always
    ports:
      - 9000:80
    environment:
      TZ: Europa/Berlin
    volumes:
      - ./ripps/:/tmp/ripps/

```

## Steg 1: Sök efter Docker-avbildningen
Jag klickar på fliken "Registration" i Synology Docker-fönstret och söker efter "mighty-mixxx-tapper". Jag väljer Docker-avbildningen "chrisknedel/mighty-mixxx-tapper" och klickar sedan på taggen "latest".
{{< gallery match="images/2/*.png" >}}
När bilden har laddats ner finns den tillgänglig som en bild. Docker skiljer mellan två tillstånd, container (dynamiskt tillstånd) och image/image (fast tillstånd). Innan vi kan skapa en behållare från avbildningen måste några inställningar göras.
## Steg 2: Använd bilden:
Jag dubbelklickar på min bild "mighty-mixxx-tapper".
{{< gallery match="images/3/*.png" >}}
Sedan klickar jag på "Avancerade inställningar" och aktiverar "Automatisk omstart". Jag väljer fliken "Volume" och klickar på "Add Folder". Där skapar jag en ny mapp med denna monteringssökväg "/tmp/ripps/".
{{< gallery match="images/4/*.png" >}}
Jag tilldelar fasta portar för behållaren "mighty-mixxx-tapper". Utan fasta portar kan det hända att "mighty-mixxx-tapper-server" körs på en annan port efter en omstart.
{{< gallery match="images/5/*.png" >}}
Efter dessa inställningar kan mighty-mixxx-tapper-server startas! Därefter kan du ringa mighty-mixxx-tapper via Ip-adressen till Synology-disctationen och den tilldelade porten, till exempel http://192.168.21.23:8097.
{{< gallery match="images/6/*.png" >}}
