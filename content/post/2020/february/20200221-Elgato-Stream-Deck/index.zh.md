+++
date = "2020-02-07"
title = "小故事：用Elgato Stream Deck编写Bash脚本"
difficulty = "level-2"
tags = ["bash", "elgato", "skript", "stream-deck"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200221-Elgato%20Stream-Deck/index.zh.md"
+++
如果你想在Elgato Stream Deck中包含一个bash脚本，你首先需要一个bash脚本。
## 第1步：创建Bash脚本。
我创建了一个名为 "say-hallo.sh "的文件，内容如下。
```
#!/bin/bash
say "hallo"

```

## 第2步：设定权利
下面的命令使该文件可以执行。
{{< terminal >}}
chmod 755 say-hallo.sh

{{</ terminal >}}

## 第3步：将Bash脚本包含在甲板中
3.1) 现在可以打开Stream Deck应用程序了。
{{< gallery match="images/1/*.png" >}}
3.2) 然后我把 "打开系统 "的动作拖到一个按钮上。
{{< gallery match="images/2/*.png" >}}
3.3) 现在我可以选择我的bash脚本。
{{< gallery match="images/3/*.png" >}}

## 第四步：完成!
