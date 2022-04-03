+++
date = "2021-04-04"
title = "ショートストーリー：xDoToolsとxClipによるデスクトップコントロール"
difficulty = "level-3"
tags = ["bash", "linux", "robot", "roboter", "linux", "Robotic-Process-Automation", "rpa", "xclip", "xdotool"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-xDoTools-xclip/index.ja.md"
+++
このチュートリアルでは、Bashを使用してLinux - デスクトップを制御する方法を紹介します。Bashロボットに必要なパッケージは以下の通りです。
{{< terminal >}}
apt-get install xdotool xclip

{{</ terminal >}}
その後、例えば、すべての xdotool コマンドを使用することができます。
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
次の例では、Firefoxのウィンドウを検索して、Ubuntuのアドレスで新しいタブを開いています。
```
WID=$(xdotool search firefox | head -n1)     ## Window-ID von Firefox ermitteln
xdotool windowactivate $WID
xdotool key "ctrl+t"                         ## neuen Reiter öffnen
xdotool key "ctrl+l"                         ## Fokussieren der Adressleiste
xdotool type --delay 100 "ubuntuusers.de"    ## Internetadresse eintippen
xdotool key "Return"                         ## Internetadresse aufrufen 

```

## なぜxclipが必要なのか？
xdotools/"ctrl c "でキャッシュに内容をコピーし、bashスクリプトのxclipで読み込んだり処理したりすることができます。
