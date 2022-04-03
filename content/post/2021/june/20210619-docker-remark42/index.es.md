+++
date = "2021-06-19"
title = "Grandes cosas con contenedores: Remark42 es mi solución de comentarios"
difficulty = "level-1"
tags = ["microservice", "docker", "vertical", "kommentare"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210619-docker-remark42/index.es.md"
+++
Si su blog es un sitio estático, es posible que desee un microservicio/vertical que ofrezca una función de comentarios dinámicos. Este blog, por ejemplo, está realizado en HUGO, un "generador de sitios web" escrito en GO para contenidos Markdown.En mi caso, adapté este archivo Docker Compose para mí y lo inicié con "docker-compose -f compose.yml up -d". He almacenado claves API para la autenticación con Google y Facebook. También introduje la configuración del servidor de correo para la interacción con los lectores.
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
Tras la configuración, el servicio está listo para su uso y puede integrarse en el sitio web:
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
Y este es el aspecto de Remark42:
{{< gallery match="images/1/*.png" >}}

