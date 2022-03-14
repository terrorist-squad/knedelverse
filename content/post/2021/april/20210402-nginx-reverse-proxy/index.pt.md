+++
date = "2021-04-02"
title = "Grandes coisas com contentores: tornar os serviços Docker mais seguros com LDAP e NGINX"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ldap", "logging", "nutzerverwaltung", "peertube", "ssl"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210402-nginx-reverse-proxy/index.pt.md"
+++
Como usuário do Synology Diskstation, eu executo muitos serviços na minha rede Homelab. Eu implanto software no Gitlab, documento conhecimentos em Confluence e leio referências técnicas através do servidor web Calibre.
{{< gallery match="images/1/*.png" >}}
Todos os serviços de rede comunicam criptografados e são protegidos através de uma administração central de usuários. Hoje eu mostro como protegi meu serviço Calibre com criptografia SSL, registro de acesso e restrição de acesso LDAP. O conhecimento prévio de "[Coisas legais com Atlassian: Use todas as ferramentas Atlassian com LDAP]({{< ref "post/2021/march/20210321-atlassian-ldap" >}} "Coisas legais com Atlassian: Use todas as ferramentas Atlassian com LDAP")" e "[Grandes coisas com contentores: Calibre de funcionamento com Docker Compose]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Grandes coisas com contentores: Calibre de funcionamento com Docker Compose")" é necessário para este tutorial.
## O meu servidor LDAP
Como eu já escrevi, eu dirijo um servidor centralLDAP aberto no container do Docker. Eu também criei alguns grupos de aplicação.
{{< gallery match="images/2/*.png" >}}

## Aplicação segura e insegura com proxy reverso
Como a imagem Docker "linuxserver/calibre-web" não suporta criptografia SSL e LDAP, eu crio uma rede virtual chamada "calibreweb" e coloco um proxy reverso NGINX na frente do servidor Calibre. É assim que meu arquivo Docker Compose se parece. Todos os logs de acesso futuro são armazenados no diretório de log e meus certificados autoassinados estão no diretório de certs.
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
Imagens mais úteis do Docker para uso doméstico podem ser encontradas no [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Configuração Nginx
O arquivo "default.conf" contém todas as configurações de LDAP e criptografia. Naturalmente, o URL, binddn, certificados, portas e a senha e grupo devem ser ajustados.
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
Se você agora iniciar a configuração com "docker-compose -f ...etc... up", você também pode ver os acessos dos usuários logados no log de acesso:
{{< gallery match="images/3/*.png" >}}
Como os usuários LDAP são apenas usuários convidados, os direitos de usuário convidado devem ser definidos no Calibreweb:
{{< gallery match="images/4/*.png" >}}
