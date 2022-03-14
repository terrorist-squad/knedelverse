+++
date = "2021-06-19"
title = "Store ting med containere: Remark42 er min kommentarløsning"
difficulty = "level-1"
tags = ["microservice", "docker", "vertical", "kommentare"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/june/20210619-docker-remark42/index.da.md"
+++
Hvis du driver din blog som et statisk websted, vil du måske have en mikroservice/vertical, der tilbyder en dynamisk kommentarfunktion. Denne blog er f.eks. lavet i HUGO, en "website generator" skrevet i GO til Markdown-indhold.I mit tilfælde tilpassede jeg denne Docker Compose-fil til mig og startede den med "docker-compose -f compose.yml up -d". Jeg har gemt API-nøgler til autentificering med Google og Facebook. Jeg har også indtastet indstillinger for mailserveren med henblik på interaktion med læserne.
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
Efter konfigurationen er tjenesten klar til brug og kan integreres på webstedet:
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
Og sådan ser Remark42 ud:
{{< gallery match="images/1/*.png" >}}
