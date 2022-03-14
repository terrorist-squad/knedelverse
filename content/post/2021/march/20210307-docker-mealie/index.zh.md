+++
date = "2021-03-07"
title = "容器的伟大之处：在Synology DiskStation上管理和存档菜谱"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "rezepte", "speisen", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210307-docker-mealie/index.zh.md"
+++
在Docker容器中收集所有你喜欢的菜谱，并按你的意愿组织它们。编写你自己的食谱或从网站导入食谱，例如 "Chefkoch"、"Essen "等。
{{< gallery match="images/1/*.png" >}}

## 专业人士的选择
作为一个有经验的Synology用户，你当然可以用SSH登录并通过Docker Compose文件安装整个设置。
```
version: "2.0"
services:
  mealie:
    container_name: mealie
    image: hkotel/mealie:latest
    restart: always
    ports:
      - 9000:80
    environment:
      db_type: sqlite
      TZ: Europa/Berlin
    volumes:
      - ./mealie/data/:/app/data

```

## 第1步：搜索Docker镜像
我在Synology Docker窗口中点击 "注册 "选项卡并搜索 "dinnerie"。我选择Docker镜像 "hkotel/mealie:fresh"，然后点击标签 "最新"。
{{< gallery match="images/2/*.png" >}}
图像下载后，可作为图像使用。Docker区分了两种状态，容器 "动态状态 "和图像/影像（固定状态）。在我们从镜像中创建一个容器之前，必须进行一些设置。
## 第2步：将图像投入运行。
我双击我的 "饭团 "图像。
{{< gallery match="images/3/*.png" >}}
然后我点击 "高级设置"，激活 "自动重新启动"。我选择 "卷 "选项卡并点击 "添加文件夹"。我在那里创建了一个新的文件夹，挂载路径为"/app/data"。
{{< gallery match="images/4/*.png" >}}
我为 "Mealie "容器分配了固定端口。没有固定的端口，可能是 "Mealie服务器 "在重启后运行在不同的端口。
{{< gallery match="images/5/*.png" >}}
最后，我输入两个环境变量。变量 "db_type "是数据库类型，"TZ "是时区 "Europe/Berlin"。
{{< gallery match="images/6/*.png" >}}
做完这些设置后，就可以启动Mealie服务器了!之后，你可以通过Synology设备的Ip地址和指定的端口来呼叫Mealie，例如：http://192.168.21.23:8096 。
{{< gallery match="images/7/*.png" >}}

## 迈瑞是如何工作的？
如果我把鼠标移到右/下方的 "加号 "按钮上，然后点击 "链 "符号，我就可以输入一个网址。Mealie应用程序会自动搜索所需的元和模式信息。
{{< gallery match="images/8/*.png" >}}
导入效果很好（我曾用这些函数从Chef、Food
{{< gallery match="images/9/*.png" >}}
在编辑模式下，我也可以添加一个类别。重要的是，我在每个类别后按一次 "回车 "键。否则，该设置将不被应用。
{{< gallery match="images/10/*.png" >}}

## 专题报道
我注意到，菜单上的类别并没有自动更新。你必须用浏览器重载来帮助这里。
{{< gallery match="images/11/*.png" >}}

## 其他特点
当然，你可以搜索菜谱，也可以创建菜单。此外，你可以非常广泛地定制 "Mealie"。
{{< gallery match="images/12/*.png" >}}
Mealie在移动端看起来也很不错。
{{< gallery match="images/13/*.*" >}}

## 暂停-Api
API文档可以在 "http://gewaehlte-ip:und-port ... /docs "找到。在这里，你会发现许多可用于自动化的方法。
{{< gallery match="images/14/*.png" >}}

## Api实例
想象一下以下小说："Gruner und Jahr推出互联网门户网站Essen
{{< terminal >}}
wget --spider --force-html -r -l12  "https://www.essen-und-trinken.de/rezepte/archiv/"  2>&1 | grep '/rezepte/' | grep '^--' | awk '{ print $3 }' > liste.txt

{{</ terminal >}}
然后清理这个列表，并对其他api进行发射，例如。
```
#!/bin/bash
sort -u liste.txt > clear.txt

while read p; do
  echo "import url: $p"
  curl -d "{\"url\":\"$p\"}" -H "Content-Type: application/json" http://synology-ip:8096/api/recipes/create-url
  sleep 1
done < clear.txt

```
现在，你也可以在离线状态下访问这些食谱。
{{< gallery match="images/15/*.png" >}}
