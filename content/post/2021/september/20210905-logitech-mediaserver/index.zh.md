+++
date = "2021-09-05"
title = "容器的伟大之处：Synology磁盘站上的罗技媒体服务器"
difficulty = "level-1"
tags = ["logitech", "synology", "diskstation", "nas", "sound-system", "multiroom"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/september/20210905-logitech-mediaserver/index.zh.md"
+++
在本教程中，你将学习如何在Synology DiskStation上安装罗技媒体服务器。
{{< gallery match="images/1/*.jpg" >}}

## 第1步：准备好罗技媒体服务器文件夹
我在Docker目录下创建了一个名为 "logitechmediaserver "的新目录。
{{< gallery match="images/2/*.png" >}}

## 第二步：安装罗技Mediaserver图像
我在Synology Docker窗口中点击 "注册 "标签，并搜索 "logitechmediaserver"。我选择Docker镜像 "lmscommunity/logitechmediaserver"，然后点击 "最新 "标签。
{{< gallery match="images/3/*.png" >}}
我双击我的罗技媒体服务器图像。然后我点击 "高级设置"，在这里也激活了 "自动重新启动"。
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Ordner |山路|
|--- |---|
|/volume1/docker/logitechmediaserver/config |/config|
|/volume1/docker/logitechmediaserver/music |/music|
|/volume1/docker/logitechmediaserver/playlist |/播放列表|
{{</table>}}
我选择 "卷 "选项卡并点击 "添加文件夹"。我在那里创建了三个文件夹：见。
{{< gallery match="images/5/*.png" >}}
我为 "Logitechmediaserver "容器分配了固定端口。没有固定的端口，可能是 "Logitechmediaserver服务器 "在重启后运行在不同的端口上。
{{< gallery match="images/6/*.png" >}}
最后，我输入一个环境变量。变量 "TZ "是时区 "欧洲/柏林"。
{{< gallery match="images/7/*.png" >}}
完成这些设置后，就可以启动Logitechmediaserver-Server!之后，你可以通过Synology设备的Ip地址和指定的端口来调用Logitechmediaserver，例如：http://192.168.21.23:9000 。
{{< gallery match="images/8/*.png" >}}

