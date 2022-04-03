+++
date = "2021-04-04"
title = "Rövid történet: Asztali vezérlés xDoTools és xClip segítségével"
difficulty = "level-3"
tags = ["bash", "linux", "robot", "roboter", "linux", "Robotic-Process-Automation", "rpa", "xclip", "xdotool"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-xDoTools-xclip/index.hu.md"
+++
Ebben a bemutatóban megmutatom, hogyan lehet egy Linux - asztalt a Bash segítségével vezérelni. A következő csomagok szükségesek a Bash robothoz:
{{< terminal >}}
apt-get install xdotool xclip

{{</ terminal >}}
Ezután használhatja az összes xdotool parancsot, például:
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
A következő példában a Firefox ablakban keresés történik, és egy új lap nyílik az Ubuntu címével:
```
WID=$(xdotool search firefox | head -n1)     ## Window-ID von Firefox ermitteln
xdotool windowactivate $WID
xdotool key "ctrl+t"                         ## neuen Reiter öffnen
xdotool key "ctrl+l"                         ## Fokussieren der Adressleiste
xdotool type --delay 100 "ubuntuusers.de"    ## Internetadresse eintippen
xdotool key "Return"                         ## Internetadresse aufrufen 

```

## Miért van szüksége xclip????
Az xdotools/"ctrl c" segítségével a tartalmakat a gyorsítótárba másolhatod, és a bash szkriptben lévő xclip segítségével olvashatod vagy feldolgozhatod őket.
