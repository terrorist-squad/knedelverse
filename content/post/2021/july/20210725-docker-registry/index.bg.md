+++
date = "2021-07-25"
title = "Страхотни неща с контейнери: Регистър на Docker с потребителски интерфейс"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "registry", "images", "ui", "interface"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/july/20210725-docker-registry/index.bg.md"
+++
Научете как да направите образите си на Docker достъпни в цялата мрежа чрез собствен регистър.
## Инсталация
Създавам нова директория, наречена "docker-registry", на моя сървър:
{{< terminal >}}
mkdir docker-registry

{{</ terminal >}}
След това влизам в директорията docker-registry ("cd docker-registry") и създавам нов файл, наречен "registry.yml", със следното съдържание:
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
Още полезни образи на Docker за домашна употреба можете да намерите в [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Командата за стартиране
Този файл се стартира чрез Docker Compose. След това инсталацията е достъпна в предвидения домейн/порт.
{{< terminal >}}
docker-compose -f registry.yml up -d

{{</ terminal >}}
След това собственият регистър може да се използва с целевия IP адрес и порт на контейнера на потребителския интерфейс.
{{< gallery match="images/1/*.png" >}}
Сега мога да изграждам, изтласквам и попълвам изображения от моя регистър:
{{< terminal >}}
docker build -t 192.168.178.61:5000/mein-image:version .
docker push 192.168.178.61:5000/mein-image:version
docker pull 192.168.178.61:5000/mein-image:version

{{</ terminal >}}
