+++
date = "2021-04-04"
title = "Brève histoire : Contrôle du bureau avec xDoTools et xClip"
difficulty = "level-3"
tags = ["bash", "linux", "robot", "roboter", "linux", "Robotic-Process-Automation", "rpa", "xclip", "xdotool"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210404-xDoTools-xclip/index.fr.md"
+++
Dans ce tutoriel, je montre comment on peut contrôler un bureau Linux via Bash. Les paquets suivants sont nécessaires pour le robot Bash :
{{< terminal >}}
apt-get install xdotool xclip

{{</ terminal >}}
Ensuite, on peut utiliser toutes les commandes xdotool, par exemple
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
Dans l'exemple suivant, la fenêtre de Firefox est recherchée et un nouvel onglet s'ouvre avec l'adresse Ubuntu :
```
WID=$(xdotool search firefox | head -n1)     ## Window-ID von Firefox ermitteln
xdotool windowactivate $WID
xdotool key "ctrl+t"                         ## neuen Reiter öffnen
xdotool key "ctrl+l"                         ## Fokussieren der Adressleiste
xdotool type --delay 100 "ubuntuusers.de"    ## Internetadresse eintippen
xdotool key "Return"                         ## Internetadresse aufrufen 

```

## A quoi sert xclip ??
