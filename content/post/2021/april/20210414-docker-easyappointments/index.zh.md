+++
date = "2021-04-16"
title = "创造性地走出危机：用轻松预约的方式预约服务"
difficulty = "level-3"
tags = ["buchung", "buchungstool", "click-and-meet", "corona", "Docker", "docker-compose", "easyappointments", "krise", "einzelhandel", "geschaefte"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210414-docker-easyappointments/index.zh.md"
+++
科罗娜危机对德国的服务提供商造成了严重打击。数字工具和解决方案可以帮助尽可能安全地度过科罗纳大流行病。在这个教程系列 "走出危机的创意 "中，我展示了对小企业有用的技术或工具。今天我展示了 "Easyappointments"，一个 "点击并满足 "的服务预订工具，例如美发店或商店。易任由两个方面组成。
## 区域1：后端
一个用于管理服务和约会的 "后台"。
{{< gallery match="images/1/*.png" >}}

## 领域2：前台
一个用于预约的终端用户工具。所有已经预订的预约都会被封锁，不能再进行第二次预订。
{{< gallery match="images/2/*.png" >}}

## 安装
我已经用Docker-Compose安装了Easyappointments几次，并可以高度推荐这种安装方法。我在我的服务器上创建了一个名为 "easyappointments "的新目录。
{{< terminal >}}
mkdir easyappointments
cd easyappointments

{{</ terminal >}}
然后我进入easyappointments目录，创建一个新的文件，名为 "easyappointments.yml"，内容如下。
```
version: '2'
services:
  db:
    image: mysql
    environment:
      - MYSQL_ROOT_PASSWORD=root
      - MYSQL_DATABASE=easyappointments
      - MYSQL_USER=easyappointments
      - MYSQL_PASSWORD=easyappointments
    command: mysqld --default-authentication-plugin=mysql_native_password
    volumes:
      - ./easy-appointments-data:/var/lib/mysql
    expose:
      - 3306
    networks:
      - easyappointments-network
    restart: always

  application:
    image: jamrizzi/easyappointments
    volumes:
      - ./easy-appointments:/app/www
    depends_on:
      - db
    ports:
      - 8089:8888
    environment:
      - DB_HOST=db
      - DB_USERNAME=easyappointments
      - DB_NAME=easyappointments
      - DB_PASSWORD=easyappointments
      - TZ=Europe/Berlin
      - BASE_URL=http://192.168.178.50:8089 
    networks:
      - easyappointments-network
    restart: always

networks:
  easyappointments-network:

```
这个文件是通过Docker Compose启动的。之后，在预定的域/端口下可以访问该安装。
{{< terminal >}}
docker-compose -f easyappointments.yml up

{{</ terminal >}}

## 创建一个服务
服务可以在 "服务 "下创建。然后，每个新的服务必须分配给一个服务提供者/用户。这意味着我可以预订专门的雇员或服务提供者。
{{< gallery match="images/3/*.png" >}}
最终消费者也可以选择服务和首选服务供应商。
{{< gallery match="images/4/*.png" >}}

## 工作时间和休息时间
一般值班时间可以在 "设置">"业务逻辑 "下设置。然而，服务提供者/用户的工作时间也可以在用户的 "工作计划 "中进行更改。
{{< gallery match="images/5/*.png" >}}

## 预订概况和日记
约会日历使所有的预约都是可见的。当然，也可以在那里创建或编辑预订。
{{< gallery match="images/6/*.png" >}}

## 颜色或逻辑的调整
如果你把"/app/www "目录复制出来，并把它作为一个 "卷"，那么你就可以按照你的意愿调整样式表和逻辑。
{{< gallery match="images/7/*.png" >}}