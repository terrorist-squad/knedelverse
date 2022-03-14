+++
date = "2020-02-07"
title = "コンテナを使った素晴らしいものInternet Archive in Docker"
difficulty = "level-3"
tags = ["bookmarks", "Docker", "Internet-Archiv", "Synology", "shiori"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200207-docker-shiori/index.ja.md"
+++
以下のチュートリアルでは、プライベートな「インターネットアーカイブ」をDockerコンテナとしてインストールします。必要なのは、この「Docker-compose」ファイルだけです。
```
version: '2'
services:
  db:
     image: radhifadlillah/shiori:latest
     container_name: bookmark-archiv-shiori
     volumes:
       - ./shiori-server:/srv/shiori
     ports:
       - "18080:8080"


```
docker-compose -f your-file.yml up -d "でDocker-Composeでymlファイルを起動した後、指定したポートを介してローカルのインターネットアーカイブにアクセスすることができます。例えば、http://localhost:18080 。デフォルトのログインは、次のウェブサイトで確認できます。https://github.com/go-shiori/shiori/wiki/Usage
```
username: shiori
password: gopher

```
最高ですね。インターネットのアーカイブを利用することができます。
{{< gallery match="images/1/*.png" >}}