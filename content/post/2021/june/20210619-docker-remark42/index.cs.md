+++
date = "2021-06-19"
title = "Velké věci s kontejnery: Remark42 je moje řešení pro komentáře"
difficulty = "level-1"
tags = ["microservice", "docker", "vertical", "kommentare"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/june/20210619-docker-remark42/index.cs.md"
+++
Pokud provozujete svůj blog jako statický web, možná budete chtít mikroslužbu/vertikální službu, která poskytuje funkci dynamických komentářů. Tento blog je například realizován v programu HUGO, "generátoru webových stránek" napsaném v jazyce GO pro obsah Markdown.V mém případě jsem si tento soubor Docker Compose upravil pro sebe a spustil ho příkazem "docker-compose -f compose.yml up -d". Mám uložené klíče API pro ověřování u společností Google a Facebook. Zadal jsem také nastavení poštovního serveru pro interakci se čtenáři.
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
Po konfiguraci je služba připravena k použití a lze ji integrovat do webových stránek:
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
A takto vypadá Remark42:
{{< gallery match="images/1/*.png" >}}
