+++
date = "2020-02-07"
title = "Krátky príbeh: Skripty Bash s Elgato Stream Deck"
difficulty = "level-2"
tags = ["bash", "elgato", "skript", "stream-deck"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200221-Elgato%20Stream-Deck/index.sk.md"
+++
Ak chcete do Elgato Stream Deck zahrnúť skript bash, potrebujete najprv skript bash.
## Krok 1: Vytvorenie skriptu Bash:
Vytvorím súbor s názvom "say-hallo.sh" s nasledujúcim obsahom:
```
#!/bin/bash
say "hallo"

```

## Krok 2: Nastavenie práv
Nasledujúci príkaz vykoná súbor:
{{< terminal >}}
chmod 755 say-hallo.sh

{{</ terminal >}}

## Krok 3: Zahrnutie skriptu Bash do balíka
3.1) Teraz môžete otvoriť aplikáciu Stream Deck:
{{< gallery match="images/1/*.png" >}}
3.2) Potom pretiahnem akciu "Otvoriť systém" na tlačidlo.
{{< gallery match="images/2/*.png" >}}
3.3) Teraz si môžem vybrať svoj bash skript:
{{< gallery match="images/3/*.png" >}}

## Krok 4: Hotovo!
