+++
date = "2021-04-11"
title = "Творчески изход от кризата: професионален уеб магазин с PrestaShop"
difficulty = "level-4"
tags = ["corona", "Docker", "docker-compose", "kreativ", "krise", "online-shop", "presta", "shop", "shopsystem"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210411-docker-PrestaShop/index.bg.md"
+++
PrestaShop е европейска платформа за електронна търговия с отворен код, която според собствената ѝ информация в момента има над 300 000 инсталации. Днес инсталирам този PHP софтуер на моя сървър. За този урок са необходими известни познания за Linux, Docker и Docker Compose.
## Стъпка 1: Инсталиране на PrestaShop
Създавам нова директория, наречена "prestashop", на моя сървър:
{{< terminal >}}
mkdir prestashop
cd prestashop

{{</ terminal >}}
След това влизам в директорията prestashop и създавам нов файл, наречен "prestashop.yml", със следното съдържание.
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
За съжаление текущата последна версия не работи за мен, затова инсталирах версията "1.7.7.2". Този файл се стартира чрез Docker Compose:
{{< terminal >}}
docker-compose -f prestashop.yml up

{{</ terminal >}}
Най-добре е да си вземете прясно кафе, тъй като процесът отнема много време. Интерфейсът може да се използва само когато се появи следният текст.
{{< gallery match="images/1/*.png" >}}
След това мога да извикам моя PrestaShop сървър и да продължа инсталацията чрез интерфейса.
{{< gallery match="images/2/*.png" >}}
Завършвам Docker-Compose с "Ctrl C" и извиквам подпапка "prestadata" ("cd prestadata"). Там папката "install" трябва да се изтрие с "rm -r install".
{{< gallery match="images/3/*.png" >}}
Освен това там има папка "Admin", в моя случай "admin697vqoryt". Запомням тази абревиатура за по-късно и стартирам сървъра отново чрез Docker Compose:
{{< terminal >}}
docker-compose -f prestashop.yml up -d

{{</ terminal >}}

## Стъпка 2: Тестване на магазина
След рестартирането тествам инсталацията на моя магазин Presta и също така извиквам администраторския интерфейс под "shop-url/admin shortcuts".
{{< gallery match="images/4/*.png" >}}
