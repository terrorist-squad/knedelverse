+++
date = "2021-04-11"
title = "摆脱危机的创意：使用PrestaShop的专业网店"
difficulty = "level-4"
tags = ["corona", "Docker", "docker-compose", "kreativ", "krise", "online-shop", "presta", "shop", "shopsystem"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210411-docker-PrestaShop/index.zh.md"
+++
PrestaShop是一个欧洲的开源电子商务平台，根据它自己的信息，目前有超过300,000个安装。今天我在我的服务器上安装这个PHP软件。本教程需要一些Linux、Docker和Docker Compose知识。
## 第1步：安装PrestaShop
我在我的服务器上创建了一个名为 "prestashop "的新目录。
{{< terminal >}}
mkdir prestashop
cd prestashop

{{</ terminal >}}
然后我进入prestashop目录，创建一个新文件，名为 "prestashop.yml"，内容如下。
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
不幸的是，目前的最新版本对我不起作用，所以我安装了 "1.7.7.2 "版本。这个文件是通过Docker Compose启动的。
{{< terminal >}}
docker-compose -f prestashop.yml up

{{</ terminal >}}
最好是得到新鲜的咖啡，因为这个过程需要很长的时间。只有在出现以下文字时才能使用该界面。
{{< gallery match="images/1/*.png" >}}
然后我就可以调用我的PrestaShop服务器，通过界面继续安装。
{{< gallery match="images/2/*.png" >}}
我用 "Ctrl C "结束Docker-Compose，并调出子文件夹 "prestadata"（"cd prestadata"）。在那里，必须用 "rm -r install "删除 "install "文件夹。
{{< gallery match="images/3/*.png" >}}
此外，那里有一个 "管理员 "文件夹，在我的情况下是 "admin697vqoryt"。我记住了这个缩写，以后通过Docker Compose再次启动服务器。
{{< terminal >}}
docker-compose -f prestashop.yml up -d

{{</ terminal >}}

## 第2步：测试商店
重启后，我测试了我的Presta商店的安装，也在 "shop-url/admin shortcuts "下调用了管理界面。
{{< gallery match="images/4/*.png" >}}
