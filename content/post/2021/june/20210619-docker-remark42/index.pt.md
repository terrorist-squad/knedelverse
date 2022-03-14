+++
date = "2021-06-19"
title = "Grandes coisas com recipientes: Observação42 é a minha solução de comentário"
difficulty = "level-1"
tags = ["microservice", "docker", "vertical", "kommentare"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/june/20210619-docker-remark42/index.pt.md"
+++
Se você rodar seu blog como um site estático, você pode querer um microserviço/vertical que forneça uma função de comentário dinâmico. Este blog, por exemplo, é realizado no HUGO, um "gerador de sites" escrito em GO para conteúdo Markdown. No meu caso, adaptei este ficheiro Docker Compose para mim e comecei-o com "docker-compose -f compose.yml up -d". Tenho as chaves de API armazenadas para autenticação com o Google e o Facebook. Também introduzi as configurações do servidor de correio para interacção com os leitores.
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
Após a configuração, o serviço está pronto para ser utilizado e pode ser integrado no site:
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
E este é o aspecto do Remark42:
{{< gallery match="images/1/*.png" >}}
