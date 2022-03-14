+++
date = "2021-04-11"
title = "Креативный выход из кризиса: профессиональный интернет-магазин с PrestaShop"
difficulty = "level-4"
tags = ["corona", "Docker", "docker-compose", "kreativ", "krise", "online-shop", "presta", "shop", "shopsystem"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210411-docker-PrestaShop/index.ru.md"
+++
PrestaShop - это европейская платформа электронной коммерции с открытым исходным кодом, имеющая, согласно ее собственной информации, в настоящее время более 300 000 установок. Сегодня я устанавливаю это программное обеспечение PHP на свой сервер. Для этого урока необходимы некоторые знания Linux, Docker и Docker Compose.
## Шаг 1: Установите PrestaShop
Я создаю новый каталог под названием "prestashop" на своем сервере:
{{< terminal >}}
mkdir prestashop
cd prestashop

{{</ terminal >}}
Затем я захожу в каталог prestashop и создаю новый файл под названием "prestashop.yml" со следующим содержанием.
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
К сожалению, текущая версия Lastest не работала для меня, поэтому я установил версию "1.7.7.2". Этот файл запускается через Docker Compose:
{{< terminal >}}
docker-compose -f prestashop.yml up

{{</ terminal >}}
Лучше всего брать свежий кофе, так как процесс занимает много времени. Интерфейс можно использовать только при появлении следующего текста.
{{< gallery match="images/1/*.png" >}}
Затем я могу вызвать свой сервер PrestaShop и продолжить установку через интерфейс.
{{< gallery match="images/2/*.png" >}}
Я завершаю Docker-Compose клавишей "Ctrl C" и вызываю подпапку "prestadata" ("cd prestadata"). Там папку "install" нужно удалить с помощью команды "rm -r install".
{{< gallery match="images/3/*.png" >}}
Кроме того, там есть папка "Admin", в моем случае "admin697vqoryt". Я запоминаю эту аббревиатуру на будущее и снова запускаю сервер через Docker Compose:
{{< terminal >}}
docker-compose -f prestashop.yml up -d

{{</ terminal >}}

## Шаг 2: Протестируйте магазин
После перезапуска я проверяю установку магазина Presta, а также вызываю интерфейс администратора под "shop-url/admin shortcuts".
{{< gallery match="images/4/*.png" >}}