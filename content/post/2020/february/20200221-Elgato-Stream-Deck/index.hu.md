+++
date = "2020-02-07"
title = "Rövid történet: Bash szkriptek az Elgato Stream Deckkel"
difficulty = "level-2"
tags = ["bash", "elgato", "skript", "stream-deck"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200221-Elgato%20Stream-Deck/index.hu.md"
+++
Ha bash-szkriptet szeretne beépíteni az Elgato Stream Deckbe, először is szüksége van egy bash-szkriptre.
## 1. lépés: Bash-szkript létrehozása:
Létrehozok egy "say-hallo.sh" nevű fájlt a következő tartalommal:
```
#!/bin/bash
say "hallo"

```

## 2. lépés: Jogok beállítása
A következő parancs futtathatóvá teszi a fájlt:
{{< terminal >}}
chmod 755 say-hallo.sh

{{</ terminal >}}

## 3. lépés: Bash script beépítése a pakliba
3.1) Most már megnyitható a Stream Deck alkalmazás:
{{< gallery match="images/1/*.png" >}}
3.2) Ezután a "Rendszer megnyitása" műveletet egy gombra húzom.
{{< gallery match="images/2/*.png" >}}
3.3) Most már kiválaszthatom a bash szkriptemet:
{{< gallery match="images/3/*.png" >}}

## 4. lépés: Kész!
