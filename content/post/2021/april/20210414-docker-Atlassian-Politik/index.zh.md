+++
date = "2021-04-14"
title = "与阿特拉斯的不冷静：如何应对阿特拉斯的政策"
difficulty = "level-3"
tags = ["atlassian", "Atlassian-Politik", "bamboo", "Docker", "confluence", "docker-compose", "jira", "lizenz", "krise", "politik"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210414-docker-Atlassian-Politik/index.zh.md"
+++
Atlassian已经停止销售小型服务器许可证，我已经考虑了很久，如何处理这个问题。由于我仍然想长期使用我的安装，我已经实施了以下措施。
## 措施1：我只使用Docker
我把所有Atlassian工具都作为Docker容器运行。旧的本地安装也可以通过数据库转储转移到Docker安装中。然后可以方便地在家庭实验室的intel Nuc或Synology磁盘站上运行这些程序。
{{< tabs>}}


{{< tab "Jira">}}


```
version: '2'
services:
  jira:
    image: atlassian/jira-software
    container_name: jira_application
    depends_on:
      - db
    restart: always
    environment:
      TZ: 'Europe/Berlin'
    ports:
      - 8080:8080
    volumes:
      - ./jira-data:/var/atlassian/application-data/jira
    networks:
      - jira-network
      
  db:
    restart: always
    image: postgres:latest
    container_name: jira_db
    volumes:
      - ./postgresql:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=jira
      - POSTGRES_PASSWORD=jirapass
      - POSTGRES_DB=jira
    networks:
      - jira-network

networks:
  jira-network:


```

{{< /tab >}}


{{< tab"Confluence">}}


```
version: '2'
services:
  confluence:
    container_name: confluence_server
    image: atlassian/confluence-server:latest
    restart: always
    environment:
      TZ: "Europe/Berlin"
    volumes:
      - ./confluence:/var/atlassian/application-data/confluence/
    ports:
      - 8080:8080
    networks:
      - confluence-network
    depends_on:
      - db

  db:
    image: postgres:latest
    container_name: confluence_postgres
    restart: always
    volumes:
      - /postgresql:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=confluencedb
      - POSTGRES_PASSWORD=confluence-password
      - POSTGRES_DB=confluenceUser
    networks:
      - confluence-network

networks:
  confluence-network:

```

{{< /tab >}}


{{< tab"Bamboo">}}


```
version: '2'

services:
  bamboo:
    container_name: bamboo_server
    image: atlassian/bamboo-server
    restart: always
    environment:
      TZ: "Europe/Berlin"
    volumes:
      - ./bamboo-data:/var/atlassian/application-data/bamboo
    ports:
      - 8080:8080
    networks:
      - bamboo-network
    depends_on:
      - db

  db:
    image: postgres:latest
    container_name: bamboo-postgres
    restart: always
    volumes:
      - ./postgresql:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=bamboo
      - POSTGRES_PASSWORD=bamboo
      - POSTGRES_DB=bamboo
    networks:
      - bamboo-network

networks:
  bamboo-network:


```

{{< /tab >}}


{{< /tabs >}}


## 措施2：数据库和图像的备份
当然，每天分散的数据库备份在我的灾难恢复策略中发挥了很大作用。但我也备份了安装图像。Docker镜像可以通过以下命令进行归档。
{{< terminal >}}
docker save -o bamboo-7.2.3-image.tar atlassian/bamboo-server

{{</ terminal >}}
归档文件可以按以下方式加载到Docker注册中心。
{{< terminal >}}
ocker load -i bamboo-7.2.3-image.tar

{{</ terminal >}}
我还保存了Postgres的图像。
## 行动3：创建USB安装棒
我已经把我的文档、所有的安装档案、Postgres数据目录和配置都备份到一个U盘上了。正如我所说，数据库备份实际上是最重要的，因为激活的许可证也在数据库中。
{{< gallery match="images/1/*.png" >}}
