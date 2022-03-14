+++
date = "2021-04-04"
title = "Historia corta: Control de escritorio con xDoTools y xClip"
difficulty = "level-3"
tags = ["bash", "linux", "robot", "roboter", "linux", "Robotic-Process-Automation", "rpa", "xclip", "xdotool"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-xDoTools-xclip/index.es.md"
+++
En este tutorial muestro cómo controlar un escritorio Linux a través de Bash. Los siguientes paquetes son necesarios para el robot Bash:
{{< terminal >}}
apt-get install xdotool xclip

{{</ terminal >}}
Después de eso, puede utilizar todos los comandos de xdotool, por ejemplo:
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
En el siguiente ejemplo, se busca en la ventana de Firefox y se abre una nueva pestaña con la dirección de Ubuntu:
```
WID=$(xdotool search firefox | head -n1)     ## Window-ID von Firefox ermitteln
xdotool windowactivate $WID
xdotool key "ctrl+t"                         ## neuen Reiter öffnen
xdotool key "ctrl+l"                         ## Fokussieren der Adressleiste
xdotool type --delay 100 "ubuntuusers.de"    ## Internetadresse eintippen
xdotool key "Return"                         ## Internetadresse aufrufen 

```

## ¿Por qué necesitas xclip?
