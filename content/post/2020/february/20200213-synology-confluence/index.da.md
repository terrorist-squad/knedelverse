+++
date = "2020-02-13"
title = "Synology-Nas: Confluence som et wikisystem"
difficulty = "level-4"
tags = ["atlassian", "confluence", "Docker", "ds918", "Synology", "wiki", "nas"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200213-synology-confluence/index.da.md"
+++
Hvis du ønsker at installere Atlassian Confluence på en Synology NAS, er du kommet til det rette sted.
## Trin 1
Først åbner jeg Docker-appen i Synology-grænsefladen og går derefter til underpunktet "Registration". Der søger jeg efter "Confluence" og klikker på det første billede "Atlassian Confluence".
{{< gallery match="images/1/*.png" >}}

## Trin 2
Når billedet er downloadet, er det tilgængeligt som et billede. Docker skelner mellem 2 tilstande, container "dynamisk tilstand" og image/image (fast tilstand). Før vi kan oprette en container fra billedet, skal der foretages et par indstillinger.
## Automatisk genstart
Jeg dobbeltklikker på mit Confluence-aftryk.
{{< gallery match="images/2/*.png" >}}
Derefter klikker jeg på "Avancerede indstillinger" og aktiverer "Automatisk genstart".
{{< gallery match="images/3/*.png" >}}

## Havne
Jeg tildeler faste porte til Confluence-containeren. Uden faste porte kan Confluence muligvis køre på en anden port efter en genstart.
{{< gallery match="images/4/*.png" >}}

## Hukommelse
Jeg opretter en fysisk mappe og monterer den i containeren (/var/atlassian/application-data/confluence/). Denne indstilling gør det lettere at sikkerhedskopiere og gendanne data.
{{< gallery match="images/5/*.png" >}}
Efter disse indstillinger kan Confluence startes!
{{< gallery match="images/6/*.png" >}}