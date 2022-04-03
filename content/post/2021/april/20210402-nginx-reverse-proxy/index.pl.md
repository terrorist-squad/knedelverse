+++
date = "2021-04-02"
title = "Wspaniałe rzeczy z kontenerami: zwiększanie bezpieczeństwa usług Dockera za pomocą LDAP i NGINX"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ldap", "logging", "nutzerverwaltung", "peertube", "ssl"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210402-nginx-reverse-proxy/index.pl.md"
+++
Jako użytkownik stacji Synology Diskstation uruchamiam wiele usług w mojej sieci domowej. Wdrażam oprogramowanie w Gitlabie, dokumentuję wiedzę w Confluence i czytam referencje techniczne za pomocą serwera internetowego Calibre.
{{< gallery match="images/1/*.png" >}}
Wszystkie usługi sieciowe komunikują się w sposób zaszyfrowany i są zabezpieczone za pomocą centralnej administracji użytkownikami. Dzisiaj pokażę, jak zabezpieczyłem usługę Calibre za pomocą szyfrowania SSL, rejestrowania dostępu i ograniczenia dostępu do LDAP. Do pracy w tym samouczku wymagana jest wcześniejsza wiedza z zakresu "[Fajne rzeczy z Atlassian: Używanie wszystkich narzędzi Atlassian za pomocą LDAP]({{< ref "post/2021/march/20210321-atlassian-ldap" >}} "Fajne rzeczy z Atlassian: Używanie wszystkich narzędzi Atlassian za pomocą LDAP")" i "[Wielkie rzeczy z kontenerami: Uruchamianie Calibre za pomocą Docker Compose]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Wielkie rzeczy z kontenerami: Uruchamianie Calibre za pomocą Docker Compose")".
## Mój serwer LDAP
Jak już pisałem, w kontenerze Docker uruchamiam centralny serwer openLDAP. Utworzyłem także kilka grup aplikacji.
{{< gallery match="images/2/*.png" >}}

## Zabezpiecz niezabezpieczoną aplikację za pomocą odwrotnego serwera proxy
Ponieważ obraz Dockera "linuxserver/calibre-web" nie obsługuje szyfrowania SSL i LDAP, tworzę sieć wirtualną o nazwie "calibreweb" i umieszczam przed serwerem Calibre odwrotne proxy NGINX. Tak wygląda mój plik Docker Compose. Wszystkie przyszłe dzienniki dostępu są przechowywane w katalogu log, a moje samopodpisane certyfikaty znajdują się w katalogu certs.
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
Więcej przydatnych obrazów Dockera do użytku domowego można znaleźć w sekcji [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Konfiguracja Nginx
Plik "default.conf" zawiera wszystkie konfiguracje protokołu LDAP i szyfrowania. Oczywiście należy dostosować adres URL, binddn, certyfikaty, porty oraz hasło i grupę.
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
Jeśli teraz uruchomisz konfigurację za pomocą polecenia "docker-compose -f ...etc... up", w dzienniku dostępu zobaczysz również dostęp zalogowanych użytkowników:
{{< gallery match="images/3/*.png" >}}
Ponieważ użytkownicy LDAP są tylko użytkownikami gościnnymi, w programie Calibreweb należy ustawić uprawnienia użytkowników gościnnych:
{{< gallery match="images/4/*.png" >}}
Używam tej konfiguracji dla następujących usług:* Biblioteka wideo (Peertube)* Biblioteka (Calibreweb)* Gitlab (CE nie obsługuje grup, więc trzeba się logować 2x)
