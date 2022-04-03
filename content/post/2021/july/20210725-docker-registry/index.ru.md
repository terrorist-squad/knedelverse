+++
date = "2021-07-25"
title = "Великие вещи с контейнерами: реестр Docker с пользовательским интерфейсом"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "registry", "images", "ui", "interface"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/july/20210725-docker-registry/index.ru.md"
+++
Узнайте, как сделать образы Docker доступными для всей сети через собственный реестр.
## Установка
Я создаю новый каталог под названием "docker-registry" на своем сервере:
{{< terminal >}}
mkdir docker-registry

{{</ terminal >}}
Затем я захожу в каталог docker-registry ("cd docker-registry") и создаю новый файл под названием "registry.yml" со следующим содержимым:
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
Более полезные образы Docker для домашнего использования можно найти в [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Команда запуска
Этот файл запускается через Docker Compose. После этого установка становится доступной в указанном домене/порту.
{{< terminal >}}
docker-compose -f registry.yml up -d

{{</ terminal >}}
После этого собственный реестр можно использовать с целевым IP и портом контейнера UI.
{{< gallery match="images/1/*.png" >}}
Теперь я могу создавать, продвигать и заполнять изображения из своего реестра:
{{< terminal >}}
docker build -t 192.168.178.61:5000/mein-image:version .
docker push 192.168.178.61:5000/mein-image:version
docker pull 192.168.178.61:5000/mein-image:version

{{</ terminal >}}

