+++
date = "2021-02-01"
title = "容器的伟大之处：Synology Diskstation 上的 Pihole"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dns", "adblocker", "fritzbox"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/february/20210201-docker-pihole/index.zh.md"
+++
今天我展示了如何在Synology磁盘站上安装Pihole服务并将其连接到Fritzbox。
## 第1步：准备好Synology
首先，必须在 DiskStation 上激活 SSH 登录。要做到这一点，请进入 "控制面板">"终端"。
{{< gallery match="images/1/*.png" >}}
然后你可以通过 "SSH"、指定的端口和管理员密码来登录（Windows用户使用Putty或WinSCP）。
{{< gallery match="images/2/*.png" >}}
我通过终端、winSCP或Putty登录，并将这个控制台打开以备不时之需。
## 第2步：创建Pihole文件夹
我在Docker目录下创建了一个名为 "pihole "的新目录。
{{< gallery match="images/3/*.png" >}}
然后我换到新的目录，创建两个文件夹 "etc-pihole "和 "etc-dnsmasq.d"。
{{< terminal >}}
cd /volume1/docker/
mkdir -p {etc-pihole,etc-dnsmasq.d}

{{</ terminal >}}
现在，以下名为 "pihole.yml "的Docker Compose文件必须放在Pihole目录中。
```
version: "3"

services:
  pihole:
    container_name: pihole
    image: pihole/pihole:latest
    ports:
      - "53:53/tcp"
      - "53:53/udp"
      - "67:67/udp"
      - "8080:80/tcp"
    environment:
      TZ: 'Europe/Berlin'
      WEBPASSWORD: 'password'
    volumes:
      - './etc-pihole/:/etc/pihole/'
      - './etc-dnsmasq.d/:/etc/dnsmasq.d/'
    cap_add:
      - NET_ADMIN
    restart: unless-stopped

```
现在可以启动该容器了。
{{< terminal >}}
sudo docker-compose up -d

{{</ terminal >}}
我用Synology的IP地址和我的容器端口调用Pihole服务器，用WEBPASSWORD密码登录。
{{< gallery match="images/4/*.png" >}}
现在可以在Fritzbox的 "家庭网络">"网络">"网络设置 "中改变DNS地址。
{{< gallery match="images/5/*.png" >}}