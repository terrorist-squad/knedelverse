+++
date = "2021-06-19"
title = "Du grand avec des conteneurs : Remark42 est ma solution de commentaire"
difficulty = "level-1"
tags = ["microservice", "docker", "vertical", "kommentare"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/june/20210619-docker-remark42/index.fr.md"
+++
Si l'on gère son blog comme un site statique, on peut souhaiter un microservice/vertical qui offre une fonction de commentaire dynamique. Ce blog est par exemple réalisé en HUGO, un "générateur de site web" écrit en GO pour les contenus Markdown.Dans mon cas, j'ai adapté ce fichier Docker Compose pour moi et l'ai lancé avec "docker-compose -f compose.yml up -d". J'ai défini des clés API pour l'authentification avec Google et Facebook. En outre, j'ai également inscrit des paramètres de serveur de messagerie pour l'interaction avec les lecteurs.
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
Une fois configuré, le service est opérationnel et peut être intégré dans le site web :
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
Et voici à quoi ressemble Remark42 :
{{< gallery match="images/1/*.png" >}}
