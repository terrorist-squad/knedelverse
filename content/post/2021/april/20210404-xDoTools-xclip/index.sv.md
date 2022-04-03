+++
date = "2021-04-04"
title = "Kort berättelse: Skrivbordskontroll med xDoTools och xClip"
difficulty = "level-3"
tags = ["bash", "linux", "robot", "roboter", "linux", "Robotic-Process-Automation", "rpa", "xclip", "xdotool"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-xDoTools-xclip/index.sv.md"
+++
I den här handledningen visar jag hur man kontrollerar ett Linux - skrivbord via Bash. Följande paket behövs för Bash-robotten:
{{< terminal >}}
apt-get install xdotool xclip

{{</ terminal >}}
Därefter kan du använda alla xdotool-kommandon, till exempel:
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
I följande exempel söks Firefox-fönstret och en ny flik öppnas med Ubuntu-adressen:
```
WID=$(xdotool search firefox | head -n1)     ## Window-ID von Firefox ermitteln
xdotool windowactivate $WID
xdotool key "ctrl+t"                         ## neuen Reiter öffnen
xdotool key "ctrl+l"                         ## Fokussieren der Adressleiste
xdotool type --delay 100 "ubuntuusers.de"    ## Internetadresse eintippen
xdotool key "Return"                         ## Internetadresse aufrufen 

```

## Varför behöver du xclip????
Med xdotools/"ctrl c" kan du kopiera innehåll till cacheminnet och läsa eller bearbeta det med xclip i bash-skriptet.
