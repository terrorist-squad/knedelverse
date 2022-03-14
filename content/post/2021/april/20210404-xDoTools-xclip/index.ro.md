+++
date = "2021-04-04"
title = "Scurtă poveste: Controlul desktopului cu xDoTools și xClip"
difficulty = "level-3"
tags = ["bash", "linux", "robot", "roboter", "linux", "Robotic-Process-Automation", "rpa", "xclip", "xdotool"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-xDoTools-xclip/index.ro.md"
+++
În acest tutorial vă arăt cum să controlați un desktop Linux prin Bash. Următoarele pachete sunt necesare pentru robotul Bash:
{{< terminal >}}
apt-get install xdotool xclip

{{</ terminal >}}
După aceea, puteți utiliza toate comenzile xdotool, de exemplu:
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
În exemplul următor, fereastra Firefox este căutată și se deschide o nouă filă cu adresa Ubuntu:
```
WID=$(xdotool search firefox | head -n1)     ## Window-ID von Firefox ermitteln
xdotool windowactivate $WID
xdotool key "ctrl+t"                         ## neuen Reiter öffnen
xdotool key "ctrl+l"                         ## Fokussieren der Adressleiste
xdotool type --delay 100 "ubuntuusers.de"    ## Internetadresse eintippen
xdotool key "Return"                         ## Internetadresse aufrufen 

```

## De ce ai nevoie de xclip?????
