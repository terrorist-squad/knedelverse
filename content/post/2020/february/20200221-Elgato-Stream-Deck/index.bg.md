+++
date = "2020-02-07"
title = "Кратка история: Bash скриптове с Elgato Stream Deck"
difficulty = "level-2"
tags = ["bash", "elgato", "skript", "stream-deck"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200221-Elgato%20Stream-Deck/index.bg.md"
+++
Ако искате да включите bash скрипт в Elgato Stream Deck, първо се нуждаете от bash скрипт.
## Стъпка 1: Създаване на Bash скрипт:
Създавам файл, наречен "say-hallo.sh", със следното съдържание:
```
#!/bin/bash
say "hallo"

```

## Стъпка 2: Задаване на права
Следната команда прави файла изпълним:
{{< terminal >}}
chmod 755 say-hallo.sh

{{</ terminal >}}

## Стъпка 3: Включване на Bash скрипт в палубата
3.1) Сега можете да отворите приложението Stream Deck:
{{< gallery match="images/1/*.png" >}}
3.2) След това плъзгам действието "Open System" върху бутон.
{{< gallery match="images/2/*.png" >}}
3.3) Сега мога да избера моя bash скрипт:
{{< gallery match="images/3/*.png" >}}

## Стъпка 4: Готово!
