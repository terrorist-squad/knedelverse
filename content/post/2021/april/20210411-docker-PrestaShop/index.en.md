+++
date = "2021-04-11"
title = "Creative out of the crisis: professional webshop with PrestaShop"
difficulty = "level-4"
tags = ["corona", "Docker", "docker-compose", "kreativ", "krise", "online-shop", "presta", "shop", "shopsystem"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210411-docker-PrestaShop/index.en.md"
+++
PrestaShop is a European open source e-commerce platform with, according to their own information, currently over 300,000 installations. Today I am installing this PHP software on my server. Some Linux, Docker and Docker Compose knowledge is required for this tutorial.
## Step 1: Install PrestaShop
I create a new directory called "prestashop" on my server:
{{< terminal >}}
mkdir prestashop
cd prestashop

{{</ terminal >}}
After that I go to the prestashop directory and create a new file called "prestashop.yml" with the following content.
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
Unfortunately, the current Lastest version didn't work for me, so I installed the "1.7.7.2" version. This file is started via Docker Compose:
{{< terminal >}}
docker-compose -f prestashop.yml up

{{</ terminal >}}
It is best to get a fresh coffee, because the process takes a long time. Only when the following text appears, the interface can be used.
{{< gallery match="images/1/*.png" >}}
After that I can access my PrestaShop server and continue the installation via interface.
{{< gallery match="images/2/*.png" >}}
I quit Docker-Compose with "Ctrl C" and open the subfolder "prestadata" ("cd prestadata"). There, the "install" folder must be deleted with "rm -r install".
{{< gallery match="images/3/*.png" >}}
There is also an "Admin" folder, in my case "admin697vqoryt". I remember this abbreviation for later and start the server again via Docker Compose:
{{< terminal >}}
docker-compose -f prestashop.yml up -d

{{</ terminal >}}

## Step 2: Test the shop
After the reboot I test my Presta store installation and also call the admin interface under "shop-url/admin-shortcuts".
{{< gallery match="images/4/*.png" >}}