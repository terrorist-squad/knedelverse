+++
date = "2021-04-04"
title = "História curta: Controle da área de trabalho com xDoTools e xClip"
difficulty = "level-3"
tags = ["bash", "linux", "robot", "roboter", "linux", "Robotic-Process-Automation", "rpa", "xclip", "xdotool"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-xDoTools-xclip/index.pt.md"
+++
Neste tutorial eu mostro como controlar um Linux - desktop via Bash. Os seguintes pacotes são necessários para o robô Bash:
{{< terminal >}}
apt-get install xdotool xclip

{{</ terminal >}}
Depois disso, você pode usar todos os comandos do xdotool, por exemplo:
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
No exemplo seguinte, a janela Firefox é pesquisada e uma nova aba é aberta com o endereço Ubuntu:
```
WID=$(xdotool search firefox | head -n1)     ## Window-ID von Firefox ermitteln
xdotool windowactivate $WID
xdotool key "ctrl+t"                         ## neuen Reiter öffnen
xdotool key "ctrl+l"                         ## Fokussieren der Adressleiste
xdotool type --delay 100 "ubuntuusers.de"    ## Internetadresse eintippen
xdotool key "Return"                         ## Internetadresse aufrufen 

```

## Porque precisas do xclip??
