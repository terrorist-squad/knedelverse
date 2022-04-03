+++
date = "2020-02-14"
title = "生成PDF页面概述"
difficulty = "level-3"
tags = ["bash", "linux", "pdf", "postscript", "imagemagick"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200214-imagemagick-pdf-overview/index.zh.md"
+++
如果你想从一个PDF文件中创建一个页面概述图像，那么你就来对地方了
{{< gallery match="images/1/*.jpg" >}}

## 第1步：创建工作文件夹
使用该命令创建一个临时工作文件夹。
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}

## 第2步：独立的页面
以下命令为每个PDF页面创建一个图像。
{{< terminal >}}
convert 716023b632a9cbe6cad3ab368c202288.pdf /tmp/bilder/page.png

{{</ terminal >}}

## 第3步：安装图像
现在只需要把拼贴画放在一起。
{{< terminal >}}
montage /tmp/bilder/* -shadow -geometry '400x400+2+2>' -background '#f1f1f1' uebersich.jpg

{{</ terminal >}}

