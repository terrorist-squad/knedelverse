+++
date = "2021-04-04"
title = "Breve storia: controllo del desktop con xDoTools e xClip"
difficulty = "level-3"
tags = ["bash", "linux", "robot", "roboter", "linux", "Robotic-Process-Automation", "rpa", "xclip", "xdotool"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-xDoTools-xclip/index.it.md"
+++
In questo tutorial mostro come controllare un desktop Linux tramite Bash. I seguenti pacchetti sono necessari per il robot Bash:
{{< terminal >}}
apt-get install xdotool xclip

{{</ terminal >}}
Dopo di che potete usare tutti i comandi di xdotool, per esempio:
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
Nell'esempio seguente, la finestra di Firefox viene cercata e viene aperta una nuova scheda con l'indirizzo di Ubuntu:
```
WID=$(xdotool search firefox | head -n1)     ## Window-ID von Firefox ermitteln
xdotool windowactivate $WID
xdotool key "ctrl+t"                         ## neuen Reiter öffnen
xdotool key "ctrl+l"                         ## Fokussieren der Adressleiste
xdotool type --delay 100 "ubuntuusers.de"    ## Internetadresse eintippen
xdotool key "Return"                         ## Internetadresse aufrufen 

```

## Perché hai bisogno di xclip?
