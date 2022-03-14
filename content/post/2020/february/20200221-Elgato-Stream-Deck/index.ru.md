+++
date = "2020-02-07"
title = "Краткая история: Bash-скрипты с Elgato Stream Deck"
difficulty = "level-2"
tags = ["bash", "elgato", "skript", "stream-deck"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200221-Elgato%20Stream-Deck/index.ru.md"
+++
Если вы хотите включить сценарий bash в Elgato Stream Deck, вам сначала понадобится сценарий bash.
## Шаг 1: Создайте сценарий Bash:
Я создаю файл под названием "say-hallo.sh" со следующим содержимым:
```
#!/bin/bash
say "hallo"

```

## Шаг 2: Установите права
Следующая команда делает файл исполняемым:
{{< terminal >}}
chmod 755 say-hallo.sh

{{</ terminal >}}

## Шаг 3: Включите Bash-скрипт в колоду
3.1) Теперь можно открыть приложение Stream Deck:
{{< gallery match="images/1/*.png" >}}
3.2) Затем я перетаскиваю действие "Открыть систему" на кнопку.
{{< gallery match="images/2/*.png" >}}
3.3) Теперь я могу выбрать свой сценарий bash:
{{< gallery match="images/3/*.png" >}}

## Шаг 4: Готово!
