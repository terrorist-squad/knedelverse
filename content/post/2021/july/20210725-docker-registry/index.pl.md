+++
date = "2021-07-25"
title = "Wspaniałe rzeczy z kontenerami: Rejestr Dockera z UI"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "registry", "images", "ui", "interface"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/july/20210725-docker-registry/index.pl.md"
+++
Dowiedz się, jak udostępnić obrazy Dockera w całej sieci za pośrednictwem własnego rejestru.
## Instalacja
Na moim serwerze tworzę nowy katalog o nazwie "docker-registry":
{{< terminal >}}
mkdir docker-registry

{{</ terminal >}}
Następnie wchodzę do katalogu docker-registry ("cd docker-registry") i tworzę nowy plik o nazwie "registry.yml" o następującej zawartości:
```
version: '3'

services:
  registry:
    restart: always
    image: registry:2
    ports:
    - "5000:5000"
    environment:
      REGISTRY_STORAGE_FILESYSTEM_ROOTDIRECTORY: /data
    volumes:
      - ./data:/data
    networks:
      - registry-ui-net

  ui:
    restart: always
    image: joxit/docker-registry-ui:static
    ports:
      - 8080:80
    environment:
      - REGISTRY_TITLE=My Private Docker Registry
      - REGISTRY_URL=http://registry:5000
    depends_on:
      - registry
    networks:
      - registry-ui-net

networks:
  registry-ui-net:

```
Więcej przydatnych obrazów Dockera do użytku domowego można znaleźć w sekcji [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Polecenie start
Ten plik jest uruchamiany za pomocą aplikacji Docker Compose. Następnie instalacja jest dostępna pod przewidzianą domeną/portem.
{{< terminal >}}
docker-compose -f registry.yml up -d

{{</ terminal >}}
Następnie można użyć własnego rejestru z docelowym adresem IP i portem kontenera UI.
{{< gallery match="images/1/*.png" >}}
Teraz mogę budować, przesyłać i uzupełniać obrazy z mojego rejestru:
{{< terminal >}}
docker build -t 192.168.178.61:5000/mein-image:version .
docker push 192.168.178.61:5000/mein-image:version
docker pull 192.168.178.61:5000/mein-image:version

{{</ terminal >}}

