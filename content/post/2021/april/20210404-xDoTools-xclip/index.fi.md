+++
date = "2021-04-04"
title = "Lyhyt tarina: Työpöydän hallinta xDoToolsilla ja xClipillä"
difficulty = "level-3"
tags = ["bash", "linux", "robot", "roboter", "linux", "Robotic-Process-Automation", "rpa", "xclip", "xdotool"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-xDoTools-xclip/index.fi.md"
+++
Tässä opetusohjelmassa näytän, miten hallita Linux - työpöytää Bashin avulla. Bash-robotti tarvitsee seuraavat paketit:
{{< terminal >}}
apt-get install xdotool xclip

{{</ terminal >}}
Sen jälkeen voit käyttää kaikkia xdotoolin komentoja, esimerkiksi:
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
Seuraavassa esimerkissä Firefox-ikkunasta tehdään haku ja avataan uusi välilehti, jossa on Ubuntun osoite:
```
WID=$(xdotool search firefox | head -n1)     ## Window-ID von Firefox ermitteln
xdotool windowactivate $WID
xdotool key "ctrl+t"                         ## neuen Reiter öffnen
xdotool key "ctrl+l"                         ## Fokussieren der Adressleiste
xdotool type --delay 100 "ubuntuusers.de"    ## Internetadresse eintippen
xdotool key "Return"                         ## Internetadresse aufrufen 

```

## Miksi tarvitset xclip????
