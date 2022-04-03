+++
date = "2021-04-04"
title = "小故事：用xDoTools和xClip进行桌面控制"
difficulty = "level-3"
tags = ["bash", "linux", "robot", "roboter", "linux", "Robotic-Process-Automation", "rpa", "xclip", "xdotool"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210404-xDoTools-xclip/index.zh.md"
+++
在本教程中，我展示了如何通过Bash控制Linux--桌面。Bash机器人需要以下软件包。
{{< terminal >}}
apt-get install xdotool xclip

{{</ terminal >}}
之后，你可以使用所有的xdotool命令，比如说。
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
在下面的例子中，Firefox窗口被搜索到，一个新的标签被打开，上面是Ubuntu的地址。
```
WID=$(xdotool search firefox | head -n1)     ## Window-ID von Firefox ermitteln
xdotool windowactivate $WID
xdotool key "ctrl+t"                         ## neuen Reiter öffnen
xdotool key "ctrl+l"                         ## Fokussieren der Adressleiste
xdotool type --delay 100 "ubuntuusers.de"    ## Internetadresse eintippen
xdotool key "Return"                         ## Internetadresse aufrufen 

```

## 你为什么需要xclip？
用xdotools/"ctrl c "可以将内容复制到缓存中，并在bash脚本中用xclip读取或处理它们。
