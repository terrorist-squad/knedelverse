+++
date = "2021-06-19"
title = "Velike stvari z zabojniki: Remark42 je moja rešitev za komentarje"
difficulty = "level-1"
tags = ["microservice", "docker", "vertical", "kommentare"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210619-docker-remark42/index.sl.md"
+++
Če blog vodite kot statično spletno mesto, boste morda želeli mikrostoritev/vertikalo, ki zagotavlja funkcijo dinamičnih komentarjev. Ta blog, na primer, je realiziran v HUGO, "generatorju spletnih strani", napisanem v GO za vsebino Markdown.V mojem primeru sem to datoteko Docker Compose prilagodil zase in jo začel z "docker-compose -f compose.yml up -d". Shranil sem ključe API za preverjanje pristnosti v Googlu in Facebooku. Vnesel sem tudi nastavitve poštnega strežnika za interakcijo z bralci.
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
Po konfiguraciji je storitev pripravljena za uporabo in jo je mogoče vključiti v spletno mesto:
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
Tako je videti Remark42:
{{< gallery match="images/1/*.png" >}}

