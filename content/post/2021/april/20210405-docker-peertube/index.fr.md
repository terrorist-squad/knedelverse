+++
date = "2021-04-05"
title = "De grandes choses avec les conteneurs : un portail vidéo personnel avec PeerTube"
difficulty = "level-1"
tags = ["diskstation", "peertube", "Synology", "video", "videoportal"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210405-docker-peertube/index.fr.md"
+++
Peertube permet de créer son propre portail vidéo. Aujourd'hui, je montre comment j'ai installé Peertube sur mon disque dur Synology.
## Étape 1 : Préparer Synology
La première chose à faire est d'activer le login SSH sur le Diskstation. Pour cela, il faut aller dans le "Panneau de configuration" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Ensuite, on peut se connecter via "SSH", le port indiqué et le mot de passe de l'administrateur.
{{< gallery match="images/2/*.png" >}}
Je me connecte via Terminal, winSCP ou Putty et je laisse cette console ouverte pour plus tard.
## Étape 2 : Préparer le dossier Docker
Je crée un nouveau répertoire appelé "Peertube" dans le répertoire Docker.
{{< gallery match="images/3/*.png" >}}
Ensuite, je vais dans le répertoire Peertube et j'y crée un nouveau fichier appelé "peertube.yml" avec le contenu suivant. Pour le port, la partie avant "9000 :" peut être adaptée. Le deuxième volume contient toutes les vidéos, la liste de lecture, les vignettes, etc... et doit donc être adapté.
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
Ce fichier est lancé via Docker-Compose :
{{< terminal >}}
sudo docker-compose -f compose-file-name.yml up -d

{{</ terminal >}}
Ensuite, je peux appeler mon serveur Peertube avec l'IP de la station de disques et le port attribué à l'"étape 2". Génial !
{{< gallery match="images/4/*.png" >}}
Le nom d'utilisateur est "root" et le mot de passe est "password" (ou étape 2 / PT_INITIAL_ROOT_PASSWORD).
## Personnalisation du thème
Adapter l'apparence de Peertube est un jeu d'enfant. Pour cela, je clique sur "Administration" > "Paramètres" et "Paramètres avancés".
{{< gallery match="images/5/*.png" >}}
J'y ai inscrit ce qui suit dans le champ CSS :
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

## API Rest
PeerTube dispose d'une API Rest complète et bien documentée : https://docs.joinpeertube.org/api-rest-reference.html.
{{< gallery match="images/6/*.png" >}}
La recherche de vidéos est possible avec cette commande :
{{< terminal >}}
curl -s "http://pree-tube/api/v1search/videos?search=docker&languageOneOf=de"

{{</ terminal >}}
Pour un téléchargement, une authentification et un jeton de session sont nécessaires, par exemple :
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

## Mon conseil : Lire "De grandes choses avec les conteneurs : sécuriser les services Docker avec LDAP et NGINX".
Je fais fonctionner mon Peertube avec un reverse proxy. Cela signifie que seuls les utilisateurs LDAP peuvent accéder à ce service. J'ai documenté cette configuration sous "[De grandes choses avec les conteneurs : sécuriser les services Docker avec LDAP et NGINX]({{< ref "post/2021/april/20210402-nginx-reverse-proxy" >}} "De grandes choses avec les conteneurs : sécuriser les services Docker avec LDAP et NGINX")".
