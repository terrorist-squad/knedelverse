+++
date = "2021-07-25"
title = "Stora saker med behållare: kylskåpshantering med Grocy"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "kühlschrank", "erp", "mhd", "Speispläne", "cms", "Cafe", "Bistro"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/july/20210725-docker-grocy/index.sv.md"
+++
Med Grocy kan du hantera ett helt hushåll, en restaurang, ett café, en bistro eller en matmarknad. Du kan hantera kylskåp, menyer, uppgifter, inköpslistor och bäst-före-datum för livsmedel.
{{< gallery match="images/1/*.png" >}}
Idag visar jag hur man installerar en Grocy-tjänst på Synology Disk Station.
## Alternativ för yrkesverksamma
Som erfaren Synology-användare kan du naturligtvis logga in med SSH och installera hela installationen via Docker Compose-filen.
```
version: "2.1"
services:
  grocy:
    image: ghcr.io/linuxserver/grocy
    container_name: grocy
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./data:/config
    ports:
      - 9283:80
    restart: unless-stopped

```
Fler användbara Docker-avbildningar för hemmabruk finns i [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Steg 1: Förbered Grocy-mappen
Jag skapar en ny katalog som heter "grocy" i Dockerkatalogen.
{{< gallery match="images/2/*.png" >}}

## Steg 2: Installera Grocy
Jag klickar på fliken "Registration" i Synology Docker-fönstret och söker efter "Grocy". Jag väljer Docker-avbildningen "linuxserver/grocy:latest" och klickar sedan på taggen "latest".
{{< gallery match="images/3/*.png" >}}
Jag dubbelklickar på min Grocy-bild.
{{< gallery match="images/4/*.png" >}}
Sedan klickar jag på "Avancerade inställningar" och aktiverar "Automatisk omstart" även här. Jag väljer fliken "Volume" och klickar på "Add Folder". Där skapar jag en ny mapp med denna monteringssökväg "/config".
{{< gallery match="images/5/*.png" >}}
Jag tilldelar fasta portar för "Grocy"-behållaren. Utan fasta portar kan det vara så att "Grocy-servern" körs på en annan port efter en omstart.
{{< gallery match="images/6/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Variabelns namn|Värde|Vad är det?|
|--- | --- |---|
|TZ | Europe/Berlin |Tidszon|
|PUID | 1024 |Användar-ID från Synology Admin User|
|PGID |	100 |Grupp-ID från Synology Admin-användare|
{{</table>}}
Slutligen anger jag dessa miljövariabler:Se:
{{< gallery match="images/7/*.png" >}}
Behållaren kan nu startas. Jag ringer upp Grocy-servern med Synologys IP-adress och min containerport och loggar in med användarnamnet "admin" och lösenordet "admin".
{{< gallery match="images/8/*.png" >}}
