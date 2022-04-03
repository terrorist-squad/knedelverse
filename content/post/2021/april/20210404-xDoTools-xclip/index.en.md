+++
date = "2021-04-04"
title = "Short story: Desktop control with xDoTools and xClip"
difficulty = "level-3"
tags = ["bash", "linux", "robot", "roboter", "linux", "Robotic-Process-Automation", "rpa", "xclip", "xdotool"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-xDoTools-xclip/index.en.md"
+++
In this tutorial I show how to control a Linux - desktop via Bash. The following packages are needed for the bash robot:
{{< terminal >}}
apt-get install xdotool xclip

{{</ terminal >}}
After that you can use all xdotool commands, for example:
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
In the following example, the Firefox window is searched and a new tab is opened with the Ubuntu address:
```
WID=$(xdotool search firefox | head -n1)     ## Window-ID von Firefox ermitteln
xdotool windowactivate $WID
xdotool key "ctrl+t"                         ## neuen Reiter öffnen
xdotool key "ctrl+l"                         ## Fokussieren der Adressleiste
xdotool type --delay 100 "ubuntuusers.de"    ## Internetadresse eintippen
xdotool key "Return"                         ## Internetadresse aufrufen 

```

## Why do you need xclip??
With xdotools/"ctrl c" you can copy content into the cache and read or process it with xclip in the bash script.
