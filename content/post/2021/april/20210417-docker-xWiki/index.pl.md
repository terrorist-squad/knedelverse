+++
date = "2021-04-17"
title = "Wspaniałe rzeczy z kontenerami: Uruchomienie własnego xWiki na stacji dysków Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "xwiki", "wiki",]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210417-docker-xWiki/index.pl.md"
+++
XWiki to darmowa platforma oprogramowania wiki napisana w Javie i zaprojektowana z myślą o rozszerzalności. Dzisiaj pokazuję, jak zainstalować usługę xWiki na serwerze Synology DiskStation.
## Opcja dla profesjonalistów
Jako doświadczony użytkownik Synology możesz oczywiście zalogować się przez SSH i zainstalować całą konfigurację za pomocą pliku Docker Compose.
```
version: '3'
services:
  xwiki:
    image: xwiki:10-postgres-tomcat
    restart: always
    ports:
      - 8080:8080
    links:
      - db
    environment:
      DB_HOST: db
      DB_DATABASE: xwiki
      DB_DATABASE: xwiki
      DB_PASSWORD: xwiki
      TZ: 'Europe/Berlin'

  db:
    image: postgres:latest
    restart: always
    volumes:
      - ./postgresql:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=xwiki
      - POSTGRES_PASSWORD=xwiki
      - POSTGRES_DB=xwiki
      - TZ='Europe/Berlin'

```
Więcej przydatnych obrazów Dockera do użytku domowego można znaleźć w sekcji [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Krok 1: Przygotuj folder wiki
W katalogu Docker tworzę nowy katalog o nazwie "wiki".
{{< gallery match="images/1/*.png" >}}

## Krok 2: Zainstaluj bazę danych
Następnie należy utworzyć bazę danych. Klikam kartę "Rejestracja" w oknie Synology Docker i wyszukuję "postgres". Wybieram obraz Docker "postgres", a następnie klikam znacznik "latest".
{{< gallery match="images/2/*.png" >}}
Po pobraniu obrazu jest on dostępny jako obraz. Docker rozróżnia dwa stany: kontener (stan dynamiczny) i obraz (stan stały). Przed utworzeniem kontenera z obrazu należy dokonać kilku ustawień. Klikam dwukrotnie na obraz postgres.
{{< gallery match="images/3/*.png" >}}
Następnie klikam na "Ustawienia zaawansowane" i włączam opcję "Automatyczne ponowne uruchamianie". Wybieram zakładkę "Wolumin" i klikam "Dodaj folder". W tym miejscu tworzę nowy folder bazy danych ze ścieżką montowania "/var/lib/postgresql/data".
{{< gallery match="images/4/*.png" >}}
W sekcji "Ustawienia portów" wszystkie porty są usuwane. Oznacza to, że wybieram port "5432" i usuwam go za pomocą przycisku "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nazwa zmiennej|Wartość|Co to jest?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Strefa czasowa|
|POSTGRES_DB	| xwiki |Jest to nazwa bazy danych.|
|POSTGRES_USER	| xwiki |Nazwa użytkownika bazy danych wiki.|
|POSTGRES_PASSWORD	| xwiki |Hasło użytkownika bazy danych wiki.|
{{</table>}}
Na koniec wprowadzam cztery zmienne środowiskowe: Zobacz:
{{< gallery match="images/6/*.png" >}}
Po wprowadzeniu tych ustawień serwer Mariadb może zostać uruchomiony! Wszędzie naciskam przycisk "Zastosuj".
## Krok 3: Zainstaluj xWiki
Klikam kartę "Rejestracja" w oknie Synology Docker i wyszukuję "xwiki". Wybieram obraz Docker "xwiki", a następnie klikam znacznik "10-postgres-tomcat".
{{< gallery match="images/7/*.png" >}}
Klikam dwukrotnie obrazek xwiki. Następnie klikam na "Ustawienia zaawansowane" i włączam opcję "Automatyczne ponowne uruchamianie".
{{< gallery match="images/8/*.png" >}}
Przydzielam stałe porty dla kontenera "xwiki". Bez ustalonych portów może się zdarzyć, że po ponownym uruchomieniu "serwer xwiki" będzie działał na innym porcie.
{{< gallery match="images/9/*.png" >}}
Ponadto należy utworzyć "link" do kontenera "postgres". Klikam kartę "Łącza" i wybieram kontener bazy danych. Nazwa aliasu powinna być zapamiętana dla instalacji wiki.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nazwa zmiennej|Wartość|Co to jest?|
|--- | --- |---|
|TZ |	Europe/Berlin	|Strefa czasowa|
|DB_HOST	| db |Nazwy aliasów / łącze kontenera|
|DB_DATABASE	| xwiki	|Dane z kroku 2|
|DB_USER	| xwiki	|Dane z kroku 2|
|DB_PASSWORD	| xwiki |Dane z kroku 2|
{{</table>}}
Na koniec wprowadzam następujące zmienne środowiskowe: Zobacz:
{{< gallery match="images/11/*.png" >}}
Teraz można uruchomić kontener. Wywołuję serwer xWiki, podając adres IP Synology i port mojego kontenera.
{{< gallery match="images/12/*.png" >}}
