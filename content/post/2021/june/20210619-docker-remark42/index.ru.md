+++
date = "2021-06-19"
title = "Великие дела с контейнерами: Remark42 - мое решение для комментариев"
difficulty = "level-1"
tags = ["microservice", "docker", "vertical", "kommentare"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/june/20210619-docker-remark42/index.ru.md"
+++
Если вы ведете свой блог как статичный сайт, вам может понадобиться микросервис/вертикаль, обеспечивающий динамическую функцию комментариев. Этот блог, например, реализован в HUGO, "генераторе сайтов", написанном на GO для Markdown-контента. В моем случае я адаптировал этот файл Docker Compose для себя и запустил его с помощью "docker-compose -f compose.yml up -d". Я сохранил API-ключи для аутентификации в Google и Facebook. Я также ввел настройки почтового сервера для взаимодействия с читателями.
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
После настройки сервис готов к использованию и может быть интегрирован в веб-сайт:
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
А вот так выглядит Remark42:
{{< gallery match="images/1/*.png" >}}
