+++
date = "2021-07-25"
title = "Wspaniałe rzeczy z kontenerami: Rejestr Dockera z UI"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "registry", "images", "ui", "interface"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/july/20210725-docker-registry/index.pl.md"
+++
Dowiedz się, jak sprawić, by obrazy Dockera były dostępne w całej sieci za pośrednictwem własnego rejestru.
## Instalacja
Tworzę nowy katalog o nazwie "docker-registry" na moim serwerze:
{{< terminal >}}
mkdir docker-registry

{{</ terminal >}}
Następnie wchodzę do katalogu docker-registry ("cd docker-registry") i tworzę nowy plik o nazwie "registry.yml" z następującą zawartością:
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
Więcej przydatnych obrazów Dockera do użytku domowego można znaleźć w dziale [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Polecenie start
Ten plik jest uruchamiany za pomocą Docker Compose. Następnie instalacja jest dostępna pod przewidzianą domeną/portem.
{{< terminal >}}
docker-compose -f registry.yml up -d

{{</ terminal >}}
Następnie własny rejestr może być używany z docelowym IP i portem kontenera UI.
{{< gallery match="images/1/*.png" >}}
Teraz mogę budować, wypychać i uzupełniać obrazy z mojego rejestru:
{{< terminal >}}
docker build -t 192.168.178.61:5000/mein-image:version .
docker push 192.168.178.61:5000/mein-image:version
docker pull 192.168.178.61:5000/mein-image:version

{{</ terminal >}}
