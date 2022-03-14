+++
date = "2021-04-25T09:28:11+01:00"
title = "Kort verhaal: Automatisch containers updaten met Watchtower"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210425-docker-Watchtower/index.nl.md"
+++
Als je Docker containers op je schijfstation draait, wil je natuurlijk dat ze altijd up to date zijn. Watchtower werkt beelden en containers automatisch bij. Zo kunt u genieten van de nieuwste functies en de meest actuele gegevensbeveiliging. Vandaag zal ik u tonen hoe u een Watchtower op het Synology diskstation installeert.
## Stap 1: Synology voorbereiden
Eerst moet de SSH-aanmelding op het DiskStation worden geactiveerd. Om dit te doen, ga naar het "Configuratiescherm" > "Terminal
{{< gallery match="images/1/*.png" >}}
Vervolgens kunt u inloggen via "SSH", de opgegeven poort en het beheerderswachtwoord (Windows-gebruikers gebruiken Putty of WinSCP).
{{< gallery match="images/2/*.png" >}}
Ik log in via Terminal, winSCP of Putty en laat deze console open voor later.
## Stap 2: Installeer Watchtower
Ik gebruik de console hiervoor:
{{< terminal >}}
docker run --name watchtower --restart always -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower

{{</ terminal >}}
Daarna draait Watchtower altijd op de achtergrond.
{{< gallery match="images/3/*.png" >}}
