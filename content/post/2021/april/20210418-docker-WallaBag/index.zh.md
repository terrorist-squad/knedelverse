+++
date = "2021-04-18"
title = "容器的伟大之处：在Synology磁盘站上拥有WallaBag"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "archiv", "wallabag"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210418-docker-WallaBag/index.zh.md"
+++
Wallabag是一个用于归档有趣的网站或文章的程序。今天我展示了如何在Synology磁盘站上安装Wallabag服务。
## 专业人士的选择
作为一个有经验的Synology用户，你当然可以用SSH登录并通过Docker Compose文件安装整个设置。
```
version: '3'
services:
  wallabag:
    image: wallabag/wallabag
    environment:
      - MYSQL_ROOT_PASSWORD=wallaroot
      - SYMFONY__ENV__DATABASE_DRIVER=pdo_mysql
      - SYMFONY__ENV__DATABASE_HOST=db
      - SYMFONY__ENV__DATABASE_PORT=3306
      - SYMFONY__ENV__DATABASE_NAME=wallabag
      - SYMFONY__ENV__DATABASE_USER=wallabag
      - SYMFONY__ENV__DATABASE_PASSWORD=wallapass
      - SYMFONY__ENV__DATABASE_CHARSET=utf8mb4
      - SYMFONY__ENV__DOMAIN_NAME=http://192.168.178.50:8089
      - SYMFONY__ENV__SERVER_NAME="Your wallabag instance"
      - SYMFONY__ENV__FOSUSER_CONFIRMATION=false
      - SYMFONY__ENV__TWOFACTOR_AUTH=false
    ports:
      - "8089:80"
    volumes:
      - ./wallabag/images:/var/www/wallabag/web/assets/images

  db:
    image: mariadb
    environment:
      - MYSQL_ROOT_PASSWORD=wallaroot
    volumes:
      - ./mariadb:/var/lib/mysql

```
更多有用的家庭使用的Docker镜像可以在[洛克王国（Dockerverse）]({{< ref "dockerverse" >}} "洛克王国（Dockerverse）")中找到。
## 第1步：准备好壁挂袋文件夹
我在Docker目录下创建一个名为 "wallabag "的新目录。
{{< gallery match="images/1/*.png" >}}

## 第2步：安装数据库
之后，必须创建一个数据库。我在Synology Docker窗口中点击 "注册 "标签，并搜索 "mariadb"。我选择Docker镜像 "mariadb"，然后点击 "最新 "标签。
{{< gallery match="images/2/*.png" >}}
图像下载后，可作为图像使用。Docker区分了2种状态，容器 "动态状态 "和镜像（固定状态）。在我们从镜像中创建一个容器之前，必须进行一些设置。 我双击我的mariadb镜像。
{{< gallery match="images/3/*.png" >}}
然后我点击 "高级设置"，激活 "自动重新启动"。我选择 "卷 "标签，点击 "添加文件夹"。我在那里创建了一个新的数据库文件夹，挂载路径为"/var/lib/mysql"。
{{< gallery match="images/4/*.png" >}}
在 "端口设置 "下，所有端口都被删除。这意味着我选择 "3306 "端口，并用"-"按钮将其删除。
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|变量名称|价值|它是什么？|
|--- | --- |---|
|TZ| Europe/Berlin	|时区|
|MYSQL_ROOT_PASSWORD	 | wallaroot |数据库的主密码。|
{{</table>}}
最后，我输入这些环境变量：见。
{{< gallery match="images/6/*.png" >}}
完成这些设置后，Mariadb服务器就可以启动了!我到处按 "应用"。
{{< gallery match="images/7/*.png" >}}

## 第3步：安装Wallabag
我在Synology Docker窗口中点击 "注册 "标签，并搜索 "wallabag"。我选择Docker镜像 "wallabag/wallabag"，然后点击标签 "最新"。
{{< gallery match="images/8/*.png" >}}
我双击我的壁包图像。然后我点击 "高级设置"，在这里也激活了 "自动重新启动"。
{{< gallery match="images/9/*.png" >}}
我选择 "卷 "选项卡并点击 "添加文件夹"。我在那里创建了一个新的文件夹，挂载路径为"/var/www/wallabag/web/assets/images"。
{{< gallery match="images/10/*.png" >}}
我为 "wallabag "容器分配了固定端口。没有固定的端口，可能是 "wallabag服务器 "在重启后运行在不同的端口上。第一个集装箱端口可以被删除。应记住另一个端口。
{{< gallery match="images/11/*.png" >}}
此外，仍然需要创建一个到 "mariadb "容器的 "链接"。我点击 "链接 "标签，选择数据库容器。在安装wallabag时，应该记住这个别名。
{{< gallery match="images/12/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Umgebungsvariable	|价值|
|--- |---|
|MYSQL_ROOT_PASSWORD	|墙头草|
|SYMFONY__ENV__DATABASE_DRIVER	|pdo_mysql|
|SYMFONY__ENV__DATABASE_HOST	|db|
|SYMFONY__ENV__DATABASE_PORT	|3306|
|SYMFONY__ENV__DATABASE_NAME	|墙包|
|SYMFONY__ENV__DATABASE_USER	|墙包|
|SYMFONY__ENV__DATABASE_PASSWORD	|墙票|
|SYMFONY__ENV__DATABASE_CHARSET |utf8mb4|
|SYMFONY__ENV__DOMAIN_NAME	|"http://synology-ip:container-port" <- 请更改|
|SYMFONY__ENV__SERVER_NAME	|"Wallabag - 服务器"|
|SYMFONY__ENV__FOSUSER_CONFIRMATION	|假的|
|SYMFONY__ENV__TWOFACTOR_AUTH	|假的|
{{</table>}}
最后，我输入这些环境变量：见。
{{< gallery match="images/13/*.png" >}}
现在可以启动该容器了。创建数据库可能需要一些时间。该行为可以通过容器的细节来观察。
{{< gallery match="images/14/*.png" >}}
我用Synology的IP地址和我的容器端口呼叫wallabag服务器。
{{< gallery match="images/15/*.png" >}}
