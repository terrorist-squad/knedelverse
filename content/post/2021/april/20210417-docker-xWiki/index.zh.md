+++
date = "2021-04-17"
title = "容器的伟大之处：在Synology磁盘站上运行你自己的xWiki"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "xwiki", "wiki",]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210417-docker-xWiki/index.zh.md"
+++
XWiki是一个用Java编写的免费wiki软件平台，设计时考虑到了可扩展性。今天我将展示如何在Synology DiskStation上安装xWiki服务。
## 专业人士的选择
作为一个有经验的Synology用户，你当然可以用SSH登录并通过Docker Compose文件安装整个设置。
```
version: '3'
services:
  xwiki:
    image: xwiki:10-postgres-tomcat
    restart: always
    ports:
      - 8080:8080
    links:
      - db
    environment:
      DB_HOST: db
      DB_DATABASE: xwiki
      DB_DATABASE: xwiki
      DB_PASSWORD: xwiki
      TZ: 'Europe/Berlin'

  db:
    image: postgres:latest
    restart: always
    volumes:
      - ./postgresql:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=xwiki
      - POSTGRES_PASSWORD=xwiki
      - POSTGRES_DB=xwiki
      - TZ='Europe/Berlin'

```
更多有用的家庭使用的Docker镜像可以在[洛克王国（Dockerverse）]({{< ref "dockerverse" >}} "洛克王国（Dockerverse）")中找到。
## 第1步：准备wiki文件夹
我在Docker目录下创建一个名为 "wiki "的新目录。
{{< gallery match="images/1/*.png" >}}

## 第2步：安装数据库
在这之后，必须创建一个数据库。我在Synology Docker窗口中点击 "注册 "标签，并搜索 "postgres"。我选择Docker镜像 "postgres"，然后点击标签 "最新"。
{{< gallery match="images/2/*.png" >}}
图像下载后，可作为图像使用。Docker区分了2种状态，容器 "动态状态 "和镜像（固定状态）。在我们从镜像中创建一个容器之前，必须进行一些设置。 我双击我的postgres镜像。
{{< gallery match="images/3/*.png" >}}
然后我点击 "高级设置"，激活 "自动重新启动"。我选择 "卷 "选项卡并点击 "添加文件夹"。我在那里创建了一个新的数据库文件夹，挂载路径为"/var/lib/postgresql/data"。
{{< gallery match="images/4/*.png" >}}
在 "端口设置 "下，所有端口都被删除。这意味着我选择 "5432 "端口，并用"-"按钮将其删除。
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|变量名称|价值|它是什么？|
|--- | --- |---|
|TZ	| Europe/Berlin	|时区|
|POSTGRES_DB	| xwiki |这是数据库的名称。|
|POSTGRES_USER	| xwiki |维基数据库的用户名称。|
|POSTGRES_PASSWORD	| xwiki |wiki数据库用户的密码。|
{{</table>}}
最后，我输入这四个环境变量：见。
{{< gallery match="images/6/*.png" >}}
完成这些设置后，Mariadb服务器就可以启动了!我到处按 "应用"。
## 第3步：安装xWiki
我在Synology Docker窗口中点击 "注册 "标签，然后搜索 "xwiki"。我选择Docker镜像 "xwiki"，然后点击标签 "10-postgres-tomcat"。
{{< gallery match="images/7/*.png" >}}
我双击我的xwiki图像。然后我点击 "高级设置"，在这里也激活了 "自动重新启动"。
{{< gallery match="images/8/*.png" >}}
我为 "xwiki "容器分配了固定的端口。没有固定的端口，可能是 "xwiki服务器 "在重启后运行在不同的端口。
{{< gallery match="images/9/*.png" >}}
此外，必须创建一个与 "postgres "容器的 "链接"。我点击 "链接 "标签，选择数据库容器。在安装wiki时，应该记住别名的名称。
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|变量名称|价值|它是什么？|
|--- | --- |---|
|TZ |	Europe/Berlin	|时区|
|DB_HOST	| db |别名名称/容器链接|
|DB_DATABASE	| xwiki	|第2步的数据|
|DB_USER	| xwiki	|第2步的数据|
|DB_PASSWORD	| xwiki |第2步的数据|
{{</table>}}
最后，我输入这些环境变量：见。
{{< gallery match="images/11/*.png" >}}
现在可以启动该容器了。我使用Synology的IP地址和我的容器端口调用xWiki服务器。
{{< gallery match="images/12/*.png" >}}