+++
date = "2020-02-07"
title = "Kort berättelse: Bash-skript med Elgato Stream Deck"
difficulty = "level-2"
tags = ["bash", "elgato", "skript", "stream-deck"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200221-Elgato%20Stream-Deck/index.sv.md"
+++
Om du vill inkludera ett bash-skript i Elgato Stream Deck behöver du först ett bash-skript.
## Steg 1: Skapa ett Bash-skript:
Jag skapar en fil som heter "say-hallo.sh" med följande innehåll:
```
#!/bin/bash
say "hallo"

```

## Steg 2: Ange rättigheter
Följande kommando gör filen körbar:
{{< terminal >}}
chmod 755 say-hallo.sh

{{</ terminal >}}

## Steg 3: Inkludera Bash-skriptet i däck
3.1) Nu kan du öppna appen Stream Deck:
{{< gallery match="images/1/*.png" >}}
3.2) Sedan drar jag åtgärden "Open System" till en knapp.
{{< gallery match="images/2/*.png" >}}
3.3) Nu kan jag välja mitt bash-skript:
{{< gallery match="images/3/*.png" >}}

## Steg 4: Klart!
