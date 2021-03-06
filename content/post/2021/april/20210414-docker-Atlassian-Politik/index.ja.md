+++
date = "2021-04-14"
title = "アトラシアンとのアンクール：アトラシアンポリシーとの付き合い方"
difficulty = "level-3"
tags = ["atlassian", "Atlassian-Politik", "bamboo", "Docker", "confluence", "docker-compose", "jira", "lizenz", "krise", "politik"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210414-docker-Atlassian-Politik/index.ja.md"
+++
アトラシアンがスモールサーバーライセンスの販売を中止したため、その対応について長い間考えていました。まだまだ長く使いたいので、以下の対策を実施しました。
## 対策1：Dockerを独占的に使っている
私はすべてのアトラシアンツールをDockerコンテナとして動かしています。また、古いネイティブインストールは、データベースダンプを経由してDockerインストールに移行することができます。これらは、ホームラボにあるintel NucやSynologyディスクステーションで便利に実行することができます。
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
もちろん、日々のデータベースの分散バックアップは、私のディザスタリカバリ戦略において大きな役割を担っています。でも、インストールイメージもバックアップしておきました。Dockerイメージは、以下のコマンドでアーカイブすることができます。
{{< terminal >}}
docker save -o bamboo-7.2.3-image.tar atlassian/bamboo-server

{{</ terminal >}}
アーカイブは、以下の手順でDockerレジストリに読み込むことができます。
{{< terminal >}}
ocker load -i bamboo-7.2.3-image.tar

{{</ terminal >}}
Postgresのイメージも保存しています。
## 操作3：USBインストールスティックの作成
ドキュメント、すべてのインストールアーカイブ、Postgresのデータディレクトリと設定をUSBメモリにバックアップしています。やはり、アクティベートされたライセンスもデータベースに入っているので、実はDBのバックアップが一番重要なのです。
{{< gallery match="images/1/*.png" >}}

