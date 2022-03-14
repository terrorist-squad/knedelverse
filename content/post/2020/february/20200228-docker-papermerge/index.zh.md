+++
date = "2020-02-28"
title = "容器的伟大之处：在Synology NAS上运行Papermerge DMS"
difficulty = "level-3"
tags = ["archiv", "automatisch", "dms", "Docker", "Document-Managment-System", "google", "ocr", "papermerge", "Synology", "tesseract", "texterkennung"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200228-docker-papermerge/index.zh.md"
+++
Papermerge是一个年轻的文件管理系统（DMS），可以自动分配和处理文件。在这个教程中，我展示了我是如何在Synology磁盘站上安装Papermerge以及DMS是如何工作的。
## 专业人士的选择
作为一个有经验的Synology用户，你当然可以用SSH登录并通过Docker Compose文件安装整个设置。
```
version: "2.1"
services:
  papermerge:
    image: ghcr.io/linuxserver/papermerge
    container_name: papermerge
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./config>:/config
      - ./appdata/data>:/data
    ports:
      - 8090:8000
    restart: unless-stopped

```

## 第1步：创建文件夹
首先，我为纸张合并创建一个文件夹。我进入 "系统控制"->"共享文件夹"，创建了一个名为 "文件档案 "的新文件夹。
{{< gallery match="images/1/*.png" >}}
第二步：搜索Docker镜像我点击Synology Docker窗口中的 "注册 "标签，搜索 "Papermerge"。我选择Docker镜像 "linuxserver/papermerge"，然后点击 "最新 "标签。
{{< gallery match="images/2/*.png" >}}
图像下载后，可作为图像使用。Docker区分了两种状态，容器 "动态状态 "和图像/影像（固定状态）。在我们从镜像中创建一个容器之前，必须进行一些设置。
## 第3步：将图像投入运行。
我双击我的纸张合并图像。
{{< gallery match="images/3/*.png" >}}
然后我点击 "高级设置"，激活 "自动重新启动"。我选择 "卷 "选项卡并点击 "添加文件夹"。我在那里创建了一个新的数据库文件夹，挂载路径为"/data"。
{{< gallery match="images/4/*.png" >}}
我还在这里存储了第二个文件夹，我把它包括在挂载路径"/config "中。这个文件夹在哪里其实并不重要。然而，重要的是，它属于Synology管理员用户。
{{< gallery match="images/5/*.png" >}}
我为 "Papermerge "容器分配了固定端口。没有固定的端口，可能是 "Papermerge服务器 "在重启后运行在不同的端口。
{{< gallery match="images/6/*.png" >}}
最后，我输入三个环境变量。变量 "PUID "是用户ID，"PGID "是我的管理用户的组ID。你可以通过SSH用 "cat /etc/passwd | grep admin "命令找出PGID/PUID。
{{< gallery match="images/7/*.png" >}}
经过这些设置后，Papermerge服务器就可以启动了!之后，可以通过Synology设备的Ip地址和分配的端口（例如http://192.168.21.23:8095）来调用Papermerge。
{{< gallery match="images/8/*.png" >}}
默认的登录方式是admin，密码是admin。
## Papermerge是如何工作的？
Papermerge分析了文件和图像的文本。Papermerge使用了一个OCR/"光学字符识别 "库，名为tesseract，由Goolge发布。
{{< gallery match="images/9/*.png" >}}
我创建了一个名为 "Everything with Lorem "的文件夹来测试自动分配文件。然后我在菜单项 "自动 "中点击了一个新的识别模式。
{{< gallery match="images/10/*.png" >}}
所有包含 "Lorem "一词的新文件都被放置在 "Everything with Lorem "文件夹中，并标记为 "has-lorem"。在标签中使用逗号很重要，否则标签将不会被设置。如果你上传相应的文件，它将被标记和分类。
{{< gallery match="images/11/*.png" >}}