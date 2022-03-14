+++
date = "2021-04-25T09:28:11+01:00"
title = "容器的伟大之处： Synology 上的 Netbox - Disk"
difficulty = "level-3"
tags = ["Computernetzwerken", "DCIM", "Docker", "docker-compose", "IPAM", "netbox", "Synology", "netwerk"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210425-docker-Netbox/index.zh.md"
+++
NetBox是一个用于计算机网络管理的免费软件。今天我将展示如何在Synology DiskStation上安装Netbox服务。
## 第1步：准备好Synology
首先，必须在 DiskStation 上激活 SSH 登录。要做到这一点，请进入 "控制面板">"终端"。
{{< gallery match="images/1/*.png" >}}
然后你可以通过 "SSH"、指定的端口和管理员密码来登录（Windows用户使用Putty或WinSCP）。
{{< gallery match="images/2/*.png" >}}
我通过终端、winSCP或Putty登录，并将这个控制台打开以备不时之需。
## 第2步：创建NETBOX文件夹
我在Docker目录下创建一个名为 "netbox "的新目录。
{{< gallery match="images/3/*.png" >}}
现在必须下载以下文件并在目录中解压：https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip。我使用控制台来做这个。
{{< terminal >}}
cd /volume1/docker/netbox/
sudo wget https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip
sudo /bin/7z x release.zip
cd netbox-docker-release
sudo mkdir netbox-media-files
sudo mkdir netbox-redis-data
sudo mkdir netbox-postgres-data

{{</ terminal >}}
然后我编辑 "docker/docker-compose.yml "文件，在 "netbox-media-files"、"netbox-postgres-data "和 "netbox-redis-data "中输入我的Synology地址。
```
version: '3.4'
services:
  netbox: &netbox
    image: netboxcommunity/netbox:${VERSION-latest}
    depends_on:
    - postgres
    - redis
    - redis-cache
    - netbox-worker
    env_file: env/netbox.env
    user: '101'
    volumes:
    - ./startup_scripts:/opt/netbox/startup_scripts:z,ro
    - ./initializers:/opt/netbox/initializers:z,ro
    - ./configuration:/etc/netbox/config:z,ro
    - ./reports:/etc/netbox/reports:z,ro
    - ./scripts:/etc/netbox/scripts:z,ro
    - ./netbox-media-files:/opt/netbox/netbox/media:z
    ports:
    - "8097:8080"
  netbox-worker:
    <<: *netbox
    depends_on:
    - redis
    entrypoint:
    - /opt/netbox/venv/bin/python
    - /opt/netbox/netbox/manage.py
    command:
    - rqworker
    ports: []

  # postgres
  postgres:
    image: postgres:12-alpine
    env_file: env/postgres.env
    volumes:
    - ./netbox-postgres-data:/var/lib/postgresql/data

  # redis
  redis:
    image: redis:6-alpine
    command:
    - sh
    - -c # this is to evaluate the $REDIS_PASSWORD from the env
    - redis-server --appendonly yes --requirepass $$REDIS_PASSWORD ## $$ because of docker-compose
    env_file: env/redis.env
    volumes:
    - ./netbox-redis-data:/data
  redis-cache:
    image: redis:6-alpine
    command:
    - sh
    - -c # this is to evaluate the $REDIS_PASSWORD from the env
    - redis-server --requirepass $$REDIS_PASSWORD ## $$ because of docker-compose
    env_file: env/redis-cache.env

```
之后，我就可以启动编撰文件了。
{{< terminal >}}
sudo docker-compose up

{{</ terminal >}}
创建数据库可能需要一些时间。该行为可以通过容器的细节来观察。
{{< gallery match="images/4/*.png" >}}
我使用Synology的IP地址和我的容器端口呼叫netbox服务器。
{{< gallery match="images/5/*.png" >}}