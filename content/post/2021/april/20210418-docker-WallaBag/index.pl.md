+++
date = "2021-04-18"
title = "Wielkie rzeczy z kontenerami: Własny WallaBag na stacji dyskowej Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "archiv", "wallabag"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-WallaBag/index.pl.md"
+++
Wallabag to program do archiwizacji ciekawych stron internetowych lub artykułów. Dziś pokażę jak zainstalować usługę Wallabag na stacji dysków Synology.
## Opcja dla profesjonalistów
Jako doświadczony użytkownik Synology, możesz oczywiście zalogować się przez SSH i zainstalować całą konfigurację za pomocą pliku Docker Compose.
```
version: '3'
services:
  wallabag:
    image: wallabag/wallabag
    environment:
      - MYSQL_ROOT_PASSWORD=wallaroot
      - SYMFONY__ENV__DATABASE_DRIVER=pdo_mysql
      - SYMFONY__ENV__DATABASE_HOST=db
      - SYMFONY__ENV__DATABASE_PORT=3306
      - SYMFONY__ENV__DATABASE_NAME=wallabag
      - SYMFONY__ENV__DATABASE_USER=wallabag
      - SYMFONY__ENV__DATABASE_PASSWORD=wallapass
      - SYMFONY__ENV__DATABASE_CHARSET=utf8mb4
      - SYMFONY__ENV__DOMAIN_NAME=http://192.168.178.50:8089
      - SYMFONY__ENV__SERVER_NAME="Your wallabag instance"
      - SYMFONY__ENV__FOSUSER_CONFIRMATION=false
      - SYMFONY__ENV__TWOFACTOR_AUTH=false
    ports:
      - "8089:80"
    volumes:
      - ./wallabag/images:/var/www/wallabag/web/assets/images

  db:
    image: mariadb
    environment:
      - MYSQL_ROOT_PASSWORD=wallaroot
    volumes:
      - ./mariadb:/var/lib/mysql

```
Więcej przydatnych obrazów Dockera do użytku domowego można znaleźć w dziale [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Krok 1: Przygotuj folder z torbami ściennymi
Tworzę nowy katalog o nazwie "wallabag" w katalogu Docker.
{{< gallery match="images/1/*.png" >}}

## Krok 2: Zainstaluj bazę danych
Następnie należy utworzyć bazę danych. Klikam na zakładkę "Rejestracja" w oknie Synology Docker i szukam "mariadb". Wybieram obraz Docker "mariadb", a następnie klikam na tag "latest".
{{< gallery match="images/2/*.png" >}}
Po pobraniu obrazu jest on dostępny jako obraz. Docker rozróżnia 2 stany, kontener "stan dynamiczny" i obraz (stan stały). Zanim utworzymy kontener z obrazu, należy dokonać kilku ustawień. Klikam dwukrotnie na mój obraz mariadb.
{{< gallery match="images/3/*.png" >}}
Następnie klikam na "Ustawienia zaawansowane" i aktywuję opcję "Automatyczny restart". Wybieram zakładkę "Volume" i klikam na "Add Folder". Tam tworzę nowy folder bazy danych z tą ścieżką montowania "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
W zakładce "Port settings" wszystkie porty są usuwane. Oznacza to, że wybieram port "3306" i usuwam go za pomocą przycisku "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nazwa zmiennej|Wartość|Co to jest?|
|--- | --- |---|
|TZ| Europe/Berlin	|Strefa czasowa|
|MYSQL_ROOT_PASSWORD	 | wallaroot |Hasło główne bazy danych.|
{{</table>}}
Na koniec wprowadzam te zmienne środowiskowe:Zobacz:
{{< gallery match="images/6/*.png" >}}
Po dokonaniu tych ustawień, serwer Mariadb może zostać uruchomiony! Wszędzie naciskam "Zastosuj".
{{< gallery match="images/7/*.png" >}}

## Krok 3: Zainstaluj Wallabag
Klikam kartę "Rejestracja" w oknie Synology Docker i wyszukuję "wallabag". Wybieram obraz Docker "wallabag/wallabag", a następnie klikam na tag "latest".
{{< gallery match="images/8/*.png" >}}
Dwukrotnie klikam na obrazek mojego wallabaga. Następnie klikam na "Ustawienia zaawansowane" i aktywuję "Automatyczny restart" również tutaj.
{{< gallery match="images/9/*.png" >}}
Wybieram zakładkę "Volume" i klikam na "Add Folder". Tam tworzę nowy folder z taką ścieżką montowania "/var/www/wallabag/web/assets/images".
{{< gallery match="images/10/*.png" >}}
Przypisuję stałe porty dla kontenera "wallabag". Bez ustalonych portów może się zdarzyć, że "serwer wallabag" po restarcie działa na innym porcie. Pierwszy port kontenera może zostać usunięty. Należy pamiętać o drugim porcie.
{{< gallery match="images/11/*.png" >}}
Dodatkowo należy jeszcze utworzyć "link" do kontenera "mariadb". Klikam na zakładkę "Linki" i wybieram kontener bazy danych. Nazwa aliasu powinna być zapamiętana dla instalacji wallabag.
{{< gallery match="images/12/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Umgebungsvariable	|Wartość|
|--- |---|
|MYSQL_ROOT_PASSWORD	|wallaroot|
|SYMFONY__ENV__DATABASE_DRIVER	|pdo_mysql|
|SYMFONY__ENV__DATABASE_HOST	|db|
|SYMFONY__ENV__DATABASE_PORT	|3306|
|SYMFONY__ENV__DATABASE_NAME	|wallabag|
|SYMFONY__ENV__DATABASE_USER	|wallabag|
|SYMFONY__ENV__DATABASE_PASSWORD	|wallapass|
|SYMFONY__ENV__DATABASE_CHARSET |utf8mb4|
|SYMFONY__ENV__DOMAIN_NAME	|"http://synology-ip:container-port" <- Proszę zmienić|
|SYMFONY__ENV__SERVER_NAME	|"Wallabag - Serwer"|
|SYMFONY__ENV__FOSUSER_CONFIRMATION	|fałszywy|
|SYMFONY__ENV__TWOFACTOR_AUTH	|fałszywy|
{{</table>}}
Na koniec wprowadzam te zmienne środowiskowe:Zobacz:
{{< gallery match="images/13/*.png" >}}
Kontener może być teraz uruchomiony. Tworzenie bazy danych może zająć trochę czasu. Zachowanie to można obserwować poprzez szczegóły kontenera.
{{< gallery match="images/14/*.png" >}}
Dzwonię do serwera wallabag podając adres IP Synology i port mojego kontenera.
{{< gallery match="images/15/*.png" >}}
