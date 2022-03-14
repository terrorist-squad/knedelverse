+++
date = "2021-04-25T09:28:11+01:00"
title = "Kort fortalt: Automatisk opdatering af containere med Watchtower"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Watchtower/index.da.md"
+++
Hvis du kører Docker-containere på din diskstation, vil du naturligvis gerne have, at de altid er opdaterede. Watchtower opdaterer billeder og containere automatisk. På denne måde kan du nyde godt af de nyeste funktioner og den mest opdaterede datasikkerhed. I dag vil jeg vise dig, hvordan du installerer et Watchtower på Synology diskstationen.
## Trin 1: Forbered Synology
Først skal SSH-login være aktiveret på DiskStationen. Du kan gøre dette ved at gå til "Kontrolpanel" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Derefter kan du logge ind via "SSH", den angivne port og administratoradgangskoden (Windows-brugere bruger Putty eller WinSCP).
{{< gallery match="images/2/*.png" >}}
Jeg logger ind via Terminal, winSCP eller Putty og lader denne konsol være åben til senere.
## Trin 2: Installer Watchtower
Jeg bruger konsollen til dette:
{{< terminal >}}
docker run --name watchtower --restart always -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower

{{</ terminal >}}
Herefter kører Watchtower altid i baggrunden.
{{< gallery match="images/3/*.png" >}}
