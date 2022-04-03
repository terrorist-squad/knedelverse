+++
date = "2021-02-28"
title = "容器的伟大之处: 海姆达尔作为一个主页"
difficulty = "level-3"
tags = ["dienste", "Docker", "docker-compose", "docker-for-desktop", "heimdall", "homepage", "startseite"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/february/20210228-docker-heimdall/index.zh.md"
+++
我在我的Homelab网络中运行许多服务，例如LDAP、Gitlab、Atlassian Bamboo、Atlassian Confluence、Atlassian Jira、Jenkins、WordPress、Grafana、Graylog、ESXI/VMware、Calibre等等。这很容易让人失去对一切的追踪。
{{< gallery match="images/1/*.jpg" >}}

## 第1步：创建工作文件夹
使用该命令创建一个临时工作文件夹。
{{< terminal >}}
mkdir /tmp/bilder

{{</ terminal >}}
Heimdall是一项允许你通过仪表板管理书签的服务。由于我使用Docker for Desktop，我只需要把这个Docker Compose文件放在本地文件夹中。
```
version: "2.1"
services:
  heimdall:
    image: linuxserver/heimdall
    container_name: heimdall
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/Berlin
    volumes:
      - /Users/christianknedel/docker/heimdall/config:/config
    ports:
      - 80:80
      - 443:443
    restart: always

```
这个文件是通过Docker Compose启动的。
{{< terminal >}}
ocker-compose -f compose-file.yml up -d

{{</ terminal >}}

{{< gallery match="images/2/*.png" >}}

