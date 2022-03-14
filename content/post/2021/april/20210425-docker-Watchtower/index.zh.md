+++
date = "2021-04-25T09:28:11+01:00"
title = "短文：用守望先锋自动更新容器"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Watchtower/index.zh.md"
+++
如果你在磁盘站上运行Docker容器，你自然希望它们始终是最新的。Watchtower自动更新图像和容器。这样，你就可以享受到最新的功能和最先进的数据安全。今天我将告诉你如何在Synology磁盘站上安装Watchtower。
## 第1步：准备好Synology
首先，必须在 DiskStation 上激活 SSH 登录。要做到这一点，请进入 "控制面板">"终端"。
{{< gallery match="images/1/*.png" >}}
然后你可以通过 "SSH"、指定的端口和管理员密码来登录（Windows用户使用Putty或WinSCP）。
{{< gallery match="images/2/*.png" >}}
我通过终端、winSCP或Putty登录，并将这个控制台打开以备不时之需。
## 第2步：安装Watchtower
我使用控制台来做这个。
{{< terminal >}}
docker run --name watchtower --restart always -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower

{{</ terminal >}}
此后，守望先锋总是在后台运行。
{{< gallery match="images/3/*.png" >}}
