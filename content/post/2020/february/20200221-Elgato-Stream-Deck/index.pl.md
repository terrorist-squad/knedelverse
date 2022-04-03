+++
date = "2020-02-07"
title = "Krótka historia: skrypty Bash z Elgato Stream Deck"
difficulty = "level-2"
tags = ["bash", "elgato", "skript", "stream-deck"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200221-Elgato%20Stream-Deck/index.pl.md"
+++
Aby włączyć skrypt bash do Elgato Stream Deck, należy najpierw utworzyć skrypt bash.
## Krok 1: Utwórz skrypt Bash:
Tworzę plik o nazwie "say-hallo.sh" o następującej zawartości:
```
#!/bin/bash
say "hallo"

```

## Krok 2: Ustalanie praw
Poniższe polecenie powoduje, że plik staje się wykonywalny:
{{< terminal >}}
chmod 755 say-hallo.sh

{{</ terminal >}}

## Krok 3: Dołączanie skryptu Bash do pokładu
3.1) Teraz można otworzyć aplikację Stream Deck:
{{< gallery match="images/1/*.png" >}}
3.2) Następnie przeciągam akcję "Otwórz system" na przycisk.
{{< gallery match="images/2/*.png" >}}
3.3) Teraz mogę wybrać skrypt basha:
{{< gallery match="images/3/*.png" >}}

## Krok 4: Gotowe!
Nowy przycisk jest już gotowy do użycia.
