+++
date = "2021-04-25T09:28:11+01:00"
title = "Grandes coisas com recipientes: Netbox on Synology - Diskstation"
difficulty = "level-3"
tags = ["Computernetzwerken", "DCIM", "Docker", "docker-compose", "IPAM", "netbox", "Synology", "netwerk"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Netbox/index.pt.md"
+++
O NetBox é um software gratuito utilizado para a gestão de redes de computadores. Hoje eu mostro como instalar um serviço Netbox no Synology DiskStation.
## Passo 1: Preparar a Sinologia
Primeiro, o login do SSH deve ser ativado no DiskStation. Para fazer isso, vá para o "Painel de Controle" > "Terminal
{{< gallery match="images/1/*.png" >}}
Então você pode entrar via "SSH", a porta especificada e a senha do administrador (usuários do Windows usam Putty ou WinSCP).
{{< gallery match="images/2/*.png" >}}
Eu inicio sessão via Terminal, winSCP ou Putty e deixo esta consola aberta para mais tarde.
## Passo 2: Criar pasta NETBOX
Eu crio um novo diretório chamado "netbox" no diretório Docker.
{{< gallery match="images/3/*.png" >}}
Agora o seguinte arquivo deve ser baixado e descompactado no diretório: https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip. Eu uso a consola para isto:
{{< terminal >}}
cd /volume1/docker/netbox/
sudo wget https://github.com/netbox-community/netbox-docker/archive/refs/heads/release.zip
sudo /bin/7z x release.zip
cd netbox-docker-release
sudo mkdir netbox-media-files
sudo mkdir netbox-redis-data
sudo mkdir netbox-postgres-data

{{</ terminal >}}
Depois edito o ficheiro "docker/docker-compose.yml" e introduzo os meus endereços Synology em "netbox-media-files", "netbox-postgres-data" e "netbox-redis-data":
```
version: '3.4'
services:
  netbox: 
    image: netboxcommunity/netbox:${VERSION-v3.1-1.6.0}
    depends_on:
    - postgres
    - redis
    - redis-cache
    - netbox-worker
    env_file: env/netbox.env
    user: 'unit:root'
    volumes:
    - ./startup_scripts:/opt/netbox/startup_scripts:z,ro
    - ./initializers:/opt/netbox/initializers:z,ro
    - ./configuration:/etc/netbox/config:z,ro
    - ./reports:/etc/netbox/reports:z,ro
    - ./scripts:/etc/netbox/scripts:z,ro
    - ./netbox-media-files:/opt/netbox/netbox/media:z
    ports:
    - "8097:8080"
    
  netbox-worker:
    image: netboxcommunity/netbox:${VERSION-v3.1-1.6.0}
    env_file: env/netbox.env
    user: 'unit:root'
    depends_on:
    - redis
    - postgres
    command:
    - /opt/netbox/venv/bin/python
    - /opt/netbox/netbox/manage.py
    - rqworker

  netbox-housekeeping:
    image: netboxcommunity/netbox:${VERSION-v3.1-1.6.0}
    env_file: env/netbox.env
    user: 'unit:root'
    depends_on:
    - redis
    - postgres
    command:
    - /opt/netbox/housekeeping.sh

  # postgres
  postgres:
    image: postgres:14-alpine
    env_file: env/postgres.env
    volumes:
    - ./netbox-postgres-data:/var/lib/postgresql/data

  # redis
  redis:
    image: redis:6-alpine
    command:
    - sh
    - -c # this is to evaluate the $REDIS_PASSWORD from the env
    - redis-server --appendonly yes --requirepass $$REDIS_PASSWORD ## $$ because of docker-compose
    env_file: env/redis.env
    volumes:
    - ./netbox-redis-data:/data

  redis-cache:
    image: redis:6-alpine
    command:
    - sh
    - -c # this is to evaluate the $REDIS_PASSWORD from the env
    - redis-server --requirepass $$REDIS_PASSWORD ## $$ because of docker-compose
    env_file: env/redis-cache.env


```
É muito importante que a herança "<<<: *netbox" é substituído e uma porta para "netbox" é introduzida. Depois disso, posso iniciar o ficheiro Compose:
{{< terminal >}}
sudo docker-compose up

{{</ terminal >}}
Pode demorar algum tempo a criar a base de dados. O comportamento pode ser observado através dos detalhes do recipiente.
{{< gallery match="images/4/*.png" >}}
Eu chamo o servidor netbox com o endereço IP Synology e minha porta de contêiner.
{{< gallery match="images/5/*.png" >}}
