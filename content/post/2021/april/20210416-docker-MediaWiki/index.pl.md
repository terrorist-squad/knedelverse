+++
date = "2021-04-16"
title = "Wspaniałe rzeczy z kontenerami: Instalacja własnego MediaWiki na stacji dysków Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "mediawiki", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-MediaWiki/index.pl.md"
+++
MediaWiki to oparty na PHP system wiki, który jest dostępny bezpłatnie jako produkt open source. Dzisiaj pokazuję, jak zainstalować usługę MediaWiki na stacji dysków Synology.
## Opcja dla profesjonalistów
Jako doświadczony użytkownik Synology możesz oczywiście zalogować się przez SSH i zainstalować całą konfigurację za pomocą pliku Docker Compose.
```
version: '3'
services:
  mediawiki:
    image: mediawiki
    restart: always
    ports:
      - 8081:80
    links:
      - database
    volumes:
      - ./images:/var/www/html/images
      # After initial setup, download LocalSettings.php to the same directory as
      # this yaml and uncomment the following line and use compose to restart
      # the mediawiki service
      # - ./LocalSettings.php:/var/www/html/LocalSettings.php

  database:
    image: mariadb
    restart: always
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      # @see https://phabricator.wikimedia.org/source/mediawiki/browse/master/includes/DefaultSettings.php
      MYSQL_ROOT_PASSWORD: my_wiki_pass1
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
Więcej przydatnych obrazów Dockera do użytku domowego można znaleźć w sekcji [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Krok 1: Przygotuj folder MediaWiki
W katalogu Docker tworzę nowy katalog o nazwie "wiki".
{{< gallery match="images/1/*.png" >}}

## Krok 2: Zainstaluj bazę danych
Następnie należy utworzyć bazę danych. Klikam kartę "Rejestracja" w oknie Synology Docker i wyszukuję "mariadb". Wybieram obraz Docker "mariadb", a następnie klikam znacznik "latest".
{{< gallery match="images/2/*.png" >}}
Po pobraniu obrazu jest on dostępny jako obraz. Docker rozróżnia dwa stany: kontener (stan dynamiczny) i obraz (stan stały). Zanim utworzymy kontener z obrazu, należy dokonać kilku ustawień. Klikam dwukrotnie na obraz mariadb.
{{< gallery match="images/3/*.png" >}}
Następnie klikam na "Ustawienia zaawansowane" i włączam opcję "Automatyczne ponowne uruchamianie". Wybieram zakładkę "Wolumin" i klikam "Dodaj folder". Tworzę tam nowy folder bazy danych ze ścieżką montowania "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
W sekcji "Ustawienia portów" wszystkie porty są usuwane. Oznacza to, że wybieram port "3306" i usuwam go za pomocą przycisku "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nazwa zmiennej|Wartość|Co to jest?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Strefa czasowa|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass	|Hasło główne bazy danych.|
|MYSQL_DATABASE |	my_wiki	|Jest to nazwa bazy danych.|
|MYSQL_USER	| wikiuser |Nazwa użytkownika bazy danych wiki.|
|MYSQL_PASSWORD	| my_wiki_pass |Hasło użytkownika bazy danych wiki.|
{{</table>}}
Na koniec wprowadzam następujące zmienne środowiskowe: Zobacz:
{{< gallery match="images/6/*.png" >}}
Po wprowadzeniu tych ustawień serwer Mariadb może zostać uruchomiony! Wszędzie naciskam przycisk "Zastosuj".
## Krok 3: Zainstaluj MediaWiki
Klikam kartę "Rejestracja" w oknie Synology Docker i wyszukuję "mediawiki". Wybieram obraz Docker "mediawiki", a następnie klikam znacznik "latest".
{{< gallery match="images/7/*.png" >}}
Klikam dwukrotnie obraz Mediawiki.
{{< gallery match="images/8/*.png" >}}
Następnie klikam na "Ustawienia zaawansowane" i włączam opcję "Automatyczne ponowne uruchamianie". Wybieram zakładkę "Wolumin" i klikam "Dodaj folder". W tym miejscu tworzę nowy folder ze ścieżką montowania "/var/www/html/images".
{{< gallery match="images/9/*.png" >}}
Dla kontenera "MediaWiki" przypisuję stałe porty. Bez ustalonych portów może się zdarzyć, że po ponownym uruchomieniu "serwer MediaWiki" będzie działał na innym porcie.
{{< gallery match="images/10/*.png" >}}
Ponadto należy jeszcze utworzyć "link" do kontenera "mariadb". Klikam kartę "Łącza" i wybieram kontener bazy danych. Nazwa aliasu powinna być zapamiętana dla instalacji wiki.
{{< gallery match="images/11/*.png" >}}
Na koniec wprowadzam zmienną środowiskową "TZ" o wartości "Europa/Berlin".
{{< gallery match="images/12/*.png" >}}
Teraz można uruchomić kontener. Wywołuję serwer Mediawiki, podając adres IP Synology i port mojego kontenera. W polu Serwer bazy danych wpisuję nazwę aliasu kontenera bazy danych. Wprowadzam również nazwę bazy danych, nazwę użytkownika i hasło z "Kroku 2".
{{< gallery match="images/13/*.png" >}}
