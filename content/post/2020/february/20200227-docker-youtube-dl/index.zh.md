+++
date = "2020-02-27"
title = "容器的伟大之处：在Synology Diskstation上运行Youtube下载器"
difficulty = "level-1"
tags = ["Docker", "docker-compose", "download", "linux", "Synology", "video", "youtube"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200227-docker-youtube-dl/index.zh.md"
+++
我的许多朋友都知道，我在我的Homelab - Network上运行一个私人学习视频门户。我把过去学习门户会员的视频课程和Youtube上的好教程保存在我的NAS上供离线使用。
{{< gallery match="images/1/*.png" >}}
随着时间的推移，我已经收集了8845个视频课程，其中有282616个独立视频。总的运行时间相当于2年左右。绝对疯狂！在本教程中，我展示了如何用Docker下载服务备份好的Youtube教程，以达到离线的目的。
## 专业人士的选择
作为一个有经验的Synology用户，你当然可以用SSH登录并通过Docker Compose文件安装整个设置。
```
version: "2"
services:
  youtube-dl:
    image: modenaf360/youtube-dl-nas
    container_name: youtube-dl
    environment:
      - MY_ID=admin
      - MY_PW=admin
    volumes:
      - ./YouTube:/downfolder
    ports:
      - 8080:8080
    restart: unless-stopped

```

## 步骤1
首先，我为下载创建一个文件夹。我进入 "系统控制"->"共享文件夹"，创建一个名为 "下载 "的新文件夹。
{{< gallery match="images/2/*.png" >}}

## 第2步：搜索Docker镜像
我在Synology Docker窗口中点击 "注册 "标签，并搜索 "youtube-dl-nas"。我选择Docker镜像 "modenaf360/youtube-dl-nas"，然后点击 "最新 "标签。
{{< gallery match="images/3/*.png" >}}
图像下载后，可作为图像使用。Docker区分了两种状态，容器 "动态状态 "和图像/影像（固定状态）。在我们从镜像中创建一个容器之前，必须进行一些设置。
## 第3步：将图像投入运行。
我双击我的YouTube-DL-NAS图像。
{{< gallery match="images/4/*.png" >}}
然后我点击 "高级设置"，激活 "自动重新启动"。我选择 "卷 "选项卡并点击 "添加文件夹"。我在那里创建了一个新的数据库文件夹，挂载路径为"/downfolder"。
{{< gallery match="images/5/*.png" >}}
我为 "Youtube下载器 "容器分配了固定的端口。如果没有固定的端口，可能是 "Youtube下载器 "在重启后运行在不同的端口。
{{< gallery match="images/6/*.png" >}}
最后，我输入两个环境变量。变量 "MY_ID "是我的用户名，"MY_PW "是我的密码。
{{< gallery match="images/7/*.png" >}}
做完这些设置后，就可以开始下载器了!之后，你可以通过Synology设备的Ip地址和指定的端口调用下载器，例如http://192.168.21.23:8070 。
{{< gallery match="images/8/*.png" >}}
对于认证，从MY_ID和MY_PW中获取用户名和密码。
## 第4步：我们走吧
现在，可以在 "URL "字段中输入Youtube视频的网址和播放列表的网址，所有的视频都会自动出现在Synology磁盘站的下载文件夹中。
{{< gallery match="images/9/*.png" >}}
下载文件夹。
{{< gallery match="images/10/*.png" >}}