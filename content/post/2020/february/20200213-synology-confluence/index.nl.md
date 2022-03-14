+++
date = "2020-02-13"
title = "Synology-Nas: Confluence als een wiki-systeem"
difficulty = "level-4"
tags = ["atlassian", "confluence", "Docker", "ds918", "Synology", "wiki", "nas"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200213-synology-confluence/index.nl.md"
+++
Als u Atlassian Confluence wilt installeren op een Synology NAS, dan bent u op de juiste plaats.
## Stap 1
Eerst open ik de Docker-app in de Synology-interface en ga dan naar het sub-item "Registratie". Daar zoek ik naar "Confluence" en klik op het eerste plaatje "Atlassian Confluence".
{{< gallery match="images/1/*.png" >}}

## Stap 2
Na het downloaden van de afbeelding, is de afbeelding beschikbaar als een afbeelding. Docker maakt onderscheid tussen 2 toestanden, container "dynamische toestand" en image/image (vaste toestand). Voordat we een container kunnen maken van de image, moeten een paar instellingen worden gemaakt.
## Automatische herstart
Ik dubbelklik op mijn Confluence image.
{{< gallery match="images/2/*.png" >}}
Dan klik ik op "Geavanceerde instellingen" en activeer de "Automatische herstart".
{{< gallery match="images/3/*.png" >}}

## Poorten
Ik wijs vaste poorten toe voor de Confluence container. Zonder vaste poorten zou Confluence na een herstart op een andere poort kunnen draaien.
{{< gallery match="images/4/*.png" >}}

## Geheugen
Ik maak een fysieke map aan en mount deze in de container (/var/atlassian/application-data/confluence/). Deze instelling maakt het maken van back-ups en het herstellen van gegevens gemakkelijker.
{{< gallery match="images/5/*.png" >}}
Na deze instellingen kan Confluence worden opgestart!
{{< gallery match="images/6/*.png" >}}