+++
date = "2021-04-04"
title = "Кратка история: Контрол на работния плот с xDoTools и xClip"
difficulty = "level-3"
tags = ["bash", "linux", "robot", "roboter", "linux", "Robotic-Process-Automation", "rpa", "xclip", "xdotool"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-xDoTools-xclip/index.bg.md"
+++
В този урок показвам как да управлявате Linux - десктоп чрез Bash. Следните пакети са необходими за робота Bash:
{{< terminal >}}
apt-get install xdotool xclip

{{</ terminal >}}
След това можете да използвате всички команди на xdotool, например:
```
#!/bin/bash

#mouse bewegen
xdotool mousemove 100 200 

#Mouse - Koordinaten erfassen
xdotool getmouselocation 

#Mouse-klick
xdotool click 1 

Mouse-Klick auf Koordinaten
xdotool mousemove 100 200 click 1 

#usw...

```
В следващия пример се търси в прозореца на Firefox и се отваря нов раздел с адреса на Ubuntu:
```
WID=$(xdotool search firefox | head -n1)     ## Window-ID von Firefox ermitteln
xdotool windowactivate $WID
xdotool key "ctrl+t"                         ## neuen Reiter öffnen
xdotool key "ctrl+l"                         ## Fokussieren der Adressleiste
xdotool type --delay 100 "ubuntuusers.de"    ## Internetadresse eintippen
xdotool key "Return"                         ## Internetadresse aufrufen 

```

## Защо се нуждаете от xclip???
С xdotools/"ctrl c" можете да копирате съдържанието в кеша и да го прочетете или обработите с xclip в bash скрипта.
