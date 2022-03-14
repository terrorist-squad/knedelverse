+++
date = "2020-02-13"
title = "Synology-Nas: Confluence som ett wikisystem"
difficulty = "level-4"
tags = ["atlassian", "confluence", "Docker", "ds918", "Synology", "wiki", "nas"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200213-synology-confluence/index.sv.md"
+++
Om du vill installera Atlassian Confluence på en Synology NAS har du kommit till rätt ställe.
## Steg 1
Först öppnar jag Docker-appen i Synologys gränssnitt och går sedan till underpunkten "Registration". Där söker jag efter "Confluence" och klickar på den första bilden "Atlassian Confluence".
{{< gallery match="images/1/*.png" >}}

## Steg 2
När bilden har laddats ner finns den tillgänglig som en bild. Docker skiljer mellan två tillstånd: container (dynamiskt tillstånd) och image/image (fast tillstånd). Innan vi kan skapa en behållare från avbildningen måste några inställningar göras.
## Automatisk omstart
Jag dubbelklickar på min Confluence-avbildning.
{{< gallery match="images/2/*.png" >}}
Sedan klickar jag på "Avancerade inställningar" och aktiverar "Automatisk omstart".
{{< gallery match="images/3/*.png" >}}

## Hamnar
Jag tilldelar Confluence-behållaren fasta portar. Utan fasta portar kan Confluence köras på en annan port efter en omstart.
{{< gallery match="images/4/*.png" >}}

## Minne
Jag skapar en fysisk mapp och monterar den i behållaren (/var/atlassian/application-data/confluence/). Den här inställningen underlättar säkerhetskopiering och återställning av data.
{{< gallery match="images/5/*.png" >}}
Efter dessa inställningar kan Confluence startas!
{{< gallery match="images/6/*.png" >}}