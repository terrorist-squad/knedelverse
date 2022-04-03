+++
date = "2021-06-19"
title = "Suuria asioita konttien kanssa: Remark42 on minun kommenttiratkaisuni"
difficulty = "level-1"
tags = ["microservice", "docker", "vertical", "kommentare"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/june/20210619-docker-remark42/index.fi.md"
+++
Jos käytät blogiasi staattisena sivustona, saatat haluta mikropalvelun tai vertikaalisen sivuston, joka tarjoaa dynaamisen kommentointitoiminnon. Esimerkiksi tämä blogi on toteutettu HUGOlla, joka on GO-kielellä kirjoitettu "verkkosivugeneraattori" Markdown-sisältöä varten.Omassa tapauksessani mukautin tämän Docker Compose -tiedoston itselleni ja käynnistin sen komennolla "docker-compose -f compose.yml up -d". Olen tallentanut API-avaimet Googlen ja Facebookin todennusta varten. Syötin myös sähköpostipalvelimen asetukset vuorovaikutusta varten lukijoiden kanssa.
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
Konfiguroinnin jälkeen palvelu on käyttövalmis ja se voidaan integroida verkkosivustoon:
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
Ja tältä Remark42 näyttää:
{{< gallery match="images/1/*.png" >}}

