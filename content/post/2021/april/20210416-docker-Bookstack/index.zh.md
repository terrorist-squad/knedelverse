+++
date = "2021-04-16"
title = "容器的伟大之处：在Synology DiskStation上建立你自己的Bookstack Wiki"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "bookstack", "wiki"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210416-docker-Bookstack/index.zh.md"
+++
Bookstack是MediaWiki或Confluence的一个 "开源 "替代品。今天我展示了如何在Synology磁盘站上安装Bookstack服务。
## 专业人士的选择
作为一个有经验的Synology用户，你当然可以用SSH登录并通过Docker Compose文件安装整个设置。
```
version: '3'
services:
  bookstack:
    image: solidnerd/bookstack:0.27.4-1
    restart: always
    ports:
      - 8080:8080
    links:
      - database
    environment:
      DB_HOST: database:3306
      DB_DATABASE: my_wiki
      DB_USERNAME: wikiuser
      DB_PASSWORD: my_wiki_pass
      
  database:
    image: mariadb
    restart: always
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: my_wiki_pass1
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
更多有用的家庭使用的Docker镜像可以在[洛克王国（Dockerverse）]({{< ref "dockerverse" >}} "洛克王国（Dockerverse）")中找到。
## 第1步：准备好书架文件夹
我在Docker目录下创建一个名为 "wiki "的新目录。
{{< gallery match="images/1/*.png" >}}

## 第2步：安装数据库
之后，必须创建一个数据库。我在Synology Docker窗口中点击 "注册 "标签，并搜索 "mariadb"。我选择Docker镜像 "mariadb"，然后点击 "最新 "标签。
{{< gallery match="images/2/*.png" >}}
图像下载后，可作为图像使用。Docker区分了2种状态，容器 "动态状态 "和镜像（固定状态）。在我们从镜像中创建一个容器之前，必须进行一些设置。 我双击我的mariadb镜像。
{{< gallery match="images/3/*.png" >}}
然后我点击 "高级设置"，激活 "自动重新启动"。我选择 "卷 "选项卡并点击 "添加文件夹"。我在那里创建了一个新的数据库文件夹，挂载路径为"/var/lib/mysql"。
{{< gallery match="images/4/*.png" >}}
在 "端口设置 "下，所有端口都被删除。这意味着我选择 "3306 "端口，并用"-"按钮将其删除。
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|变量名称|价值|它是什么？|
|--- | --- |---|
|TZ	| Europe/Berlin |时区|
|MYSQL_ROOT_PASSWORD	|  my_wiki_pass |数据库的主密码。|
|MYSQL_DATABASE | 	my_wiki	|这是数据库的名称。|
|MYSQL_USER	|  wikiuser	|维基数据库的用户名称。|
|MYSQL_PASSWORD	|  my_wiki_pass	|wiki数据库用户的密码。|
{{</table>}}
最后，我输入这些环境变量：见。
{{< gallery match="images/6/*.png" >}}
完成这些设置后，Mariadb服务器就可以启动了!我到处按 "应用"。
## 第3步：安装Bookstack
我在Synology Docker窗口中点击 "注册 "标签，然后搜索 "bookstack"。我选择Docker镜像 "solidnerd/bookstack"，然后点击 "最新 "标签。
{{< gallery match="images/7/*.png" >}}
我双击我的Bookstack图像。然后我点击 "高级设置"，在这里也激活了 "自动重新启动"。
{{< gallery match="images/8/*.png" >}}
我为 "bookstack "容器分配了固定的端口。没有固定的端口，可能是重启后 "bookstack服务器 "运行在不同的端口上。第一个集装箱端口可以被删除。应记住另一个端口。
{{< gallery match="images/9/*.png" >}}
此外，仍然需要创建一个到 "mariadb "容器的 "链接"。我点击 "链接 "标签，选择数据库容器。在安装wiki时应该记住这个别名。
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|变量名称|价值|它是什么？|
|--- | --- |---|
|TZ	| Europe/Berlin |时区|
|DB_HOST	| wiki-db:3306	|别名名称/容器链接|
|DB_DATABASE	| my_wiki |第2步的数据|
|DB_USERNAME	| wikiuser |第2步的数据|
|DB_PASSWORD	| my_wiki_pass	|第2步的数据|
{{</table>}}
最后，我输入这些环境变量：见。
{{< gallery match="images/11/*.png" >}}
现在可以启动该容器了。创建数据库可能需要一些时间。该行为可以通过容器的细节来观察。
{{< gallery match="images/12/*.png" >}}
我用Synology的IP地址和我的容器端口调用Bookstack服务器。登录名是 "admin@admin.com"，密码是 "password"。
{{< gallery match="images/13/*.png" >}}
