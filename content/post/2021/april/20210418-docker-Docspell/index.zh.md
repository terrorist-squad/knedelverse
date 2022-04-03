+++
date = "2021-04-18"
title = "容器的伟大之处：在Synology DiskStation上运行Docspell DMS"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "Document-Managment-System"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-Docspell/index.zh.md"
+++
Docspell 是一个适用于 Synology DiskStation 的文件管理系统。通过Docspell，文件可以更快地被索引、搜索和找到。今天我将展示如何在Synology磁盘站上安装Docspell服务。
## 第1步：准备好Synology
首先，必须在 DiskStation 上激活 SSH 登录。要做到这一点，请进入 "控制面板">"终端"。
{{< gallery match="images/1/*.png" >}}
然后你可以通过 "SSH"、指定的端口和管理员密码来登录（Windows用户使用Putty或WinSCP）。
{{< gallery match="images/2/*.png" >}}
我通过终端、winSCP或Putty登录，并将这个控制台打开以备不时之需。
## 第2步：创建Docspel文件夹
我在Docker目录下创建一个名为 "docspell "的新目录。
{{< gallery match="images/3/*.png" >}}
现在必须下载以下文件并在目录中解压：https://github.com/eikek/docspell/archive/refs/heads/master.zip 。我使用控制台来做这个。
{{< terminal >}}
cd /volume1/docker/docspell/
mkdir docs
mkdir postgres_data
wget https://github.com/eikek/docspell/archive/refs/heads/master.zip 
/bin/7z x master.zip

{{</ terminal >}}
然后我编辑 "docker/docker-compose.yml "文件，在 "consedir "和 "db "中输入我的Synology地址。
{{< gallery match="images/4/*.png" >}}
之后，我就可以启动编撰文件了。
{{< terminal >}}
cd docspell-master/docker/
docker-compose up -d

{{</ terminal >}}
几分钟后，我可以用磁盘站的IP和分配的端口/7878呼叫我的Docspell服务器。
{{< gallery match="images/5/*.png" >}}
搜索文件的效果很好。我觉得很遗憾的是，图片中的文字没有被索引。有了Papermerge，你还可以搜索图片中的文本。
