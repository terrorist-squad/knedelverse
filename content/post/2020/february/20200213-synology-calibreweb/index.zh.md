+++
date = "2020-02-13"
title = "Synology-Nas: 安装Calibre Web作为电子书库"
difficulty = "level-1"
tags = ["calbre-web", "calibre", "Docker", "ds918", "ebook", "epub", "nas", "pdf", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200213-synology-calibreweb/index.zh.md"
+++
我如何将Calibre-Web作为Docker容器安装在我的Synology NAS上？ 注意：这种安装方法已经过时了，与当前的Calibre软件不兼容。请看一下这个新的教程：[容器的伟大之处：用Docker Compose运行Calibre]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "容器的伟大之处：用Docker Compose运行Calibre")。本教程适用于所有Synology DS的专业人士。
## 第1步：创建文件夹
首先，我为Calibre库创建一个文件夹。  我调出 "系统控制"->"共享文件夹"，并创建一个新的文件夹 "书籍"。
{{< gallery match="images/1/*.png" >}}

## 第2步：创建Calibre库
现在我复制一个现有的库或"[这个空的样本库](https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view) "到新的目录。我自己已经复制了桌面应用程序的现有库。
{{< gallery match="images/2/*.png" >}}

## 第3步：搜索Docker镜像
我在Synology Docker窗口中点击 "注册 "标签，并搜索 "Calibre"。我选择Docker镜像 "janeczku/calibre-web"，然后点击 "最新 "标签。
{{< gallery match="images/3/*.png" >}}
图像下载后，可作为图像使用。Docker区分了两种状态，容器 "动态状态 "和图像/影像（固定状态）。在我们从镜像中创建一个容器之前，必须进行一些设置。
## 第四步：将图像投入运行。
我双击我的Calibre图像。
{{< gallery match="images/4/*.png" >}}
然后我点击 "高级设置"，激活 "自动重新启动"。我选择 "卷 "选项卡并点击 "添加文件夹"。我在那里创建了一个新的数据库文件夹，挂载路径为"/calibre"。
{{< gallery match="images/5/*.png" >}}
我为Calibre容器分配了固定的端口。没有固定的端口，可能是Calibre在重启后运行在不同的端口上。
{{< gallery match="images/6/*.png" >}}
完成这些设置后，就可以启动Calibre了!
{{< gallery match="images/7/*.png" >}}
我现在用指定的Calibre端口调用我的Synology IP，并看到以下图片。我输入"/calibre "作为 "Calibre数据库的位置"。其余的设置是一个品味的问题。
{{< gallery match="images/8/*.png" >}}
默认登录是 "admin"，密码是 "admin123"。
{{< gallery match="images/9/*.png" >}}
完成了!当然，我现在也可以通过我的 "图书文件夹 "连接桌面应用程序。我在我的应用程序中交换了库，然后选择我的Nas文件夹。
{{< gallery match="images/10/*.png" >}}
类似这样的事情。
{{< gallery match="images/11/*.png" >}}
如果我现在在桌面应用中编辑元信息，它们也会在网络应用中自动更新。
{{< gallery match="images/12/*.png" >}}