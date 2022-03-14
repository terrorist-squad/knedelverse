+++
date = "2021-04-05"
title = "Grandes coisas com contentores: Portal de vídeo próprio com PeerTube"
difficulty = "level-1"
tags = ["diskstation", "peertube", "Synology", "video", "videoportal"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210405-docker-peertube/index.pt.md"
+++
Com Peertube você pode criar o seu próprio portal de vídeo. Hoje eu mostro como instalei o Peertube na minha estação de disco Synology.
## Passo 1: Preparar a Sinologia
Primeiro, o login SSH deve ser ativado no DiskStation. Para fazer isso, vá para o "Painel de Controle" > "Terminal
{{< gallery match="images/1/*.png" >}}
Então você pode entrar via "SSH", a porta especificada e a senha do administrador.
{{< gallery match="images/2/*.png" >}}
Eu inicio sessão via Terminal, winSCP ou Putty e deixo este console aberto para mais tarde.
## Passo 2: Preparar pasta Docker
Eu crio um novo diretório chamado "Peertube" no diretório Docker.
{{< gallery match="images/3/*.png" >}}
Então eu vou para o diretório Peertube e crio um novo arquivo chamado "peertube.yml" com o seguinte conteúdo. Para a porta, a parte frontal "9000:" pode ser ajustada. O segundo volume contém todos os vídeos, playlist, thumbnails, etc... e deve, portanto, ser adaptado.
```
version: "3.7"

services:
  peertube:
    image: chocobozzz/peertube:contain-buster
    container_name: peertube_peertube
    ports:
       - "9000:9000"
    volumes:
      - ./config:/config
      - ./videos:/data
    environment:
      - TZ="Europe/Berlin"
      - PT_INITIAL_ROOT_PASSWORD=password
      - PEERTUBE_WEBSERVER_HOSTNAME=ip
      - PEERTUBE_WEBSERVER_PORT=port
      - PEERTUBE_WEBSERVER_HTTPS=false
      - PEERTUBE_DB_USERNAME=peertube
      - PEERTUBE_DB_PASSWORD=peertube
      - PEERTUBE_DB_HOSTNAME=postgres
      - POSTGRES_DB=peertube
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
      - PEERTUBE_REDIS_HOSTNAME=redis
      - PEERTUBE_ADMIN_EMAIL=himself@christian-knedel.de
    depends_on:
      - postgres
      - redis
    restart: "always"
    networks:
      - peertube

  postgres:
    restart: always
    image: postgres:12
    container_name: peertube_postgres
    volumes:
      - ./postgresql:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=peertube
      - POSTGRES_PASSWORD=peertube
      - POSTGRES_DB=peertube
    networks:
      - peertube

  redis:
    image: redis:4-alpine
    container_name: peertube_redis
    volumes:
      - ./redis:/data
    restart: "always"
    networks:
      - peertube
    expose:
      - "6379"

networks:
  peertube:

```
Este arquivo é iniciado através do Docker Compose:
{{< terminal >}}
sudo docker-compose -f compose-file-name.yml up -d

{{</ terminal >}}
Depois disso, posso chamar o meu servidor Peertube com o IP da estação de disco e a porta atribuída a partir do "Passo 2". Ótimo!
{{< gallery match="images/4/*.png" >}}
O nome de usuário é "root" e a senha é "password" (ou passo 2 / PT_INITIAL_ROOT_PASSWORD).
## Personalização do tema
É muito fácil personalizar a aparência do Peertube. Para isso, clico em "Administração" > "Configurações" e "Configurações avançadas".
{{< gallery match="images/5/*.png" >}}
Aí eu entrei o seguinte no campo CSS:
```
body#custom-css {
--mainColor: #3598dc;
--mainHoverColor: #3598dc;
--mainBackgroundColor: #FAFAFA;
--mainForegroundColor: #888888;
--menuBackgroundColor: #f5f5f5;
--menuForegroundColor: #888888;
--submenuColor: #fff;
--inputColor: #fff;
--inputPlaceholderColor: #898989;
}

```

## Descanso API
O PeerTube tem uma API de repouso extensa e bem documentada: https://docs.joinpeertube.org/api-rest-reference.html.
{{< gallery match="images/6/*.png" >}}
A pesquisa de vídeos é possível com este comando:
{{< terminal >}}
curl -s "http://pree-tube/api/v1search/videos?search=docker&languageOneOf=de"

{{</ terminal >}}
A autenticação e um token de sessão são necessários para um upload, por exemplo:
```
#!/bin/bash
USERNAME="user"
PASSWORD="password"
API_PATH="http://peertube-adresse/api/v1"

client_id=$(curl -s "$API_PATH/oauth-clients/local" | jq -r ".client_id")
client_secret=$(curl -s "$API_PATH/oauth-clients/local" | jq -r ".client_secret")
token=$(curl -s "$API_PATH/users/token" \
  --data client_id="$client_id" \
  --data client_secret="$client_secret" \
  --data grant_type=password \
  --data response_type=code \
  --data username="$USERNAME" \
  --data password="$PASSWORD" \
  | jq -r ".access_token")

curl -s '$API_PATH/videos/upload'-H 'Authorization: Bearer $token' --max-time 11600 --form videofile=@'/scripte/output.mp4' --form name='mein upload' 

```

## A minha dica: Leia "Grandes coisas com contentores: tornar os serviços Docker mais seguros com LDAP e NGINX".
