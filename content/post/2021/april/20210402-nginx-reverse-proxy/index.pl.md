+++
date = "2021-04-02"
title = "Wielkie rzeczy z kontenerami: zwiększanie bezpieczeństwa usług Dockera za pomocą LDAP i NGINX"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ldap", "logging", "nutzerverwaltung", "peertube", "ssl"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210402-nginx-reverse-proxy/index.pl.md"
+++
Jako użytkownik stacji Synology Diskstation uruchamiam wiele usług w mojej sieci domowej. Wdrażam oprogramowanie w Gitlabie, dokumentuję wiedzę w Confluence i czytam techniczne referencje za pomocą serwera Calibre.
{{< gallery match="images/1/*.png" >}}
Wszystkie usługi sieciowe komunikują się szyfrowanie i są zabezpieczone poprzez centralną administrację użytkownikami. Dzisiaj pokażę jak zabezpieczyłem moją usługę Calibre poprzez szyfrowanie SSL, logowanie dostępu i ograniczenie dostępu do LDAP. W tym tutorialu wymagana jest wcześniejsza wiedza z "[Fajne rzeczy z Atlassian: Używaj wszystkich narzędzi Atlassian z LDAP]({{< ref "post/2021/march/20210321-atlassian-ldap" >}} "Fajne rzeczy z Atlassian: Używaj wszystkich narzędzi Atlassian z LDAP")" i "[Wielkie rzeczy z kontenerami: Uruchamianie Calibre z Docker Compose]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Wielkie rzeczy z kontenerami: Uruchamianie Calibre z Docker Compose")".
## Mój serwer LDAP
Jak już pisałem, w kontenerze Docker uruchamiam centralny serwer openLDAP. Utworzyłem również kilka grup aplikacji.
{{< gallery match="images/2/*.png" >}}

## Zabezpiecz niezabezpieczoną aplikację za pomocą reverse proxy
Ponieważ obraz Dockera "linuxserver/calibre-web" nie obsługuje szyfrowania SSL i LDAP, tworzę wirtualną sieć o nazwie "calibreweb" i umieszczam odwrotne proxy NGINX przed serwerem Calibre. Tak wygląda mój plik Docker Compose. Wszystkie przyszłe logi dostępu są przechowywane w katalogu log, a moje samopodpisane certyfikaty są w katalogu certs.
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
Więcej przydatnych obrazów Dockera do użytku domowego można znaleźć w dziale [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Konfiguracja Nginx
Plik "default.conf" zawiera wszystkie konfiguracje LDAP i szyfrowania. Oczywiście adres URL, binddn, certyfikaty, porty oraz hasło i grupa muszą być dostosowane.
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
Jeśli teraz uruchomisz konfigurację za pomocą "docker-compose -f ...etc... up", możesz również zobaczyć dostęp zalogowanych użytkowników w dzienniku dostępu:
{{< gallery match="images/3/*.png" >}}
Ponieważ użytkownicy LDAP są tylko użytkownikami gościnnymi, prawa użytkowników gościnnych muszą być ustawione w Calibreweb:
{{< gallery match="images/4/*.png" >}}
