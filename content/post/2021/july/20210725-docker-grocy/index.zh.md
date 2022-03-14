+++
date = "2021-07-25"
title = "用容器做大事：用Grocy管理冰箱"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "kühlschrank", "erp", "mhd", "Speispläne", "cms", "Cafe", "Bistro"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/july/20210725-docker-grocy/index.zh.md"
+++
通过Grocy，您可以管理整个家庭、餐厅、咖啡馆、小酒馆或食品市场。你可以管理冰箱、菜单、任务、购物清单和食物的最佳食用日期。
{{< gallery match="images/1/*.png" >}}
今天我展示了如何在Synology磁盘站上安装Grocy服务。
## 专业人士的选择
作为一个有经验的Synology用户，你当然可以用SSH登录并通过Docker Compose文件安装整个设置。
```
version: "2.1"
services:
  grocy:
    image: ghcr.io/linuxserver/grocy
    container_name: grocy
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./data:/config
    ports:
      - 9283:80
    restart: unless-stopped

```
更多有用的家庭使用的Docker镜像可以在[洛克王国（Dockerverse）]({{< ref "dockerverse" >}} "洛克王国（Dockerverse）")中找到。
## 第1步：准备好Grocy文件夹
我在Docker目录下创建一个名为 "grocy "的新目录。
{{< gallery match="images/2/*.png" >}}

## 第2步：安装Grocy
我在Synology Docker窗口中点击 "注册 "标签，并搜索 "Grocy"。我选择Docker镜像 "linuxserver/grocy:new"，然后点击标签 "最新"。
{{< gallery match="images/3/*.png" >}}
我双击我的Grocy图像。
{{< gallery match="images/4/*.png" >}}
然后我点击 "高级设置"，在这里也激活了 "自动重新启动"。我选择 "卷 "选项卡并点击 "添加文件夹"。我在那里创建了一个新的文件夹，挂载路径为"/config"。
{{< gallery match="images/5/*.png" >}}
我为 "Grocy "容器分配了固定端口。没有固定的端口，可能是重启后 "Grocy服务器 "运行在不同的端口上。
{{< gallery match="images/6/*.png" >}}
{{<table "table table-striped table-bordered">}}
|变量名称|价值|它是什么？|
|--- | --- |---|
|TZ | Europe/Berlin |时区|
|PUID | 1024 |来自 Synology 管理员的用户 ID|
|PGID |	100 |群组ID来自于Synology管理用户|
{{</table>}}
最后，我输入这些环境变量：见。
{{< gallery match="images/7/*.png" >}}
现在可以启动该容器了。我用Synology的IP地址和我的容器端口调用Grocy服务器，用用户名 "admin "和密码 "admin "登录。
{{< gallery match="images/8/*.png" >}}
