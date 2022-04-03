+++
date = "2021-04-16"
title = "Wspaniałe rzeczy z kontenerami: instalacja Wiki.js na stacji Synology Diskstation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "wikijs", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-Wikijs/index.pl.md"
+++
Wiki.js to potężne oprogramowanie wiki o otwartym kodzie źródłowym, które dzięki prostemu interfejsowi sprawia, że tworzenie dokumentacji staje się przyjemnością. Dzisiaj pokazuję, jak zainstalować usługę Wiki.js na serwerze Synology DiskStation.
## Opcja dla profesjonalistów
Jako doświadczony użytkownik Synology możesz oczywiście zalogować się przez SSH i zainstalować całą konfigurację za pomocą pliku Docker Compose.
```
version: '3'
services:
  wikijs:
    image: requarks/wiki:latest
    restart: always
    ports:
      - 8082:3000
    links:
      - database
    environment:
      DB_TYPE: mysql
      DB_HOST: database
      DB_PORT: 3306
      DB_NAME: my_wiki
      DB_USER: wikiuser
      DB_PASS: my_wiki_pass
      TZ: 'Europe/Berlin'

  database:
    image: mysql
    restart: always
    expose:
      - 3306
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: my_wiki_pass
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
Więcej przydatnych obrazów Dockera do użytku domowego można znaleźć w serwisie Dockerverse.
## Krok 1: Przygotuj folder wiki
W katalogu Docker tworzę nowy katalog o nazwie "wiki".
{{< gallery match="images/1/*.png" >}}

## Krok 2: Zainstaluj bazę danych
Następnie należy utworzyć bazę danych. Klikam kartę "Rejestracja" w oknie Synology Docker i wyszukuję "mysql". Wybieram obraz Docker "mysql", a następnie klikam znacznik "latest".
{{< gallery match="images/2/*.png" >}}
Po pobraniu obrazu jest on dostępny jako obraz. Docker rozróżnia dwa stany: kontener (stan dynamiczny) i obraz (stan stały). Zanim utworzymy kontener z obrazu, należy dokonać kilku ustawień. Klikam dwukrotnie na obraz mysql.
{{< gallery match="images/3/*.png" >}}
Następnie klikam na "Ustawienia zaawansowane" i włączam opcję "Automatyczne ponowne uruchamianie". Wybieram zakładkę "Wolumin" i klikam "Dodaj folder". Tworzę tam nowy folder bazy danych ze ścieżką montowania "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
W sekcji "Ustawienia portów" wszystkie porty są usuwane. Oznacza to, że wybieram port "3306" i usuwam go za pomocą przycisku "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nazwa zmiennej|Wartość|Co to jest?|
|--- | --- |---|
|TZ	| Europe/Berlin |Strefa czasowa|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass |Hasło główne bazy danych.|
|MYSQL_DATABASE |	my_wiki |Jest to nazwa bazy danych.|
|MYSQL_USER	| wikiuser |Nazwa użytkownika bazy danych wiki.|
|MYSQL_PASSWORD |	my_wiki_pass	|Hasło użytkownika bazy danych wiki.|
{{</table>}}
Na koniec wprowadzam cztery zmienne środowiskowe: Zobacz:
{{< gallery match="images/6/*.png" >}}
Po wprowadzeniu tych ustawień serwer Mariadb może zostać uruchomiony! Wszędzie naciskam przycisk "Zastosuj".
## Krok 3: Zainstaluj Wiki.js
Klikam kartę "Rejestracja" w oknie Synology Docker i wyszukuję "wiki". Wybieram obraz Dockera "requarks/wiki", a następnie klikam znacznik "latest".
{{< gallery match="images/7/*.png" >}}
Klikam dwukrotnie obraz WikiJS. Następnie klikam na "Ustawienia zaawansowane" i włączam opcję "Automatyczne ponowne uruchamianie".
{{< gallery match="images/8/*.png" >}}
Przydzielam stałe porty dla kontenera "WikiJS". Bez ustalonych portów może się zdarzyć, że po ponownym uruchomieniu "serwer bookstack" będzie działał na innym porcie.
{{< gallery match="images/9/*.png" >}}
Ponadto należy jeszcze utworzyć "łącze" do kontenera "mysql". Klikam kartę "Łącza" i wybieram kontener bazy danych. Nazwa aliasu powinna być zapamiętana dla instalacji wiki.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nazwa zmiennej|Wartość|Co to jest?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Strefa czasowa|
|DB_HOST	| wiki-db	|Nazwy aliasów / łącze kontenera|
|DB_TYPE	| mysql	||
|DB_PORT	| 3306	 ||
|DB_PASSWORD	| my_wiki	|Dane z kroku 2|
|DB_USER	| wikiuser |Dane z kroku 2|
|DB_PASS	| my_wiki_pass	|Dane z kroku 2|
{{</table>}}
Na koniec wprowadzam następujące zmienne środowiskowe: Zobacz:
{{< gallery match="images/11/*.png" >}}
Teraz można uruchomić kontener. Wywołuję serwer Wiki.js, podając adres IP Synology i port kontenera/3000.
{{< gallery match="images/12/*.png" >}}
