+++
date = "2021-06-19"
title = "Großartiges mit Containern: Remark42 ist meine Kommentar-Lösung"
difficulty = "level-1"
tags = ["microservice", "docker", "vertical", "kommentare"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/june/20210619-docker-remark42/index.de.md"
+++

Wenn man seinen Blog als statische Seite betreibt, dann wünscht man sich vielleicht einen Microservice/Vertical, der eine dynamische Kommentar-Funktion stellt. Dieser Blog ist zum Beispiel in HUGO, einem in GO geschrieben "Websitegenerator" für Markdown-Inhalte realisiert.

Im meinem Fall habe ich diese Docker-Compose-Datei für mich angepasst und mit "docker-compose -f compose.yml up -d" gestartet. Ich habe API-Keys für die Authentifizierung mit Google und Facebook hinterlegt. Außerdem habe ich auch Mail-Server-Einstellungen für die Interaktion mit Lesern eingetragen.
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

Nach der Konfiguration ist der Dienst einsatzbereit und kann in die Webseite eingebunden werden:
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

Und so sieht Remark42 aus:
{{< gallery match="images/1/*.png" >}}

