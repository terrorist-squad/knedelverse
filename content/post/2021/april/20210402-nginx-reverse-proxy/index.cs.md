+++
date = "2021-04-02"
title = "Skvělé věci s kontejnery: větší zabezpečení služeb Docker pomocí LDAP a NGINX"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ldap", "logging", "nutzerverwaltung", "peertube", "ssl"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210402-nginx-reverse-proxy/index.cs.md"
+++
Jako uživatel zařízení Synology Diskstation provozuji v síti Homelab mnoho služeb. Nasazuji software v Gitlabu, dokumentuju znalosti v Confluence a čtu technické reference prostřednictvím webového serveru Calibre.
{{< gallery match="images/1/*.png" >}}
Všechny síťové služby komunikují šifrovaně a jsou zabezpečeny prostřednictvím centrální správy uživatelů. Dnes ukážu, jak jsem zabezpečil svou službu Calibre pomocí šifrování SSL, protokolování přístupu a omezení přístupu LDAP. Pro tento výukový program jsou nutné předchozí znalosti z "[Skvělé věci s Atlassianem: Použití všech nástrojů Atlassian s LDAP]({{< ref "post/2021/march/20210321-atlassian-ldap" >}} "Skvělé věci s Atlassianem: Použití všech nástrojů Atlassian s LDAP")" a "[Skvělé věci s kontejnery: Spouštění Calibre pomocí Docker Compose]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Skvělé věci s kontejnery: Spouštění Calibre pomocí Docker Compose")".
## Můj server LDAP
Jak jsem již psal, v kontejneru Docker provozuji centrální server openLDAP. Vytvořil jsem také několik skupin aplikací.
{{< gallery match="images/2/*.png" >}}

## Zabezpečení nezabezpečené aplikace pomocí reverzního proxy serveru
Protože obraz Docker "linuxserver/calibre-web" nepodporuje šifrování SSL a LDAP, vytvořím virtuální síť s názvem "calibreweb" a před server Calibre umístím reverzní proxy server NGINX. Takto vypadá můj soubor Docker Compose. Všechny budoucí protokoly o přístupu jsou uloženy v adresáři log a moje certifikáty podepsané vlastním podpisem jsou v adresáři certs.
```
version: '3.7'
services:
  nginx: 
    image:  weseek/nginx-auth-ldap:1.13.9-1-alpine
    container_name: calibre-nginx
    environment:
    - 'TZ=Europe/Berlin'
    volumes:
      - ./default.conf:/etc/nginx/conf.d/default.conf
      - ./certs:/etc/certs
      - ./logs:/var/log/nginx
    ports:
      - 8443:443
    networks:
      - calibreweb
    restart: unless-stopped

  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web
    environment:
      - PUID=.....
      - PGID=....
      - TZ=Europe/Berlin
    volumes:
      - /volume/docker/calibre/app.db:/app/calibre-web/app.db
      - /volume/Buecher:/books
    expose:
      - 8083
    restart: unless-stopped
    networks:
      - calibreweb

networks:
  calibreweb:

```
Další užitečné obrazy Docker pro domácí použití najdete v [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Konfigurace Nginx
Soubor "default.conf" obsahuje všechny konfigurace LDAP a šifrování. Samozřejmě je třeba upravit adresu URL, binddn, certifikáty, porty a heslo a skupinu.
```
# ldap auth configuration
auth_ldap_cache_enabled on;
auth_ldap_cache_expiration_time 10000;
auth_ldap_cache_size 1000;
ldap_server ldap1 {
    url ldaps://ldap.server.local:636/dc=homelab,dc=local?uid?sub?(&(objectClass=inetorgperson));

    binddn "cn=root oder so,dc=homelab,dc=local";
    binddn_passwd "password";
    connect_timeout 5s;
    bind_timeout 5s;
    request_timeout 5s;
    ssl_check_cert: off;
    group_attribute memberUid;
    group_attribute_is_dn off;
    require group "cn=APP-Bibliothek,ou=Groups,dc=homelab,dc=local";
    require valid_user;
}

server {
    listen              443 ssl;
    server_name  localhost;

    ssl_certificate /etc/certs/fullchain.pem;
    ssl_certificate_key /etc/certs/privkey.pem;
    #weitere SSL-Einstellungen

    location / {
        auth_ldap "LDAP-ONLY";
        auth_ldap_servers ldap1;

        proxy_set_header        Host            $http_host;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header        X-Scheme        $scheme;
        proxy_pass  http://calibre-web:8083; #<- docker expose port
    }
}


```
Pokud nyní spustíte nastavení příkazem "docker-compose -f ...etc... up", uvidíte v protokolu přístupů také přístupy přihlášených uživatelů:
{{< gallery match="images/3/*.png" >}}
Vzhledem k tomu, že uživatelé LDAP jsou pouze hostujícími uživateli, musí být v Calibrewebu nastavena práva hostujících uživatelů:
{{< gallery match="images/4/*.png" >}}
Toto nastavení používám pro následující služby:* Videotéka (Peertube)* Knihovna (Calibreweb)* Gitlab (CE nepodporuje skupiny, takže se musíte přihlásit 2x).
