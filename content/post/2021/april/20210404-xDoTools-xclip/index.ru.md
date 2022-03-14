+++
date = "2021-04-04"
title = "Краткая история: Управление рабочим столом с помощью xDoTools и xClip"
difficulty = "level-3"
tags = ["bash", "linux", "robot", "roboter", "linux", "Robotic-Process-Automation", "rpa", "xclip", "xdotool"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210404-xDoTools-xclip/index.ru.md"
+++
В этом уроке я покажу, как управлять Linux - рабочим столом с помощью Bash. Для работы робота Bash необходимы следующие пакеты:
{{< terminal >}}
apt-get install xdotool xclip

{{</ terminal >}}
После этого вы можете использовать все команды xdotool, например:
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
В следующем примере выполняется поиск в окне Firefox и открывается новая вкладка с адресом Ubuntu:
```
WID=$(xdotool search firefox | head -n1)     ## Window-ID von Firefox ermitteln
xdotool windowactivate $WID
xdotool key "ctrl+t"                         ## neuen Reiter öffnen
xdotool key "ctrl+l"                         ## Fokussieren der Adressleiste
xdotool type --delay 100 "ubuntuusers.de"    ## Internetadresse eintippen
xdotool key "Return"                         ## Internetadresse aufrufen 

```

## Зачем вам нужен xclip?????
