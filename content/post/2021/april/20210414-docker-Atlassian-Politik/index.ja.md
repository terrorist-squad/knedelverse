+++
date = "2021-04-14"
title = "Uncool with Atlassian: アトラスのポリシーにどう対処するか"
difficulty = "level-3"
tags = ["atlassian", "Atlassian-Politik", "bamboo", "Docker", "confluence", "docker-compose", "jira", "lizenz", "krise", "politik"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210414-docker-Atlassian-Politik/index.ja.md"
+++
Atlassianは小規模なサーバーライセンスの販売を中止しましたが、私はこれにどう対処すべきか長い間考えていました。まだまだ長く使っていきたいので、以下のような対策を施しました。
## 対策1：Dockerだけを使っている
私はすべてのAtlassianツールをDockerコンテナとして運用しています。古いネイティブなインストールでも、データベースのダンプを介してDockerインストールに転送することができます。これらは、ホームラボにあるintel NucやSynologyのディスクステーションで便利に使うことができます。
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


## 対策2：データベースとイメージのバックアップ
もちろん、毎日の分散型データベースのバックアップは、私の災害復旧戦略において大きな役割を果たしています。でも、インストールイメージもバックアップしました。以下のコマンドでDockerイメージをアーカイブできます。
{{< terminal >}}
docker save -o bamboo-7.2.3-image.tar atlassian/bamboo-server

{{</ terminal >}}
このアーカイブは、以下のようにしてDocker Registryに読み込むことができます。
{{< terminal >}}
ocker load -i bamboo-7.2.3-image.tar

{{</ terminal >}}
Postgresのイメージも保存しました。
## アクション3：USBインストールスティックの作成
ドキュメント、すべてのインストールアーカイブ、Postgresのデータディレクトリと設定をUSBスティックにバックアップしました。先ほども言いましたが、アクティベートされたライセンスはデータベースにも入っているので、実際にはDBのバックアップが一番重要です。
{{< gallery match="images/1/*.png" >}}
