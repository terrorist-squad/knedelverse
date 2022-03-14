+++
date = "2021-06-19"
title = "Nagyszerű dolgok konténerekkel: Remark42 az én kommentmegoldásom"
difficulty = "level-1"
tags = ["microservice", "docker", "vertical", "kommentare"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/june/20210619-docker-remark42/index.hu.md"
+++
Ha a blogját statikus webhelyként üzemelteti, akkor olyan mikroszolgáltatást/vertikális oldalt érdemes használni, amely dinamikus hozzászólási funkciót biztosít. Ez a blog például HUGO-ban valósul meg, ami egy GO-ban írt "weboldal-generátor" Markdown tartalmakhoz.Az én esetemben ezt a Docker Compose fájlt adaptáltam magamnak, és a "docker-compose -f compose.yml up -d" paranccsal indítottam el. A Google és a Facebook hitelesítéshez tárolt API-kulcsokat tároltam. Az olvasókkal való interakció érdekében a levelezőszerver beállításait is megadtam.
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
A konfigurálás után a szolgáltatás használatra kész, és integrálható a weboldalba:
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
És így néz ki a Remark42:
{{< gallery match="images/1/*.png" >}}
