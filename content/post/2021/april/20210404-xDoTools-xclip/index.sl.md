+++
date = "2021-04-04"
title = "Kratka zgodba: Nadzor namizja z orodji xDoTools in xClip"
difficulty = "level-3"
tags = ["bash", "linux", "robot", "roboter", "linux", "Robotic-Process-Automation", "rpa", "xclip", "xdotool"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-xDoTools-xclip/index.sl.md"
+++
V tem priročniku prikazujem, kako upravljati Linux - namizje prek programa Bash. Za robota Bash so potrebni naslednji paketi:
{{< terminal >}}
apt-get install xdotool xclip

{{</ terminal >}}
Nato lahko uporabljate vse ukaze orodja xdotool, na primer:
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
V naslednjem primeru se poišče okno Firefoxa in odpre nov zavihek z naslovom Ubuntu:
```
WID=$(xdotool search firefox | head -n1)     ## Window-ID von Firefox ermitteln
xdotool windowactivate $WID
xdotool key "ctrl+t"                         ## neuen Reiter öffnen
xdotool key "ctrl+l"                         ## Fokussieren der Adressleiste
xdotool type --delay 100 "ubuntuusers.de"    ## Internetadresse eintippen
xdotool key "Return"                         ## Internetadresse aufrufen 

```

## Zakaj potrebujete xclip????
Z orodjem xdotools/"ctrl c" lahko kopirate vsebino v predpomnilnik in jo preberete ali obdelate s programom xclip v skripti bash.
