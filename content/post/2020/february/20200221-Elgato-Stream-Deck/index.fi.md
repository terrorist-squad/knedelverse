+++
date = "2020-02-07"
title = "Lyhyt tarina: Bash-skriptit Elgato Stream Deckillä"
difficulty = "level-2"
tags = ["bash", "elgato", "skript", "stream-deck"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200221-Elgato%20Stream-Deck/index.fi.md"
+++
Jos haluat sisällyttää bash-skriptin Elgato Stream Deckiin, tarvitset ensin bash-skriptin.
## Vaihe 1: Luo Bash-skripti:
Luon tiedoston nimeltä "say-hallo.sh", jonka sisältö on seuraava:
```
#!/bin/bash
say "hallo"

```

## Vaihe 2: Aseta oikeudet
Seuraava komento tekee tiedostosta suoritettavan:
{{< terminal >}}
chmod 755 say-hallo.sh

{{</ terminal >}}

## Vaihe 3: Sisällytä Bash-skripti pakkaan
3.1) Nyt Stream Deck -sovellus voidaan avata:
{{< gallery match="images/1/*.png" >}}
3.2) Sitten vedän "Open System" -toiminnon painikkeeseen.
{{< gallery match="images/2/*.png" >}}
3.3) Nyt voin valita bash-skriptini:
{{< gallery match="images/3/*.png" >}}

## Vaihe 4: Valmis!
