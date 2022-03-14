+++
date = "2021-04-16"
title = "Wspaniałe rzeczy z kontenerami: własna Wiki Bookstack na stacji Synology DiskStation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "bookstack", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-Bookstack/index.pl.md"
+++
Bookstack jest alternatywą "open source" dla MediaWiki czy Confluence. Dziś pokażę jak zainstalować usługę Bookstack na stacji dysków Synology.
## Opcja dla profesjonalistów
Jako doświadczony użytkownik Synology, możesz oczywiście zalogować się przez SSH i zainstalować całą konfigurację za pomocą pliku Docker Compose.
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
Więcej przydatnych obrazów Dockera do użytku domowego można znaleźć w dziale [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Krok 1: Przygotuj folder bookstack
Tworzę nowy katalog o nazwie "wiki" w katalogu Dockera.
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
|TZ	| Europe/Berlin |Strefa czasowa|
|MYSQL_ROOT_PASSWORD	|  my_wiki_pass |Hasło główne bazy danych.|
|MYSQL_DATABASE | 	my_wiki	|Jest to nazwa bazy danych.|
|MYSQL_USER	|  wikiuser	|Nazwa użytkownika bazy danych wiki.|
|MYSQL_PASSWORD	|  my_wiki_pass	|Hasło użytkownika bazy danych wiki.|
{{</table>}}
Na koniec wprowadzam te zmienne środowiskowe:Zobacz:
{{< gallery match="images/6/*.png" >}}
Po dokonaniu tych ustawień, serwer Mariadb może zostać uruchomiony! Wszędzie naciskam "Zastosuj".
## Krok 3: Zainstaluj Bookstack
Klikam kartę "Rejestracja" w oknie Synology Docker i wyszukuję "bookstack". Wybieram obraz Dockera "solidnerd/bookstack", a następnie klikam na tag "latest".
{{< gallery match="images/7/*.png" >}}
Klikam dwukrotnie na mój obraz Bookstack. Następnie klikam na "Ustawienia zaawansowane" i aktywuję "Automatyczny restart" również tutaj.
{{< gallery match="images/8/*.png" >}}
Przydzielam stałe porty dla kontenera "bookstack". Bez ustalonych portów może się zdarzyć, że "serwer bookstack" po restarcie działa na innym porcie. Pierwszy port kontenera może zostać usunięty. Należy pamiętać o drugim porcie.
{{< gallery match="images/9/*.png" >}}
Dodatkowo należy jeszcze utworzyć "link" do kontenera "mariadb". Klikam na zakładkę "Linki" i wybieram kontener bazy danych. Nazwa aliasu powinna być zapamiętana dla instalacji wiki.
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
Na koniec wprowadzam te zmienne środowiskowe:Zobacz:
{{< gallery match="images/11/*.png" >}}
Kontener może być teraz uruchomiony. Tworzenie bazy danych może zająć trochę czasu. Zachowanie to można obserwować poprzez szczegóły kontenera.
{{< gallery match="images/12/*.png" >}}
Wywołuję serwer Bookstack, podając adres IP Synology i port mojego kontenera. Nazwa logowania to "admin@admin.com", a hasło to "password".
{{< gallery match="images/13/*.png" >}}
