+++
date = "2021-04-04"
title = "Kort fortalt: Skrivebordskontrol med xDoTools og xClip"
difficulty = "level-3"
tags = ["bash", "linux", "robot", "roboter", "linux", "Robotic-Process-Automation", "rpa", "xclip", "xdotool"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-xDoTools-xclip/index.da.md"
+++
I denne vejledning viser jeg, hvordan man styrer et Linux-skrivebord via Bash. Følgende pakker er nødvendige for Bash-robotten:
{{< terminal >}}
apt-get install xdotool xclip

{{</ terminal >}}
Herefter kan du bruge alle xdotool-kommandoer, f.eks:
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
I det følgende eksempel søges der i Firefox-vinduet, og der åbnes en ny fane med Ubuntu-adressen:
```
WID=$(xdotool search firefox | head -n1)     ## Window-ID von Firefox ermitteln
xdotool windowactivate $WID
xdotool key "ctrl+t"                         ## neuen Reiter öffnen
xdotool key "ctrl+l"                         ## Fokussieren der Adressleiste
xdotool type --delay 100 "ubuntuusers.de"    ## Internetadresse eintippen
xdotool key "Return"                         ## Internetadresse aufrufen 

```

## Hvorfor har du brug for xclip????
