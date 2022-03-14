+++
date = "2020-02-21"
title = "容器的伟大之处：用Docker Compose运行Calibre (Synology pro设置)"
difficulty = "level-3"
tags = ["calibre", "calibre-web", "Docker", "docker-compose", "Synology", "linux"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200221-docker-Calibre-pro/index.zh.md"
+++
这个博客上已经有一个比较简单的教程：X0。本教程适用于所有Synology DS的专业人士。
## 第1步：准备好Synology
首先，必须在 DiskStation 上激活 SSH 登录。要做到这一点，请进入 "控制面板">"终端"。
{{< gallery match="images/1/*.png" >}}
然后你可以通过 "SSH"、指定的端口和管理员密码来登录（Windows用户使用Putty或WinSCP）。
{{< gallery match="images/2/*.png" >}}
我通过终端、winSCP或Putty登录，并将这个控制台打开以备不时之需。
## 第2步：创建一个图书文件夹
我为Calibre库创建一个新的文件夹。要做到这一点，我调用 "系统控制"->"共享文件夹"，并创建一个名为 "书籍 "的新文件夹。如果还没有 "Docker "文件夹，那么也必须创建它。
{{< gallery match="images/3/*.png" >}}

## 第3步：准备好书夹
现在必须下载并解压以下文件：https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view。内容（"metadata.db"）必须放在新书目录中，见。
{{< gallery match="images/4/*.png" >}}

## 第4步：准备好Docker文件夹
我在Docker目录下创建一个名为 "calibre "的新目录。
{{< gallery match="images/5/*.png" >}}
然后我换到新的目录，并创建一个名为 "calibre.yml "的新文件，内容如下。
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre:/briefkaste
    ports:
      - 8055:8083
    restart: unless-stopped

```
在这个新文件中，有几个地方必须调整如下：* PUID/PGID：DS用户的用户和组ID必须在PUID/PGID中输入。这里我使用 "步骤1 "中的控制台和 "id -u "命令来查看用户ID。用 "id -g "命令，我得到了组的ID。* ports: 对于端口，前面的部分 "8055: "必须被调整。directories这个文件中的所有目录必须被纠正。正确的地址可以在DS的属性窗口中看到。(屏幕截图如下)
{{< gallery match="images/6/*.png" >}}

## 第5步：测试开始
在这一步，我也可以很好地利用控制台。我换到Calibre目录，通过Docker Compose启动那里的Calibre服务器。
{{< terminal >}}
cd /volume1/docker/calibre
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}

{{< gallery match="images/7/*.png" >}}

## 第6步：设置
然后我就可以用磁盘站的IP和 "步骤4 "中分配的端口调用我的Calibre服务器。我在设置中使用我的"/books "挂载点。之后，服务器就已经可以使用了。
{{< gallery match="images/8/*.png" >}}

## 第7步：最终确定设置
在这一步骤中也需要控制台。我使用 "exec "命令来保存容器内部的应用程序数据库。
{{< terminal >}}
sudo docker exec -it calibre-web-server cp /app/calibre-web/app.db /briefkaste/app.db

{{</ terminal >}}
之后，我看到Calibre目录下有一个新的 "app.db "文件。
{{< gallery match="images/9/*.png" >}}
然后我停止Calibre服务器。
{{< terminal >}}
sudo docker-compose -f calibre.yml down

{{</ terminal >}}
现在我改变了信箱路径，并将应用数据库持久化在上面。
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre/app.db:/app/calibre-web/app.db
    ports:
      - 8055:8083
    restart: unless-stopped

```
之后，可以重新启动服务器。
{{< terminal >}}
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}