+++
date = "2022-03-21"
title = "容器的伟大之处：从广播中录制MP3"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "radio", "mp3", "ripp", "streamripper", "radiorecorder"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220321-docker-mighty-mixxx-tapper/index.zh.md"
+++
Streamripper是一个命令行工具，可以用来录制MP3或OGG/Vorbis流，并直接保存到硬盘上。歌曲会自动以艺术家的名字命名并单独保存，格式是最初发送的格式（所以实际上是创建了扩展名为.mp3或.ogg的文件）。我发现了一个很好的无线电记录器接口，并从中建立了一个Docker镜像，见：https://github.com/terrorist-squad/mightyMixxxTapper/
{{< gallery match="images/1/*.png" >}}

## 专业人士的选择
作为一个有经验的Synology用户，你当然可以用SSH登录并通过Docker Compose文件安装整个设置。
```
version: "2.0"
services:
  mealie:
    container_name: mighty-mixxx-tapper
    image: chrisknedel/mighty-mixxx-tapper:latest
    restart: always
    ports:
      - 9000:80
    environment:
      TZ: Europa/Berlin
    volumes:
      - ./ripps/:/tmp/ripps/

```

## 第1步：搜索Docker镜像
我在Synology Docker窗口中点击 "注册 "标签，并搜索 "mighty-mixxx-tapper"。我选择Docker镜像 "chrisknedel/mighty-mixxx-tapper"，然后点击 "最新 "标签。
{{< gallery match="images/2/*.png" >}}
图像下载后，可作为图像使用。Docker区分了两种状态，容器 "动态状态 "和图像/影像（固定状态）。在我们从镜像中创建一个容器之前，必须进行一些设置。
## 第2步：将图像投入运行。
我双击我的 "mighty-mixxx-tapper "图像。
{{< gallery match="images/3/*.png" >}}
然后我点击 "高级设置"，激活 "自动重新启动"。我选择 "卷 "选项卡并点击 "添加文件夹"。我在那里创建了一个新的文件夹，挂载路径为"/tmp/ripps/"。
{{< gallery match="images/4/*.png" >}}
我为 "mighty-mixxx-tapper "容器分配了固定端口。没有固定的端口，可能是 "mighty-mixxx-tapper-server "在重启后运行在不同的端口。
{{< gallery match="images/5/*.png" >}}
经过这些设置，mighty-mixxx-tapper-server就可以启动了!之后，你可以通过Synology设备的Ip地址和分配的端口（例如http://192.168.21.23:8097）呼叫mighty-mixxx-tapper。
{{< gallery match="images/6/*.png" >}}
