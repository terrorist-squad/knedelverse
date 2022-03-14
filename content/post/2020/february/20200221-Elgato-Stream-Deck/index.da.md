+++
date = "2020-02-07"
title = "Kort historie: Bash-scripts med Elgato Stream Deck"
difficulty = "level-2"
tags = ["bash", "elgato", "skript", "stream-deck"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200221-Elgato%20Stream-Deck/index.da.md"
+++
Hvis du ønsker at inkludere et bash-script i Elgato Stream Deck, skal du først have et bash-script.
## Trin 1: Opret et Bash-script:
Jeg opretter en fil med navnet "say-hallo.sh" med følgende indhold:
```
#!/bin/bash
say "hallo"

```

## Trin 2: Indstil rettigheder
Den følgende kommando gør filen eksekverbar:
{{< terminal >}}
chmod 755 say-hallo.sh

{{</ terminal >}}

## Trin 3: Medtag Bash-script i dækket
3.1) Nu kan Stream Deck-appen åbnes:
{{< gallery match="images/1/*.png" >}}
3.2) Derefter trækker jeg "Åbn system"-handlingen over på en knap.
{{< gallery match="images/2/*.png" >}}
3.3) Nu kan jeg vælge mit bash-script:
{{< gallery match="images/3/*.png" >}}

## Trin 4: Færdig!
