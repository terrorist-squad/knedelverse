+++
date = "2021-06-19"
title = "Świetne rzeczy z kontenerami: Remark42 jest moim rozwiązaniem do komentowania"
difficulty = "level-1"
tags = ["microservice", "docker", "vertical", "kommentare"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/june/20210619-docker-remark42/index.pl.md"
+++
Jeśli prowadzisz swój blog jako stronę statyczną, możesz chcieć mikroserwisu/wersji, która zapewnia dynamiczną funkcję komentarzy. Ten blog, na przykład, jest realizowany w HUGO, "generator stron internetowych" napisany w GO dla treści Markdown.W moim przypadku, dostosowałem ten plik Docker Compose dla mnie i uruchomiłem go za pomocą "docker-compose -f compose.yml up -d". Mam przechowywane klucze API do uwierzytelniania z Google i Facebook. Wprowadziłem również ustawienia serwera pocztowego dla interakcji z czytelnikami.
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
Po skonfigurowaniu serwis jest gotowy do użycia i może być zintegrowany z witryną:
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
A tak wygląda Remark42:
{{< gallery match="images/1/*.png" >}}
