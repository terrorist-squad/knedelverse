+++
date = "2020-02-07"
title = "Krátký příběh: Skripty Bash s Elgato Stream Deck"
difficulty = "level-2"
tags = ["bash", "elgato", "skript", "stream-deck"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200221-Elgato%20Stream-Deck/index.cs.md"
+++
Chcete-li do aplikace Elgato Stream Deck zahrnout skript bash, potřebujete nejprve skript bash.
## Krok 1: Vytvoření skriptu Bash:
Vytvořím soubor s názvem "say-hallo.sh" s následujícím obsahem:
```
#!/bin/bash
say "hallo"

```

## Krok 2: Nastavení práv
Následujícím příkazem se soubor stane spustitelným:
{{< terminal >}}
chmod 755 say-hallo.sh

{{</ terminal >}}

## Krok 3: Zahrnutí skriptu Bash do balíčku
3.1) Nyní můžete otevřít aplikaci Stream Deck:
{{< gallery match="images/1/*.png" >}}
3.2) Poté přetáhnu akci "Otevřít systém" na tlačítko.
{{< gallery match="images/2/*.png" >}}
3.3) Nyní si mohu vybrat skript bash:
{{< gallery match="images/3/*.png" >}}

## Krok 4: Hotovo!
Nové tlačítko je nyní použitelné.
