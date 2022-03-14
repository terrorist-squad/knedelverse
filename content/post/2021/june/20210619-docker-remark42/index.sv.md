+++
date = "2021-06-19"
title = "Stora saker med containrar: Remark42 är min lösning för kommentarer"
difficulty = "level-1"
tags = ["microservice", "docker", "vertical", "kommentare"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/june/20210619-docker-remark42/index.sv.md"
+++
Om du driver din blogg som en statisk webbplats kanske du vill ha en mikrotjänst/vertikal som har en dynamisk kommentarsfunktion. Den här bloggen är till exempel gjord i HUGO, en "webbplatsgenerator" skriven i GO för Markdown-innehåll.I mitt fall anpassade jag den här Docker Compose-filen för mig och startade den med "docker-compose -f compose.yml up -d". Jag har lagrat API-nycklar för autentisering med Google och Facebook. Jag har också lagt in inställningar för e-postservern för att kunna interagera med läsarna.
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
Efter konfigurationen är tjänsten redo att användas och kan integreras på webbplatsen:
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
Så här ser Remark42 ut:
{{< gallery match="images/1/*.png" >}}
