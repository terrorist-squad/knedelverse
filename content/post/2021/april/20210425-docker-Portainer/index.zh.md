+++
date = "2021-04-25T09:28:11+01:00"
title = "容器的伟大之处：Portainer作为Synology Docker GUI的替代品"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Portainer/index.zh.md"
+++

## 第1步：准备好Synology
首先，必须在 DiskStation 上激活 SSH 登录。要做到这一点，请进入 "控制面板">"终端"。
{{< gallery match="images/1/*.png" >}}
然后你可以通过 "SSH"、指定的端口和管理员密码来登录（Windows用户使用Putty或WinSCP）。
{{< gallery match="images/2/*.png" >}}
我通过终端、winSCP或Putty登录，并将这个控制台打开以备不时之需。
## 第2步：创建tainer文件夹
我在Docker目录下创建一个名为 "portainer "的新目录。
{{< gallery match="images/3/*.png" >}}
然后我用控制台进入portainer目录，在那里创建一个文件夹和一个名为 "portainer.yml "的新文件。
{{< terminal >}}
cd /volume1/docker/portainer
mkdir portainer_data
vim portainer.yml

{{</ terminal >}}
下面是 "portainer.yml "文件的内容。
```
version: '3'

services:
  portainer:
    image: portainer/portainer:latest
    container_name: portainer
    restart: always
    ports:
      - 90070:9000
      - 9090:8000
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./portainer_data:/data

```
更多有用的家庭使用的Docker镜像可以在[洛克王国（Dockerverse）]({{< ref "dockerverse" >}} "洛克王国（Dockerverse）")中找到。
## 第3步：窗帘启动
在这一步，我也可以很好地利用控制台。我通过Docker Compose启动portainer服务器。
{{< terminal >}}
sudo docker-compose -f portainer.yml up -d

{{</ terminal >}}
然后我就可以用磁盘站的IP和 "步骤2 "中分配的端口来调用我的Portainer服务器。我输入我的管理密码并选择本地变量。
{{< gallery match="images/4/*.png" >}}
正如你所看到的，一切都运作得很好!
{{< gallery match="images/5/*.png" >}}
