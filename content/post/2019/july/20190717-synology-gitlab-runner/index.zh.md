+++
date = "2019-07-17"
title = "Synology-Nas: Gitlab - Docker容器中的运行器"
difficulty = "level-4"
tags = ["Docker", "git", "gitlab", "gitlab-runner", "raspberry-pi"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-synology-gitlab-runner/index.zh.md"
+++
如何将Gitlab运行程序作为Docker容器安装在我的Synology NAS上？
## 第1步：搜索Docker镜像
我点击Synology Docker窗口中的 "注册 "标签，并搜索Gitlab。我选择Docker镜像 "gitlab/gitlab-runner"，然后选择标签 "bleeding"。
{{< gallery match="images/1/*.png" >}}

## 第2步：将图像投入运行。

## 主机问题
我的synology-gitlab-insterlation总是只用主机名来识别自己。由于我从软件包中心提取了Synology Gitlab的原始软件包，所以这个行为在之后无法改变。  作为一种变通方法，我可以包括我自己的hosts文件。在这里你可以看到，主机名 "peter "属于Nas的IP地址192.168.12.42。
```
127.0.0.1       localhost                                                       
::1     localhost ip6-localhost ip6-loopback                                    
fe00::0 ip6-localnet                                                            
ff00::0 ip6-mcastprefix                                                         
ff02::1 ip6-allnodes                                                            
ff02::2 ip6-allrouters               
192.168.12.42 peter

```
这个文件只是存储在Synology NAS上。
{{< gallery match="images/2/*.png" >}}

## 第3步：设置GitLab运行器
我点击了我的亚军图像。
{{< gallery match="images/3/*.png" >}}
我激活了 "启用自动重新启动 "的设置。
{{< gallery match="images/4/*.png" >}}
然后我点击 "高级设置"，选择 "音量 "标签。
{{< gallery match="images/5/*.png" >}}
我点击添加文件，并通过路径"/etc/hosts "包括我的hosts文件。只有在主机名不能被解决的情况下，才有必要进行这一步骤。
{{< gallery match="images/6/*.png" >}}
我接受设置并点击下一步。
{{< gallery match="images/7/*.png" >}}
现在我在Container下找到了初始化的图像。
{{< gallery match="images/8/*.png" >}}
我选择容器（对我来说是gitlab-gitlab-runner2）并点击 "详细信息"。然后我点击 "终端 "标签，创建一个新的bash会话。我在这里输入 "gitlab-runner register "命令。对于注册，我需要在我的GitLab安装中找到的信息，在http://gitlab-adresse:port/admin/runners。   
{{< gallery match="images/9/*.png" >}}
如果你需要更多的软件包，你可以通过 "apt-get update"，然后 "apt-get install python ... "来安装它们。
{{< gallery match="images/10/*.png" >}}
之后，我可以在我的项目中加入转轮并使用它。
{{< gallery match="images/11/*.png" >}}
