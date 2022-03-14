+++
date = "2021-06-19"
title = "Geweldige dingen met containers: Remark42 is mijn commentaar oplossing"
difficulty = "level-1"
tags = ["microservice", "docker", "vertical", "kommentare"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210619-docker-remark42/index.nl.md"
+++
Als u uw blog als een statische site beheert, wilt u misschien een microservice/vertical die een dynamische commentaarfunctie biedt. Deze blog, bijvoorbeeld, is gerealiseerd in HUGO, een "website generator" geschreven in GO voor Markdown content.In mijn geval heb ik dit Docker Compose bestand voor mij aangepast en gestart met "docker-compose -f compose.yml up -d". Ik heb API-sleutels opgeslagen voor verificatie met Google en Facebook. Ik heb ook mailserverinstellingen ingevoerd voor interactie met lezers.
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
Na de configuratie is de dienst klaar voor gebruik en kan hij in de website worden geïntegreerd:
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
En dit is hoe Remark42 eruit ziet:
{{< gallery match="images/1/*.png" >}}
