+++
date = "2021-04-04"
title = "Kurzgeschichte: Desktop-Steuerung mit xDoTools und xClip"
difficulty = "level-3"
tags = ["bash", "linux", "robot", "roboter", "linux", "Robotic-Process-Automation", "rpa", "xclip", "xdotool"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-xDoTools-xclip/index.de.md"
+++

In diesem Tutorial zeige ich, wie man einen Linux – Desktop via Bash steuern kann. Folgende Pakete werden für den Bash-Roboter benötigt:
{{< terminal >}}
apt-get install xdotool xclip
{{</ terminal >}}

Danach kann man alle xdotool-Befehle nutzen, zum Beispiel:
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

Im folgenden Beispiel wird das Firefox-Fenster gesucht und ein neuer Tab mit der Ubuntu-Adresse geöffnet:
```
WID=$(xdotool search firefox | head -n1)     ## Window-ID von Firefox ermitteln
xdotool windowactivate $WID
xdotool key "ctrl+t"                         ## neuen Reiter öffnen
xdotool key "ctrl+l"                         ## Fokussieren der Adressleiste
xdotool type --delay 100 "ubuntuusers.de"    ## Internetadresse eintippen
xdotool key "Return"                         ## Internetadresse aufrufen 
```

## Wozu braucht man xclip???
Mit den xdotools/“ctrl+c“ kann man Inhalte in den Zwischenspeicher kopieren und mit xclip im Bash-Skript auslesen bzw. verarbeiten.