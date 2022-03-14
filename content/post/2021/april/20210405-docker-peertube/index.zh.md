+++
date = "2021-04-05"
title = "用容器做大事：用PeerTube做自己的视频门户"
difficulty = "level-1"
tags = ["diskstation", "peertube", "Synology", "video", "videoportal"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210405-docker-peertube/index.zh.md"
+++
有了Peertube，你可以创建你自己的视频门户。今天我展示了我如何在我的Synology磁盘站上安装Peertube。
## 第1步：准备好Synology
首先，必须在 DiskStation 上激活 SSH 登录。要做到这一点，请进入 "控制面板">"终端"。
{{< gallery match="images/1/*.png" >}}
然后你可以通过 "SSH"、指定的端口和管理员密码来登录。
{{< gallery match="images/2/*.png" >}}
我通过终端、winSCP或Putty登录，并将这个控制台打开以备不时之需。
## 第2步：准备好Docker文件夹
我在Docker目录下创建一个名为 "Peertube "的新目录。
{{< gallery match="images/3/*.png" >}}
然后我进入Peertube目录，创建一个名为 "peertube.yml "的新文件，内容如下。对于端口，前面的部分 "9000: "可以进行调整。第二卷包含所有视频、播放列表、缩略图等，因此必须进行调整。
```
version: "3.7"

services:
  peertube:
    image: chocobozzz/peertube:contain-buster
    container_name: peertube_peertube
    ports:
       - "9000:9000"
    volumes:
      - ./config:/config
      - ./videos:/data
    environment:
      - TZ="Europe/Berlin"
      - PT_INITIAL_ROOT_PASSWORD=password
      - PEERTUBE_WEBSERVER_HOSTNAME=ip
      - PEERTUBE_WEBSERVER_PORT=port
      - PEERTUBE_WEBSERVER_HTTPS=false
      - PEERTUBE_DB_USERNAME=peertube
      - PEERTUBE_DB_PASSWORD=peertube
      - PEERTUBE_DB_HOSTNAME=postgres
      - POSTGRES_DB=peertube
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - PEERTUBE_REDIS_HOSTNAME=redis
      - PEERTUBE_ADMIN_EMAIL=himself@christian-knedel.de
    depends_on:
      - postgres
      - redis
    restart: "always"
    networks:
      - peertube

  postgres:
    restart: always
    image: postgres:12
    container_name: peertube_postgres
    volumes:
      - ./postgresql:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=peertube
      - POSTGRES_PASSWORD=peertube
      - POSTGRES_DB=peertube
    networks:
      - peertube

  redis:
    image: redis:4-alpine
    container_name: peertube_redis
    volumes:
      - ./redis:/data
    restart: "always"
    networks:
      - peertube
    expose:
      - "6379"

networks:
  peertube:

```
这个文件是通过Docker Compose启动的。
{{< terminal >}}
sudo docker-compose -f compose-file-name.yml up -d

{{</ terminal >}}
之后，我可以用磁盘站的IP和 "步骤2 "中分配的端口调用我的Peertube服务器。很好!
{{< gallery match="images/4/*.png" >}}
用户名是 "root"，密码是 "password"（或步骤2/PT_INITIAL_ROOT_PASSWORD）。
## 主题定制
定制波音公司的外观非常容易。要做到这一点，我点击 "管理">"设置 "和 "高级设置"。
{{< gallery match="images/5/*.png" >}}
在那里，我在CSS领域输入了以下内容。
```
body#custom-css {
--mainColor: #3598dc;
--mainHoverColor: #3598dc;
--mainBackgroundColor: #FAFAFA;
--mainForegroundColor: #888888;
--menuBackgroundColor: #f5f5f5;
--menuForegroundColor: #888888;
--submenuColor: #fff;
--inputColor: #fff;
--inputPlaceholderColor: #898989;
}

```

## 其他API
PeerTube有一个广泛的、有据可查的Rest API：https://docs.joinpeertube.org/api-rest-reference.html。
{{< gallery match="images/6/*.png" >}}
用这个命令可以搜索视频。
{{< terminal >}}
curl -s "http://pree-tube/api/v1search/videos?search=docker&languageOneOf=de"

{{</ terminal >}}
例如，上传时需要认证和会话令牌。
```
#!/bin/bash
USERNAME="user"
PASSWORD="password"
API_PATH="http://peertube-adresse/api/v1"

client_id=$(curl -s "$API_PATH/oauth-clients/local" | jq -r ".client_id")
client_secret=$(curl -s "$API_PATH/oauth-clients/local" | jq -r ".client_secret")
token=$(curl -s "$API_PATH/users/token" \
  --data client_id="$client_id" \
  --data client_secret="$client_secret" \
  --data grant_type=password \
  --data response_type=code \
  --data username="$USERNAME" \
  --data password="$PASSWORD" \
  | jq -r ".access_token")

curl -s '$API_PATH/videos/upload'-H 'Authorization: Bearer $token' --max-time 11600 --form videofile=@'/scripte/output.mp4' --form name='mein upload' 

```

## 我的建议：阅读《容器的伟大之处：用LDAP和NGINX使Docker服务更安全》。
