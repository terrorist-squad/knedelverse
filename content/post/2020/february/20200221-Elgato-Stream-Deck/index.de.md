+++
date = "2020-02-07"
title = "Kurzgeschichte: Bash-Skripte mit Elgato Stream Deck"
difficulty = "level-2"
tags = ["bash", "elgato", "skript", "stream-deck"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200221-Elgato%20Stream-Deck/index.de.md"
+++

Wenn man ein Bash – Skript im Elgato Stream-Deck einzubinden will, dann benötigt man zuerst ein Bash-Skript.

## Schritt 1: Bash-Skript erstellen:
Ich lege eine Datei namens „say-hallo.sh“ mit folgendem Inhalt an:
```
#!/bin/bash
say "hallo"
```

## Schritt 2: Rechte setzen
Mit dem folgenden Befehl wird die Datei ausführbar gemacht:
{{< terminal >}}
chmod 755 say-hallo.sh
{{</ terminal >}}

## Schritt 3: Bash-Skript ins Deck aufnehmen
3.1) Nun kann die Stream-Deck-App geöffnet werden:
{{< gallery match="images/1/*.png" >}}

3.2) Anschließend ziehe ich die „System:öffnen“ – Aktion auf einen Button
{{< gallery match="images/2/*.png" >}}

3.3) Jetzt kann ich mein Bash-Skript wählen:
{{< gallery match="images/3/*.png" >}}

## Schritt 4: Fertig!
Der neue Button ist nun nutzbar. 