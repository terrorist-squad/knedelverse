+++
date = "2021-04-05"
title = "Wielkie rzeczy z kontenerów: własny portal wideo z PeerTube"
difficulty = "level-1"
tags = ["diskstation", "peertube", "Synology", "video", "videoportal"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210405-docker-peertube/index.pl.md"
+++
Dzięki Peertube możesz stworzyć swój własny portal wideo. Dziś pokażę, jak zainstalowałem Peertube na stacji dysków Synology.
## Krok 1: Przygotuj Synology
Najpierw należy aktywować logowanie SSH na serwerze DiskStation. W tym celu należy przejść do "Panelu sterowania" > "Terminal
{{< gallery match="images/1/*.png" >}}
Następnie można zalogować się przez "SSH", podając określony port i hasło administratora.
{{< gallery match="images/2/*.png" >}}
Loguję się za pomocą Terminala, winSCP lub Putty i zostawiam tę konsolę otwartą na później.
## Krok 2: Przygotuj folder Docker
W katalogu Docker tworzę nowy katalog o nazwie "Peertube".
{{< gallery match="images/3/*.png" >}}
Następnie wchodzę do katalogu Peertube i tworzę nowy plik o nazwie "peertube.yml" o następującej zawartości. W przypadku portu można wyregulować przednią część "9000:". Drugi tom zawiera wszystkie filmy, listy odtwarzania, miniatury itp. i dlatego musi zostać dostosowany.
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
Ten plik jest uruchamiany za pomocą aplikacji Docker Compose:
{{< terminal >}}
sudo docker-compose -f compose-file-name.yml up -d

{{</ terminal >}}
Następnie mogę wywołać mój serwer Peertube, podając adres IP stacji dysków i przypisany port z "Kroku 2". Świetnie!
{{< gallery match="images/4/*.png" >}}
Nazwa użytkownika to "root", a hasło to "password" (lub krok 2 / PT_INITIAL_ROOT_PASSWORD).
## Dostosowanie motywu
Wygląd Peertube można bardzo łatwo dostosować do własnych potrzeb. W tym celu należy kliknąć kolejno opcje "Administracja" > "Ustawienia" i "Ustawienia zaawansowane".
{{< gallery match="images/5/*.png" >}}
W polu CSS wpisałem następujące dane:
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

## Rest API
PeerTube ma rozbudowany i dobrze udokumentowany interfejs API: https://docs.joinpeertube.org/api-rest-reference.html.
{{< gallery match="images/6/*.png" >}}
Za pomocą tego polecenia można wyszukiwać filmy:
{{< terminal >}}
curl -s "http://pree-tube/api/v1search/videos?search=docker&languageOneOf=de"

{{</ terminal >}}
Uwierzytelnienie i token sesji są wymagane na przykład przy wysyłaniu danych:
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

## Moja rada: Przeczytaj "Wspaniałe rzeczy z kontenerami: zwiększanie bezpieczeństwa usług Dockera za pomocą LDAP i NGINX".
W moim Peertube korzystam z odwrotnego proxy. Oznacza to, że dostęp do tej usługi mają tylko użytkownicy LDAP. Udokumentowałem tę konfigurację w punkcie "[Wspaniałe rzeczy z kontenerami: zwiększanie bezpieczeństwa usług Dockera za pomocą LDAP i NGINX]({{< ref "post/2021/april/20210402-nginx-reverse-proxy" >}} "Wspaniałe rzeczy z kontenerami: zwiększanie bezpieczeństwa usług Dockera za pomocą LDAP i NGINX")".
