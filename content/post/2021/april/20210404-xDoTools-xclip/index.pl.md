+++
date = "2021-04-04"
title = "Krótka historia: Sterowanie pulpitem za pomocą xDoTools i xClip"
difficulty = "level-3"
tags = ["bash", "linux", "robot", "roboter", "linux", "Robotic-Process-Automation", "rpa", "xclip", "xdotool"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-xDoTools-xclip/index.pl.md"
+++
W tym poradniku pokazuję, jak kontrolować pulpit systemu Linux za pomocą Basha. Do działania robota Bash potrzebne są następujące pakiety:
{{< terminal >}}
apt-get install xdotool xclip

{{</ terminal >}}
Następnie można używać wszystkich poleceń xdotool, np:
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
W poniższym przykładzie okno przeglądarki Firefox jest przeszukiwane i otwierana jest nowa karta z adresem Ubuntu:
```
WID=$(xdotool search firefox | head -n1)     ## Window-ID von Firefox ermitteln
xdotool windowactivate $WID
xdotool key "ctrl+t"                         ## neuen Reiter öffnen
xdotool key "ctrl+l"                         ## Fokussieren der Adressleiste
xdotool type --delay 100 "ubuntuusers.de"    ## Internetadresse eintippen
xdotool key "Return"                         ## Internetadresse aufrufen 

```

## Po co Ci xclip???
Za pomocą narzędzia xdotools/"ctrl c" można kopiować zawartość do pamięci podręcznej i odczytywać lub przetwarzać ją za pomocą xclip w skrypcie basha.
