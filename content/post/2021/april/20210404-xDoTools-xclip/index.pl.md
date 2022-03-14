+++
date = "2021-04-04"
title = "Krótka historia: Kontrola pulpitu za pomocą xDoTools i xClip"
difficulty = "level-3"
tags = ["bash", "linux", "robot", "roboter", "linux", "Robotic-Process-Automation", "rpa", "xclip", "xdotool"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210404-xDoTools-xclip/index.pl.md"
+++
W tym tutorialu pokażę jak kontrolować pulpit Linuksa poprzez Bash. Następujące pakiety są potrzebne dla robota Bash:
{{< terminal >}}
apt-get install xdotool xclip

{{</ terminal >}}
Po tym możesz używać wszystkich poleceń xdotool, na przykład:
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
W poniższym przykładzie okno Firefoksa jest przeszukiwane i otwierana jest nowa karta z adresem Ubuntu:
```
WID=$(xdotool search firefox | head -n1)     ## Window-ID von Firefox ermitteln
xdotool windowactivate $WID
xdotool key "ctrl+t"                         ## neuen Reiter öffnen
xdotool key "ctrl+l"                         ## Fokussieren der Adressleiste
xdotool type --delay 100 "ubuntuusers.de"    ## Internetadresse eintippen
xdotool key "Return"                         ## Internetadresse aufrufen 

```

## Dlaczego potrzebujesz xclip???
