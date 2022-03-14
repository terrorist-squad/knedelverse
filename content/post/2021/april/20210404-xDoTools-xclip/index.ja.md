+++
date = "2021-04-04"
title = "ショートストーリー：xDoToolsとxClipによるデスクトップコントロール"
difficulty = "level-3"
tags = ["bash", "linux", "robot", "roboter", "linux", "Robotic-Process-Automation", "rpa", "xclip", "xdotool"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-xDoTools-xclip/index.ja.md"
+++
このチュートリアルでは、Bashを使ってLinuxのデスクトップを操作する方法を紹介します。Bashロボットには以下のパッケージが必要です。
{{< terminal >}}
apt-get install xdotool xclip

{{</ terminal >}}
その後は、例えばxdotoolの全てのコマンドが使えるようになります。
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
以下の例では、Firefoxのウィンドウが検索され、Ubuntuのアドレスが表示された新しいタブが開かれます。
```
WID=$(xdotool search firefox | head -n1)     ## Window-ID von Firefox ermitteln
xdotool windowactivate $WID
xdotool key "ctrl+t"                         ## neuen Reiter öffnen
xdotool key "ctrl+l"                         ## Fokussieren der Adressleiste
xdotool type --delay 100 "ubuntuusers.de"    ## Internetadresse eintippen
xdotool key "Return"                         ## Internetadresse aufrufen 

```

## なぜxclipが必要なのでしょうか？
