+++
date = "2021-07-25"
title = "Great things with containers: Docker Registry with UI"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "registry", "images", "ui", "interface"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/july/20210725-docker-registry/index.en.md"
+++
Learn how to make your Docker images available network-wide via a custom registry.
## Installation
I create a new directory called "docker-registry" on my server:
{{< terminal >}}
mkdir docker-registry

{{</ terminal >}}
After that I go to the docker-registry directory ("cd docker-registry") and create a new file named "registry.yml" with the following content:
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
More useful Docker images for home use can be found in the [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## The start command
This file is started via Docker Compose. After that, the installation is accessible under the intended domain/port.
{{< terminal >}}
docker-compose -f registry.yml up -d

{{</ terminal >}}
After that, you can use your own registry with the target IP and port of the UI container.
{{< gallery match="images/1/*.png" >}}
Now I can build, push and pop images from my registry:
{{< terminal >}}
docker build -t 192.168.178.61:5000/mein-image:version .
docker push 192.168.178.61:5000/mein-image:version
docker pull 192.168.178.61:5000/mein-image:version

{{</ terminal >}}
