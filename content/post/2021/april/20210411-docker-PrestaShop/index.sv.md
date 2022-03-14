+++
date = "2021-04-11"
title = "Kreativt ut ur krisen: professionell webshop med PrestaShop"
difficulty = "level-4"
tags = ["corona", "Docker", "docker-compose", "kreativ", "krise", "online-shop", "presta", "shop", "shopsystem"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210411-docker-PrestaShop/index.sv.md"
+++
PrestaShop är en europeisk e-handelsplattform med öppen källkod som enligt egen uppgift för närvarande har över 300 000 installationer. Idag installerar jag denna PHP-programvara på min server. För den här handledningen krävs viss kunskap om Linux, Docker och Docker Compose.
## Steg 1: Installera PrestaShop
Jag skapar en ny katalog som heter "prestashop" på min server:
{{< terminal >}}
mkdir prestashop
cd prestashop

{{</ terminal >}}
Sedan går jag in i prestashop-katalogen och skapar en ny fil som heter "prestashop.yml" med följande innehåll.
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
Tyvärr fungerade inte den aktuella senaste versionen för mig, så jag installerade "1.7.7.7.2"-versionen. Den här filen startas via Docker Compose:
{{< terminal >}}
docker-compose -f prestashop.yml up

{{</ terminal >}}
Det är bäst att köpa färskt kaffe, eftersom processen tar lång tid. Gränssnittet kan endast användas när följande text visas.
{{< gallery match="images/1/*.png" >}}
Jag kan sedan ringa upp min PrestaShop-server och fortsätta installationen via gränssnittet.
{{< gallery match="images/2/*.png" >}}
Jag avslutar Docker-Compose med "Ctrl C" och öppnar undermappen "prestadata" ("cd prestadata"). Där måste mappen "install" raderas med "rm -r install".
{{< gallery match="images/3/*.png" >}}
Dessutom finns det en mapp "Admin" där, i mitt fall "admin697vqqoryt". Jag kommer ihåg denna förkortning för senare och startar servern igen via Docker Compose:
{{< terminal >}}
docker-compose -f prestashop.yml up -d

{{</ terminal >}}

## Steg 2: Testa butiken
Efter omstarten testar jag installationen av min Presta-shop och öppnar administrationsgränssnittet under "shop-url/admin shortcuts".
{{< gallery match="images/4/*.png" >}}