+++
date = "2021-04-04"
title = "Kort verhaal: Desktopbesturing met xDoTools en xClip"
difficulty = "level-3"
tags = ["bash", "linux", "robot", "roboter", "linux", "Robotic-Process-Automation", "rpa", "xclip", "xdotool"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210404-xDoTools-xclip/index.nl.md"
+++
In deze tutorial laat ik zien hoe je een Linux - desktop kunt bedienen via Bash. De volgende pakketten zijn nodig voor de Bash robot:
{{< terminal >}}
apt-get install xdotool xclip

{{</ terminal >}}
Daarna kunt u alle xdotool commando's gebruiken, bijvoorbeeld:
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
In het volgende voorbeeld wordt het Firefox venster doorzocht en wordt een nieuw tabblad geopend met het Ubuntu adres:
```
WID=$(xdotool search firefox | head -n1)     ## Window-ID von Firefox ermitteln
xdotool windowactivate $WID
xdotool key "ctrl+t"                         ## neuen Reiter öffnen
xdotool key "ctrl+l"                         ## Fokussieren der Adressleiste
xdotool type --delay 100 "ubuntuusers.de"    ## Internetadresse eintippen
xdotool key "Return"                         ## Internetadresse aufrufen 

```

## Waarom heb je een xclip nodig?
