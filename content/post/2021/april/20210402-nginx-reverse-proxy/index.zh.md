+++
date = "2021-04-02"
title = "容器的伟大之处：用LDAP和NGINX使Docker服务更安全"
difficulty = "level-1"
tags = ["calibre", "calibre-web", "ldap", "logging", "nutzerverwaltung", "peertube", "ssl"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210402-nginx-reverse-proxy/index.zh.md"
+++
作为Synology Diskstation的用户，我在我的Homelab网络上运行许多服务。我在Gitlab中部署软件，在Confluence中记录知识，通过Calibre网络服务器阅读技术参考资料。
{{< gallery match="images/1/*.png" >}}
所有的网络服务都是加密的，并通过中央用户管理来保证安全。 今天我展示了我是如何通过SSL加密、访问记录和LDAP访问限制来保证我的Calibre服务的。本教程需要有 "[阿特拉斯公司的酷事：用LDAP使用所有阿特拉斯工具]({{< ref "post/2021/march/20210321-atlassian-ldap" >}} "阿特拉斯公司的酷事：用LDAP使用所有阿特拉斯工具") "和 "[容器的伟大之处：用Docker Compose运行Calibre]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "容器的伟大之处：用Docker Compose运行Calibre") "的预先知识。
## 我的LDAP服务器
正如我已经写过的，我在Docker容器中运行一个中央openLDAP服务器。我还创建了几个应用组。
{{< gallery match="images/2/*.png" >}}

## 用反向代理确保不安全的应用程序
由于 "linuxserver/calibre-web "Docker镜像不支持SSL加密和LDAP，我创建了一个名为 "calibreweb "的虚拟网络，并在Calibre服务器前放置了一个NGINX反向代理。 这就是我的Docker Compose文件的样子。所有未来的访问日志都存储在日志目录中，我的自签名证书在certs目录中。
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
更多有用的家庭使用的Docker镜像可以在[洛克王国（Dockerverse）]({{< ref "dockerverse" >}} "洛克王国（Dockerverse）")中找到。
## Nginx配置
default.conf "文件包含所有LDAP和加密配置。当然，必须调整URL、binddn、证书、端口以及密码和组。
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
如果你现在用 "docker-compose -f ...etc... up "启动设置，你也可以在访问日志中看到登录用户的访问情况。
{{< gallery match="images/3/*.png" >}}
由于LDAP用户只是访客用户，所以必须在Calibreweb中设置访客用户权限。
{{< gallery match="images/4/*.png" >}}
我为以下服务运行这个设置：* 视频库（Peertube）* 图书馆（Calibreweb）* Gitlab（CE不支持组，所以你必须登录2次）。
