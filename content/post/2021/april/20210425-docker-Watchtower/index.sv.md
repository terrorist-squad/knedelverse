+++
date = "2021-04-25T09:28:11+01:00"
title = "Kort berättelse: Automatisk uppdatering av behållare med Watchtower"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Watchtower/index.sv.md"
+++
Om du kör Docker-containrar på din diskstation vill du naturligtvis att de alltid ska vara uppdaterade. Watchtower uppdaterar bilder och behållare automatiskt. På så sätt kan du få tillgång till de senaste funktionerna och den mest uppdaterade datasäkerheten. Idag ska jag visa hur man installerar ett Watchtower på Synology diskstation.
## Steg 1: Förbered Synology
Först måste SSH-inloggningen aktiveras på DiskStationen. Detta gör du genom att gå till "Kontrollpanelen" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Därefter kan du logga in via "SSH", den angivna porten och administratörslösenordet (Windows-användare använder Putty eller WinSCP).
{{< gallery match="images/2/*.png" >}}
Jag loggar in via Terminal, winSCP eller Putty och lämnar denna konsol öppen för senare.
## Steg 2: Installera Watchtower
Jag använder konsolen för detta:
{{< terminal >}}
docker run --name watchtower --restart always -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower

{{</ terminal >}}
Därefter körs Watchtower alltid i bakgrunden.
{{< gallery match="images/3/*.png" >}}
