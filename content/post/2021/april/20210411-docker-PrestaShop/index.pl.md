+++
date = "2021-04-11"
title = "Kreatywne wyjście z kryzysu: profesjonalny sklep internetowy z PrestaShop"
difficulty = "level-4"
tags = ["corona", "Docker", "docker-compose", "kreativ", "krise", "online-shop", "presta", "shop", "shopsystem"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210411-docker-PrestaShop/index.pl.md"
+++
PrestaShop jest europejską platformą e-commerce typu open source z, według własnych informacji, obecnie ponad 300.000 instalacji. Dzisiaj instaluję to oprogramowanie PHP na moim serwerze. Do tego tutoriala wymagana jest wiedza z zakresu Linuksa, Dockera i Docker Compose.
## Krok 1: Zainstaluj PrestaShop
Tworzę nowy katalog o nazwie "prestashop" na moim serwerze:
{{< terminal >}}
mkdir prestashop
cd prestashop

{{</ terminal >}}
Następnie wchodzę do katalogu prestashop i tworzę nowy plik o nazwie "prestashop.yml" z następującą zawartością.
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
Niestety, aktualna wersja Lastest nie działała u mnie, więc zainstalowałem wersję "1.7.7.2". Ten plik jest uruchamiany za pomocą Docker Compose:
{{< terminal >}}
docker-compose -f prestashop.yml up

{{</ terminal >}}
Najlepiej zaopatrzyć się w świeżą kawę, ponieważ proces ten trwa długo. Interfejs może być używany tylko wtedy, gdy wyświetlany jest następujący tekst.
{{< gallery match="images/1/*.png" >}}
Mogę wtedy wywołać mój serwer PrestaShop i kontynuować instalację poprzez interfejs.
{{< gallery match="images/2/*.png" >}}
Kończę Docker-Compose z "Ctrl C" i wywołuję podfolder "prestadata" ("cd prestadata"). Tam należy skasować folder "install" za pomocą "rm -r install".
{{< gallery match="images/3/*.png" >}}
Dodatkowo znajduje się tam folder "Admin", w moim przypadku "admin697vqoryt". Zapamiętałem ten skrót na później i ponownie uruchomiłem serwer przez Docker Compose:
{{< terminal >}}
docker-compose -f prestashop.yml up -d

{{</ terminal >}}

## Krok 2: Przetestuj sklep
Po ponownym uruchomieniu, testuję moją instalację sklepu Presta i wywołuję interfejs administratora pod "shop-url/admin shortcuts".
{{< gallery match="images/4/*.png" >}}