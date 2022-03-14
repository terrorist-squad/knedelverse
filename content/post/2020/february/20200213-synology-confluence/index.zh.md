+++
date = "2020-02-13"
title = "Synology-Nas: Confluence是一个维基系统"
difficulty = "level-4"
tags = ["atlassian", "confluence", "Docker", "ds918", "Synology", "wiki", "nas"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200213-synology-confluence/index.zh.md"
+++
如果你想在Synology NAS上安装Atlassian Confluence，那么你就来对地方了。
## 步骤1
首先，我在Synology界面上打开Docker应用，然后进入 "注册 "子项。我在那里搜索 "Confluence "并点击第一张图片 "Atlassian Confluence"。
{{< gallery match="images/1/*.png" >}}

## 第2步
图像下载后，可作为图像使用。Docker区分了两种状态，容器 "动态状态 "和图像/影像（固定状态）。在我们从镜像中创建一个容器之前，必须进行一些设置。
## 自动重新启动
我双击我的Confluence图像。
{{< gallery match="images/2/*.png" >}}
然后我点击 "高级设置"，激活 "自动重新启动"。
{{< gallery match="images/3/*.png" >}}

## 码头
我为Confluence容器分配了固定的端口。如果没有固定的端口，Confluence可能在重启后运行在不同的端口上。
{{< gallery match="images/4/*.png" >}}

## 记忆
我创建了一个物理文件夹，并把它挂在容器里（/var/atlassian/application-data/confluence/）。这一设置使备份和恢复数据更加容易。
{{< gallery match="images/5/*.png" >}}
完成这些设置后，Confluence就可以启动了!
{{< gallery match="images/6/*.png" >}}