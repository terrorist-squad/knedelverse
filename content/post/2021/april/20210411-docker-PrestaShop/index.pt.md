+++
date = "2021-04-11"
title = "Criativo para sair da crise: webshop profissional com PrestaShop"
difficulty = "level-4"
tags = ["corona", "Docker", "docker-compose", "kreativ", "krise", "online-shop", "presta", "shop", "shopsystem"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210411-docker-PrestaShop/index.pt.md"
+++
PrestaShop é uma plataforma europeia de comércio electrónico de código aberto com, segundo as suas próprias informações, actualmente mais de 300.000 instalações. Hoje eu estou instalando este software PHP no meu servidor. Alguns conhecimentos de Linux, Docker e Docker Compose são necessários para este tutorial.
## Passo 1: Instalar a PrestaShop
Eu crio um novo diretório chamado "prestashop" no meu servidor:
{{< terminal >}}
mkdir prestashop
cd prestashop

{{</ terminal >}}
Então eu vou para o diretório da prestashop e crio um novo arquivo chamado "prestashop.yml" com o seguinte conteúdo.
```
version: '2'

services:
  mariadb:
    image: mysql:5.7
    environment:
      - MYSQL_ROOT_PASSWORD=admin
      - MYSQL_DATABASE=prestashop
      - MYSQL_USER=prestashop
      - MYSQL_PASSWORD=prestashop
    volumes:
      - ./mysql:/var/lib/mysql
    expose:
      - 3306
    networks:
      - shop-network
    restart: always

  prestashop:
    image: prestashop/prestashop:1.7.7.2
    ports:
      - 8090:80
    depends_on:
      - mariadb
    volumes:
      - ./prestadata:/var/www/html
      - ./prestadata/modules:/var/www/html/modules
      - ./prestadata/themes:/var/www/html/themes
      - ./prestadata/override:/var/www/html/override
    environment:
      - PS_INSTALL_AUTO=0
    networks:
      - shop-network
    restart: always

networks:
  shop-network:

```
Infelizmente, a última versão actual não funcionou para mim, por isso instalei a versão "1.7.7.2". Este ficheiro é iniciado através do Docker Compose:
{{< terminal >}}
docker-compose -f prestashop.yml up

{{</ terminal >}}
É melhor tomar um café fresco, porque o processo leva muito tempo. A interface só pode ser usada quando aparecer o seguinte texto.
{{< gallery match="images/1/*.png" >}}
Eu posso então chamar o meu servidor PrestaShop e continuar a instalação através da interface.
{{< gallery match="images/2/*.png" >}}
Termino Docker-Compose com "Ctrl C" e abro a subpasta "prestadata" ("cd prestadata"). Lá, a pasta "install" deve ser apagada com "rm -r install".
{{< gallery match="images/3/*.png" >}}
Além disso, existe uma pasta "Admin", no meu caso "admin697vqoryt". Lembro-me desta abreviatura para mais tarde e reiniciar o servidor através do Docker Compose:
{{< terminal >}}
docker-compose -f prestashop.yml up -d

{{</ terminal >}}

## Passo 2: Teste a loja
Após o reinício, testei a instalação da minha loja Presta e também chamo a interface de administração em "shop-url/admin shortcuts".
{{< gallery match="images/4/*.png" >}}
