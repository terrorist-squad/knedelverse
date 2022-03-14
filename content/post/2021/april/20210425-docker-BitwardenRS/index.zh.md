+++
date = "2021-04-25T09:28:11+01:00"
title = "Synology DiskStation上的BitwardenRS"
difficulty = "level-2"
tags = ["bitwardenrs", "Docker", "docker-compose", "password-manager", "passwort", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-BitwardenRS/index.zh.md"
+++
Bitwarden是一个免费的开源密码管理服务，它将网站凭证等机密信息存储在一个加密的保险库中。今天我展示了如何在Synology DiskStation上安装一个BitwardenRS。
## 第1步：准备好BitwardenRS文件夹
我在Docker目录下创建一个名为 "bitwarden "的新目录。
{{< gallery match="images/1/*.png" >}}

## 第2步：安装BitwardenRS
我在Synology Docker窗口中点击 "注册 "标签并搜索 "bitwarden"。我选择Docker镜像 "bitwardenrs/server"，然后点击 "最新 "标签。
{{< gallery match="images/2/*.png" >}}
我双击我的bitwardenrs图像。然后我点击 "高级设置"，在这里也激活了 "自动重新启动"。
{{< gallery match="images/3/*.png" >}}
我选择 "卷 "选项卡并点击 "添加文件夹"。我在那里创建了一个新的文件夹，挂载路径为"/data"。
{{< gallery match="images/4/*.png" >}}
我为 "bitwardenrs "容器分配了固定端口。没有固定的端口，可能是 "bitwardenrs服务器 "在重启后运行在不同的端口。第一个集装箱端口可以被删除。应记住另一个端口。
{{< gallery match="images/5/*.png" >}}
现在可以启动该容器了。我使用Synology的IP地址和我的容器端口8084呼叫bitwardenrs服务器。
{{< gallery match="images/6/*.png" >}}

## 第3步：设置HTTPS
我点击 "控制面板">"反向代理 "和 "创建"。
{{< gallery match="images/7/*.png" >}}
之后，我就可以用Synology的IP地址和我的代理端口8085来调用bitwardenrs服务器，并进行加密。
{{< gallery match="images/8/*.png" >}}