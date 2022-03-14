+++
date = "2021-04-18"
title = "Stora saker med behållare: Kör Docspell DMS på Synology DiskStation"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "Document-Managment-System"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-Docspell/index.sv.md"
+++
Docspell är ett dokumenthanteringssystem för Synology DiskStation. Med Docspell kan dokument indexeras, sökas och hittas mycket snabbare. Idag visar jag hur man installerar en Docspell-tjänst på Synology Disk Station.
## Steg 1: Förbered Synology
Först måste SSH-inloggningen aktiveras på DiskStationen. Detta gör du genom att gå till "Kontrollpanelen" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Därefter kan du logga in via "SSH", den angivna porten och administratörslösenordet (Windows-användare använder Putty eller WinSCP).
{{< gallery match="images/2/*.png" >}}
Jag loggar in via Terminal, winSCP eller Putty och lämnar denna konsol öppen för senare.
## Steg 2: Skapa mappen Docspel
Jag skapar en ny katalog som heter "docspell" i Dockerkatalogen.
{{< gallery match="images/3/*.png" >}}
Nu måste följande fil laddas ner och packas upp i katalogen: https://github.com/eikek/docspell/archive/refs/heads/master.zip . Jag använder konsolen för detta:
{{< terminal >}}
cd /volume1/docker/docspell/
mkdir docs
mkdir postgres_data
wget https://github.com/eikek/docspell/archive/refs/heads/master.zip 
/bin/7z x master.zip

{{</ terminal >}}
Sedan redigerar jag filen "docker/docker-compose.yml" och anger mina Synology-adresser i "consumedir" och "db":
{{< gallery match="images/4/*.png" >}}
Därefter kan jag starta Compose-filen:
{{< terminal >}}
cd docspell-master/docker/
docker-compose up -d

{{</ terminal >}}
Efter några minuter kan jag ringa min Docspell-server med diskstationens IP och den tilldelade porten/7878.
{{< gallery match="images/5/*.png" >}}
