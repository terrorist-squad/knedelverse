+++
date = "2021-04-04"
title = "Krátky príbeh: Ovládanie pracovnej plochy pomocou nástrojov xDoTools a xClip"
difficulty = "level-3"
tags = ["bash", "linux", "robot", "roboter", "linux", "Robotic-Process-Automation", "rpa", "xclip", "xdotool"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-xDoTools-xclip/index.sk.md"
+++
V tomto návode ukážem, ako ovládať Linux - pracovnú plochu pomocou Bash. Pre robota Bash sú potrebné nasledujúce balíky:
{{< terminal >}}
apt-get install xdotool xclip

{{</ terminal >}}
Potom môžete používať všetky príkazy xdotool, napríklad:
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
V nasledujúcom príklade sa vyhľadá okno prehliadača Firefox a otvorí sa nová karta s adresou Ubuntu:
```
WID=$(xdotool search firefox | head -n1)     ## Window-ID von Firefox ermitteln
xdotool windowactivate $WID
xdotool key "ctrl+t"                         ## neuen Reiter öffnen
xdotool key "ctrl+l"                         ## Fokussieren der Adressleiste
xdotool type --delay 100 "ubuntuusers.de"    ## Internetadresse eintippen
xdotool key "Return"                         ## Internetadresse aufrufen 

```

## Prečo potrebujete xclip???
