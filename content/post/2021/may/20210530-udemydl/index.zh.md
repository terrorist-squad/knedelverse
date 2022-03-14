+++
date = "2021-05-30"
title = "Synology DiskStation 上的 Udemy 下载器"
difficulty = "level-2"
tags = ["udemy", "download", "synology", "diskstation", "udemydl"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-udemydl/index.zh.md"
+++
在本教程中，您将学习如何下载 "udemy "课程供离线使用。
## 第1步：准备好Udemy文件夹
我在Docker目录下创建一个名为 "udemy "的新目录。
{{< gallery match="images/1/*.png" >}}

## 第2步：安装Ubuntu图像
我在Synology Docker窗口中点击 "注册 "标签，并搜索 "ubunutu"。我选择Docker镜像 "ubunutu"，然后点击 "最新 "标签。
{{< gallery match="images/2/*.png" >}}
我双击我的Ubuntu图像。然后我点击 "高级设置"，在这里也激活了 "自动重新启动"。
{{< gallery match="images/3/*.png" >}}
我选择 "卷 "选项卡并点击 "添加文件夹"。我在那里创建了一个新的文件夹，挂载路径为"/download"。
{{< gallery match="images/4/*.png" >}}
现在可以启动容器了
{{< gallery match="images/5/*.png" >}}

## 第4步：安装Udemy下载器
我在Synology Docker窗口中点击 "容器"，然后双击我的 "Udemy容器"。然后我点击 "终端 "标签，输入以下命令。
{{< gallery match="images/6/*.png" >}}

## 命令。

{{< terminal >}}
apt-get update
apt-get install python3 python3-pip wget unzip
cd /download
wget https://github.com/r0oth3x49/udemy-dl/archive/refs/heads/master.zip
unzip master.zip
cd udemy-dl-master
pip3 pip install -r requirements.txt

{{</ terminal >}}
截图。
{{< gallery match="images/7/*.png" >}}

## 第四步：将Udemy下载器投入运行
现在我需要一个 "访问令牌"。我用Firefox浏览器访问Udemy，并打开Firebug。我点击 "网络存储 "标签并复制 "访问令牌"。
{{< gallery match="images/8/*.png" >}}
我在我的容器中创建一个新文件。
{{< terminal >}}
echo "access_token=859wjuhV7PMLsZu15GOWias9A0iFnRjkL9pJXOv2" > /download/cookie.txt

{{</ terminal >}}
之后，我可以下载我已经购买的课程。
{{< terminal >}}
cd /download
python3 udemy-dl-master/udemy-dl.py -k /download/cookie.txt https://www.udemy.com/course/ansible-grundlagen/learn/

{{</ terminal >}}
见。
{{< gallery match="images/9/*.png" >}}
