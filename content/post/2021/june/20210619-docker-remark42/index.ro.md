+++
date = "2021-06-19"
title = "Lucruri grozave cu containere: Remark42 este soluția mea pentru comentarii"
difficulty = "level-1"
tags = ["microservice", "docker", "vertical", "kommentare"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/june/20210619-docker-remark42/index.ro.md"
+++
Dacă vă gestionați blogul ca un site static, poate doriți un microserviciu/vertical care să ofere o funcție de comentarii dinamice. Acest blog, de exemplu, este realizat în HUGO, un "generator de site-uri web" scris în GO pentru conținut Markdown.În cazul meu, am adaptat acest fișier Docker Compose pentru mine și l-am pornit cu "docker-compose -f compose.yml up -d". Am stocat chei API pentru autentificarea cu Google și Facebook. De asemenea, am introdus setările serverului de e-mail pentru interacțiunea cu cititorii.
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
După configurare, serviciul este gata de utilizare și poate fi integrat în site-ul web:
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
Și iată cum arată Remark42:
{{< gallery match="images/1/*.png" >}}
