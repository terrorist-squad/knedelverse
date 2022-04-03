+++
date = "2020-02-07"
title = "Kort verhaal: Bash scripts met Elgato Stream Deck"
difficulty = "level-2"
tags = ["bash", "elgato", "skript", "stream-deck"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200221-Elgato%20Stream-Deck/index.nl.md"
+++
Als u een bash script in het Elgato Stream Deck wilt opnemen, heeft u eerst een bash script nodig.
## Stap 1: Maak een Bash script:
Ik maak een bestand aan genaamd "say-hallo.sh" met de volgende inhoud:
```
#!/bin/bash
say "hallo"

```

## Stap 2: Rechten instellen
Het volgende commando maakt het bestand uitvoerbaar:
{{< terminal >}}
chmod 755 say-hallo.sh

{{</ terminal >}}

## Stap 3: neem Bash script op in het deck
3.1) Nu kan de Stream Deck app worden geopend:
{{< gallery match="images/1/*.png" >}}
3.2) Dan sleep ik de "Open Systeem" actie naar een knop.
{{< gallery match="images/2/*.png" >}}
3.3) Nu kan ik mijn bash script kiezen:
{{< gallery match="images/3/*.png" >}}

## Stap 4: Klaar!
De nieuwe knop is nu bruikbaar.
