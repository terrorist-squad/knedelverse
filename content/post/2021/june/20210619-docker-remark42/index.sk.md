+++
date = "2021-06-19"
title = "Veľké veci s kontajnermi: Remark42 je moje riešenie komentárov"
difficulty = "level-1"
tags = ["microservice", "docker", "vertical", "kommentare"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210619-docker-remark42/index.sk.md"
+++
Ak prevádzkujete svoj blog ako statickú stránku, možno budete chcieť mikroslužbu/vertikálnu službu, ktorá poskytuje funkciu dynamických komentárov. Tento blog je napríklad realizovaný v HUGO, "generátore webových stránok" napísanom v GO pre obsah Markdown.V mojom prípade som tento súbor Docker Compose prispôsobil pre mňa a spustil ho pomocou "docker-compose -f compose.yml up -d". Uložil som kľúče API na overovanie v službách Google a Facebook. Zadal som aj nastavenia poštového servera pre interakciu s čitateľmi.
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
Po konfigurácii je služba pripravená na používanie a možno ju integrovať do webovej stránky:
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
A takto vyzerá Remark42:
{{< gallery match="images/1/*.png" >}}
