+++
date = "2021-07-25"
title = "Grandes coisas com containers: Docker Registry com UI"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "registry", "images", "ui", "interface"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/july/20210725-docker-registry/index.pt.md"
+++
Saiba como disponibilizar as suas imagens Docker em toda a rede através do seu próprio registo.
## Instalação
Eu crio um novo diretório chamado "docker-registry" no meu servidor:
{{< terminal >}}
mkdir docker-registry

{{</ terminal >}}
Então eu vou para o diretório docker-registry ("cd docker-registry") e crio um novo arquivo chamado "registry.yml" com o seguinte conteúdo:
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
Imagens mais úteis do Docker para uso doméstico podem ser encontradas no [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## O comando de arranque
Este ficheiro é iniciado através do Docker Compose. Em seguida, a instalação é acessível sob o domínio/porto pretendido.
{{< terminal >}}
docker-compose -f registry.yml up -d

{{</ terminal >}}
Em seguida, o próprio registro pode ser usado com o IP de destino e porta do contêiner UI.
{{< gallery match="images/1/*.png" >}}
Agora eu posso construir, empurrar e povoar imagens do meu registro:
{{< terminal >}}
docker build -t 192.168.178.61:5000/mein-image:version .
docker push 192.168.178.61:5000/mein-image:version
docker pull 192.168.178.61:5000/mein-image:version

{{</ terminal >}}
