+++
date = "2021-04-16"
title = "Wspaniałe rzeczy z kontenerami: własna Wiki Bookstack na stacji Synology DiskStation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "bookstack", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-Bookstack/index.pl.md"
+++
Bookstack to alternatywa "open source" dla MediaWiki czy Confluence. Dziś pokażę, jak zainstalować usługę Bookstack na stacji dysków Synology.
## Opcja dla profesjonalistów
Jako doświadczony użytkownik Synology możesz oczywiście zalogować się przez SSH i zainstalować całą konfigurację za pomocą pliku Docker Compose.
```
version: '3'
services:
  bookstack:
    image: solidnerd/bookstack:0.27.4-1
    restart: always
    ports:
      - 8080:8080
    links:
      - database
    environment:
      DB_HOST: database:3306
      DB_DATABASE: my_wiki
      DB_USERNAME: wikiuser
      DB_PASSWORD: my_wiki_pass
      
  database:
    image: mariadb
    restart: always
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: my_wiki_pass1
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
Więcej przydatnych obrazów Dockera do użytku domowego można znaleźć w sekcji [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Krok 1: Przygotowanie folderu bookstack
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
|TZ	| Europe/Berlin |Strefa czasowa|
|MYSQL_ROOT_PASSWORD	|  my_wiki_pass |Hasło główne bazy danych.|
|MYSQL_DATABASE | 	my_wiki	|Jest to nazwa bazy danych.|
|MYSQL_USER	|  wikiuser	|Nazwa użytkownika bazy danych wiki.|
|MYSQL_PASSWORD	|  my_wiki_pass	|Hasło użytkownika bazy danych wiki.|
{{</table>}}
Na koniec wprowadzam następujące zmienne środowiskowe: Zobacz:
{{< gallery match="images/6/*.png" >}}
Po wprowadzeniu tych ustawień serwer Mariadb może zostać uruchomiony! Wszędzie naciskam przycisk "Zastosuj".
## Krok 3: Zainstaluj Bookstack
Klikam kartę "Rejestracja" w oknie Synology Docker i wyszukuję "bookstack". Wybieram obraz Docker "solidnerd/bookstack", a następnie klikam znacznik "latest".
{{< gallery match="images/7/*.png" >}}
Klikam dwukrotnie na obrazek z pakietu Bookstack. Następnie klikam na "Ustawienia zaawansowane" i włączam opcję "Automatyczne ponowne uruchamianie".
{{< gallery match="images/8/*.png" >}}
Kontenerowi "bookstack" przypisuję stałe porty. Bez ustalonych portów może się zdarzyć, że po ponownym uruchomieniu "serwer bookstack" będzie działał na innym porcie. Pierwszy port kontenera można usunąć. Należy pamiętać o drugim porcie.
{{< gallery match="images/9/*.png" >}}
Ponadto należy jeszcze utworzyć "link" do kontenera "mariadb". Klikam kartę "Łącza" i wybieram kontener bazy danych. Nazwa aliasu powinna być zapamiętana dla instalacji wiki.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nazwa zmiennej|Wartość|Co to jest?|
|--- | --- |---|
|TZ	| Europe/Berlin |Strefa czasowa|
|DB_HOST	| wiki-db:3306	|Nazwy aliasów / łącze kontenera|
|DB_DATABASE	| my_wiki |Dane z kroku 2|
|DB_USERNAME	| wikiuser |Dane z kroku 2|
|DB_PASSWORD	| my_wiki_pass	|Dane z kroku 2|
{{</table>}}
Na koniec wprowadzam następujące zmienne środowiskowe: Zobacz:
{{< gallery match="images/11/*.png" >}}
Teraz można uruchomić kontener. Utworzenie bazy danych może zająć trochę czasu. Zachowanie to można zaobserwować w szczegółach kontenera.
{{< gallery match="images/12/*.png" >}}
Wywołuję serwer Bookstack, podając adres IP Synology i port mojego kontenera. Nazwa logowania to "admin@admin.com", a hasło to "password".
{{< gallery match="images/13/*.png" >}}

