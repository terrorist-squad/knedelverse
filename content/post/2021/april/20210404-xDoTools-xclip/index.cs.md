+++
date = "2021-04-04"
title = "Krátký příběh: Ovládání pracovní plochy pomocí nástrojů xDoTools a xClip"
difficulty = "level-3"
tags = ["bash", "linux", "robot", "roboter", "linux", "Robotic-Process-Automation", "rpa", "xclip", "xdotool"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210404-xDoTools-xclip/index.cs.md"
+++
V tomto návodu ukážu, jak ovládat Linux - desktop pomocí Bash. Pro robota Bash jsou potřeba následující balíčky:
{{< terminal >}}
apt-get install xdotool xclip

{{</ terminal >}}
Poté můžete používat všechny příkazy nástroje xdotool, například:
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
V následujícím příkladu je prohledáno okno Firefoxu a je otevřena nová karta s adresou Ubuntu:
```
WID=$(xdotool search firefox | head -n1)     ## Window-ID von Firefox ermitteln
xdotool windowactivate $WID
xdotool key "ctrl+t"                         ## neuen Reiter öffnen
xdotool key "ctrl+l"                         ## Fokussieren der Adressleiste
xdotool type --delay 100 "ubuntuusers.de"    ## Internetadresse eintippen
xdotool key "Return"                         ## Internetadresse aufrufen 

```

## Proč potřebujete xclip???
