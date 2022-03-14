+++
date = "2020-02-07"
title = "Kratka zgodba: skripte Bash z Elgato Stream Deck"
difficulty = "level-2"
tags = ["bash", "elgato", "skript", "stream-deck"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200221-Elgato%20Stream-Deck/index.sl.md"
+++
Če želite v Elgato Stream Deck vključiti skripto bash, najprej potrebujete skripto bash.
## Korak 1: Ustvarite skripto Bash:
Ustvarim datoteko z imenom "say-hallo.sh" z naslednjo vsebino:
```
#!/bin/bash
say "hallo"

```

## Korak 2: Nastavitev pravic
Z naslednjim ukazom naredite datoteko izvršljivo:
{{< terminal >}}
chmod 755 say-hallo.sh

{{</ terminal >}}

## Korak 3: Vključite skript Bash v krov
3.1) Zdaj lahko odprete aplikacijo Stream Deck:
{{< gallery match="images/1/*.png" >}}
3.2) Nato povlečem akcijo "Odpri sistem" na gumb.
{{< gallery match="images/2/*.png" >}}
3.3) Zdaj lahko izberem svojo bash skripto:
{{< gallery match="images/3/*.png" >}}

## Korak 4: Končano!
