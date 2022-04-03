+++
date = "2021-04-11"
title = "Kreatywne wyjście z kryzysu: profesjonalny sklep internetowy z PrestaShop"
difficulty = "level-4"
tags = ["corona", "Docker", "docker-compose", "kreativ", "krise", "online-shop", "presta", "shop", "shopsystem"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210411-docker-PrestaShop/index.pl.md"
+++
PrestaShop to europejska platforma open source do handlu elektronicznego, która według własnych danych ma obecnie ponad 300 000 instalacji. Dzisiaj instaluję to oprogramowanie PHP na moim serwerze. Do tego samouczka wymagana jest pewna wiedza na temat Linuksa, Dockera i Docker Compose.
## Krok 1: Zainstaluj PrestaShop
Na moim serwerze tworzę nowy katalog o nazwie "prestashop":
{{< terminal >}}
mkdir prestashop
cd prestashop

{{</ terminal >}}
Następnie wchodzę do katalogu prestashop i tworzę nowy plik o nazwie "prestashop.yml" o następującej zawartości.
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
Niestety, aktualna wersja Lastest nie działała u mnie, więc zainstalowałem wersję "1.7.7.2". Ten plik jest uruchamiany za pomocą aplikacji Docker Compose:
{{< terminal >}}
docker-compose -f prestashop.yml up

{{</ terminal >}}
Najlepiej zaopatrzyć się w świeżą kawę, ponieważ proces ten trwa długo. Interfejs może być używany tylko wtedy, gdy wyświetlany jest następujący tekst.
{{< gallery match="images/1/*.png" >}}
Następnie mogę wywołać mój serwer PrestaShop i kontynuować instalację za pomocą interfejsu.
{{< gallery match="images/2/*.png" >}}
Kończę pracę z Docker-Compose, naciskając klawisz "Ctrl C", i wywołuję podfolder "prestadata" ("cd prestadata"). W tym celu należy usunąć folder "install" za pomocą polecenia "rm -r install".
{{< gallery match="images/3/*.png" >}}
Ponadto znajduje się tam folder "Admin", w moim przypadku "admin697vqoryt". Zapamiętałem ten skrót na później i ponownie uruchomiłem serwer za pomocą aplikacji Docker Compose:
{{< terminal >}}
docker-compose -f prestashop.yml up -d

{{</ terminal >}}

## Krok 2: Przetestuj sklep
Po ponownym uruchomieniu testuję instalację sklepu Presta, a także wywołuję interfejs administratora pod adresem "shop-url/admin shortcuts".
{{< gallery match="images/4/*.png" >}}
