+++
date = "2021-03-24"
title = "Kort berättelse: Min Gitlab-inställning"
difficulty = "level-3"
tags = ["code", "development", "devops", "docker-compose", "git", "gitlab", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210324-Gitlab-setup/index.sv.md"
+++
Efter min första handledning i ämnet "Gitlab på Synology diskstation" har jag redan fått flera gånger frågan om jag fortfarande använder den här lösningen. Nej! Under tiden har jag flyttat mina Atlassian-verktyg och följande GitLab-installation till en Intel NUC. I bilagan visas min nuvarande Compose-fil, som naturligtvis också kan köras på en Synology-diskstation. Du kan tydligt se att jag nu använder särskilda inställningar för OpenLDAP, containerregistret, e-post, certifikat och loggning. Dessutom har wikifunktionen och funktionen för problemspårning inaktiverats eftersom jag använder Atlassian-Jira och Atlassian-Confluence. Som du kan se är Gitlab mycket anpassningsbart. Ha kul!
```
version: '2'
services:
  gitlab:
    image: 'gitlab/gitlab-ce:latest'
    restart: always
    container_name: 'gitlab_server_gitlab'
    environment:
      TZ: "Europe/Berlin"
      GITLAB_OMNIBUS_CONFIG: |
        gitlab_rails['time_zone'] = 'Europe/Berlin'
        external_url 'https://host:port' 
        registry_external_url 'https://host:registry_port'
        registry_nginx['listen_https'] = true
        nginx['redirect_http_to_https'] = true
        registry_nginx['redirect_http_to_https'] = true
        mattermost_nginx['redirect_http_to_https'] = true

        registry_nginx['ssl_certificate'] = "..server-cert.crt"
        registry_nginx['ssl_certificate_key'] = "...server-cert.key"
        gitlab_rails['gitlab_default_projects_features_issues'] = false


        gitlab_rails['gitlab_default_projects_features_container_registry'] = true


        postgresql['enable'] = false
        gitlab_rails['db_username'] = "****"
        gitlab_rails['db_password'] = "****"
        gitlab_rails['db_host'] = "postgresql"
        gitlab_rails['db_port'] = "5432"
        gitlab_rails['db_database'] = "gitlabhq_production"
        gitlab_rails['db_adapter'] = 'postgresql'
        gitlab_rails['db_encoding'] = 'utf8'

        redis['enable'] = false
        gitlab_rails['redis_host'] = 'redis'
        gitlab_rails['redis_port'] = '6379'

        gitlab_rails['gitlab_shell_ssh_port'] = 22
        # Limit backup lifetime to 7 days (604800 seconds):
        gitlab_rails['backup_keep_time'] = 604800


        unicorn['worker_timeout'] = 60
        unicorn['worker_processes'] = 3


        nginx['enable'] = true
        nginx['listen_port'] = 80
        nginx['client_max_body_size'] = '250m'

        nginx['listen_port'] = 443
        nginx['redirect_http_to_https'] = true

        nginx['ssl_certificate'] = '.../registry-certs/server-cert.crt'
        nginx['ssl_certificate_key'] = '..../registry-certs/server-cert.key'

        nginx['logrotate_frequency'] = "weekly"
        nginx['logrotate_rotate'] = 52
        nginx['logrotate_compress'] = "compress"
        nginx['logrotate_method'] = "copytruncate"
        nginx['logrotate_delaycompress'] = "delaycompress"


        gitlab_rails['smtp_enable'] = true
        gitlab_rails['smtp_address'] = "***.***.de"
        gitlab_rails['smtp_port'] = 465
        gitlab_rails['smtp_user_name'] = "***@365layouts.de"
        gitlab_rails['smtp_password'] = "*****"
        gitlab_rails['smtp_domain'] = "****.****.de"
        gitlab_rails['smtp_authentication'] = "login"
        gitlab_rails['smtp_enable_starttls_auto'] = true
        gitlab_rails['smtp_tls'] = true
        gitlab_rails['gitlab_email_from'] = 'gitlab-homelab@365layouts.de'
        gitlab_rails['gitlab_email_reply_to'] = 'c.knedel@365layouts.de'

        gitlab_rails['gitlab_email_display_name'] = 'GitLab - 365 company'

     
        gitlab_rails['ldap_enabled'] = true
        gitlab_rails['prevent_ldap_sign_in'] = false

        gitlab_rails['ldap_servers'] = YAML.load <<-'EOS'
          main:
            label: 'Homelab LDAP'
            host: 'ldap-host'
            port: 636
            uid: 'uid'
            bind_dn: 'cn=admin,dc=homelab,dc=local'
            password: '*****'
            encryption: 'simple_tls'
            verify_certificates: false
            smartcard_auth: false
            active_directory: false
            allow_username_or_email_login: false
            lowercase_usernames: false
            block_auto_created_users: false
            base: 'dc=homelab,dc=local'
            attributes:
              username: ['uid']
              email: ['mail']
              name: 'displayName'
              first_name: 'givenName'
              last_name: 'sn'
        EOS

    ports:
    - "4567:4567"
    - "30080:80"
    - '30443:443'
    - "30022:22"
    volumes:
    - /****/server-gitlab/config:/etc/gitlab:rw
    - /****/server-gitlab/logs:/var/log/gitlab:rw
    - /****/server-gitlab/data:/var/opt/gitlab:rw
    - /****/server-gitlab/registry/data:/var/opt/gitlab/gitlab-rails/shared/registry
    - /****/server-gitlab/registry-certs:/etc/gitlab/registry-certs:rw
    networks:
      - gitlab  
    depends_on:
      - postgresql
      - redis
    logging:
      driver: "gelf"
      options:
        gelf-address: "udp://****:12201"
        tag: "gitlab"

  postgresql:
    container_name: 'gitlab_server_postgresql'
    restart: always
    image: postgres:latest
    environment:
    - POSTGRES_USER=****
    - POSTGRES_PASSWORD=****
    - POSTGRES_DB=gitlabhq_production
    volumes:
    - /docker/server-gitlab/postgresql:/var/lib/postgresql/data
    networks:
      - gitlab  
    expose:
      - "5432"
    logging:
      driver: "gelf"
      options:
        gelf-address: "udp://***:12201"
        tag: "gitlab"

  redis:
    container_name: 'gitlab_server_redis'
    restart: always
    image: redis:latest
    networks:
      - gitlab  
    expose:
      - "6379"
    logging:
      driver: "gelf"
      options:
        gelf-address: "udp://****:12201"
        tag: "gitlab"

networks:
  gitlab:

```
