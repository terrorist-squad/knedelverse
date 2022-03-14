+++
date = "2020-02-13"
title = "Synology-Nas: Confluence als Wiki-System"
difficulty = "level-4"
tags = ["atlassian", "confluence", "Docker", "ds918", "Synology", "wiki", "nas"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200213-synology-confluence/index.de.md"
+++

Wenn Sie Atlassian Confluence auf einen Synology NAS installieren wollen, dann sind Sie hier richtig.

## Schritt 1
Als erstes öffne ich die Docker-App im Synology-Interface und gehe anschließend auf den Unterpunkt „Registrierung“. Dort suche ich nach „Confluence“ und klicke auf das erste Image „Atlassian Confluence“.
{{< gallery match="images/1/*.png" >}}

## Schritt 2
Nach dem Image – Download liegt das Image als Abbild bereit. Docker unterscheide zwischen 2 Zuständen, Container „Dynamisch zustand“ und Image/Abbild (Festzustand). Bevor wir nun einen Container aus dem Abbild erzeugen, müssen noch ein paar Einstellungen getätigt werden.

## Automatischen Neustart
Ich klicke per Doppelklick  auf mein Confluence-Abbild. 
{{< gallery match="images/2/*.png" >}}

Danach klicke ich auf „Erweiterte Einstellungen“ und aktiviere den „Automatischen Neustart". 
{{< gallery match="images/3/*.png" >}}

## Ports
Ich vergebe feste Ports für den Confluence – Container. Ohne feste Ports könnte es sein, dass Confluence nach einem Neustart auf einen anderen Port läuft.
{{< gallery match="images/4/*.png" >}}

## Speicher
Ich erstelle einen physikalischen Ordner und mounte diesen in den Container (/var/atlassian/application-data/confluence/). Diese Einstellung macht das Backup und Wiederherstellen von Daten einfacher.
{{< gallery match="images/5/*.png" >}}

Nach diesen Einstellungen kann Confluence gestartet werden!
{{< gallery match="images/6/*.png" >}}