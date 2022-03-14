+++
date = "2021-06-19"
title = "Страхотни неща с контейнери: Remark42 е моето решение за коментари"
difficulty = "level-1"
tags = ["microservice", "docker", "vertical", "kommentare"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210619-docker-remark42/index.bg.md"
+++
Ако управлявате блога си като статичен сайт, може да искате микроуслуга/вертикална услуга, която осигурява функция за динамични коментари. Този блог, например, е реализиран в HUGO, "генератор на уебсайтове", написан в GO за съдържание Markdown.В моя случай адаптирах този файл на Docker Compose за мен и го стартирах с "docker-compose -f compose.yml up -d". Запазих API ключове за удостоверяване с Google и Facebook. Въведох и настройки на пощенския сървър за взаимодействие с читателите.
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
След конфигурирането услугата е готова за използване и може да бъде интегрирана в уебсайта:
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
А ето как изглежда Remark42:
{{< gallery match="images/1/*.png" >}}
