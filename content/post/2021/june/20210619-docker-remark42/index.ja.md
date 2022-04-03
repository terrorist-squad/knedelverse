+++
date = "2021-06-19"
title = "コンテナで大活躍：Remark42は私のコメントソリューション"
difficulty = "level-1"
tags = ["microservice", "docker", "vertical", "kommentare"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210619-docker-remark42/index.ja.md"
+++
ブログを静的なサイトとして運営している場合、動的なコメント機能を提供するマイクロサービス/バーティカルがいいかもしれません。例えばこのブログは、Markdownコンテンツ用にGOで書かれた「ウェブサイトジェネレータ」であるHUGOで実現しています。私の場合、このDocker Composeファイルを自分用にアレンジして、「docker-compose -f compose.yml up -d」で起動しました。GoogleとFacebookで認証するためのAPIキーを保存しています。また、読者との交流のために、メールサーバーの設定も入力しました。
```
version: '2'

services:
    remark:

        image: umputun/remark42:latest
        container_name: "remark42"
        restart: always

        logging:
          driver: json-file
          options:
              max-size: "10m"
              max-file: "5"

        ports:
          - "8050:8080"   

        environment:
            - REMARK_URL=https://www.christian-knedel.de/comments/ 
            - "SECRET=secret"          
            - SITE=www.adresse.de 
            - STORE_BOLT_PATH=/srv/var/db
            - BACKUP_PATH=/srv/var/backup

        volumes:
            - ./data:/srv/var

```
設定後、すぐに利用でき、Webサイトに組み込むことも可能です。
```
<script>
  var remark_config = {
    host: "https://www.christian-knedel.de/comments", 
    site_id: 'www.christian-knedel.de',
    components: ['embed'], 
    max_shown_comments: 10,
    theme: 'dark',
    locale: 'de',
    show_email_subscription: false
  };
</script>
<script>
  (function(c) {
    for(var i = 0; i < c.length; i++){
      var d = document, s = d.createElement('script');
      s.src = remark_config.host + '/web/' +c[i] +'.js';
      s.defer = true;
      (d.head || d.body).appendChild(s);
    }
  })(remark_config.components || ['embed']);
</script>

<br>
<hr>
<br>
<div id="remark42"></div>

```
そして、Remark42はこのような感じです。
{{< gallery match="images/1/*.png" >}}

