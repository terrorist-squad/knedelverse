+++
date = "2021-06-19"
title = "Grandi cose con i contenitori: Remark42 è la mia soluzione per i commenti"
difficulty = "level-1"
tags = ["microservice", "docker", "vertical", "kommentare"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210619-docker-remark42/index.it.md"
+++
Se gestite il vostro blog come un sito statico, potreste volere un microservizio/verticale che fornisca una funzione di commento dinamico. Questo blog, per esempio, è realizzato in HUGO, un "generatore di siti web" scritto in GO per contenuti Markdown.Nel mio caso, ho adattato questo file Docker Compose per me e l'ho avviato con "docker-compose -f compose.yml up -d". Ho memorizzato le chiavi API per l'autenticazione con Google e Facebook. Ho anche inserito le impostazioni del server di posta per l'interazione con i lettori.
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
Dopo la configurazione, il servizio è pronto per l'uso e può essere integrato nel sito web:
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
E questo è l'aspetto di Remark42:
{{< gallery match="images/1/*.png" >}}
