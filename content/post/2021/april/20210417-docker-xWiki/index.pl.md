+++
date = "2021-04-17"
title = "Wspaniałe rzeczy z kontenerami: Uruchomienie własnego xWiki na stacji dysków Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "xwiki", "wiki",]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210417-docker-xWiki/index.pl.md"
+++
XWiki jest darmową platformą oprogramowania wiki napisaną w Javie i zaprojektowaną z myślą o rozszerzalności. Dzisiaj pokażę, jak zainstalować usługę xWiki na stacji Synology DiskStation.
## Opcja dla profesjonalistów
Jako doświadczony użytkownik Synology, możesz oczywiście zalogować się przez SSH i zainstalować całą konfigurację za pomocą pliku Docker Compose.
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
Więcej przydatnych obrazów Dockera do użytku domowego można znaleźć w dziale [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Krok 1: Przygotuj folder wiki
Tworzę nowy katalog o nazwie "wiki" w katalogu Dockera.
{{< gallery match="images/1/*.png" >}}

## Krok 2: Zainstaluj bazę danych
Następnie należy utworzyć bazę danych. Klikam na zakładkę "Rejestracja" w oknie Synology Docker i wyszukuję "postgres". Wybieram obraz Docker "postgres", a następnie klikam na tag "latest".
{{< gallery match="images/2/*.png" >}}
Po pobraniu obrazu jest on dostępny jako obraz. Docker rozróżnia 2 stany, kontener "stan dynamiczny" i obraz (stan stały). Zanim utworzymy kontener z obrazu, należy dokonać kilku ustawień. Klikam dwukrotnie na mój obraz postgres.
{{< gallery match="images/3/*.png" >}}
Następnie klikam na "Ustawienia zaawansowane" i aktywuję opcję "Automatyczny restart". Wybieram zakładkę "Volume" i klikam na "Add folder". Tam tworzę nowy folder bazy danych z tą ścieżką montowania "/var/lib/postgresql/data".
{{< gallery match="images/4/*.png" >}}
W zakładce "Port settings" wszystkie porty są usuwane. Oznacza to, że wybieram port "5432" i usuwam go za pomocą przycisku "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nazwa zmiennej|Wartość|Co to jest?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Strefa czasowa|
|POSTGRES_DB	| xwiki |Jest to nazwa bazy danych.|
|POSTGRES_USER	| xwiki |Nazwa użytkownika bazy danych wiki.|
|POSTGRES_PASSWORD	| xwiki |Hasło użytkownika bazy danych wiki.|
{{</table>}}
Na koniec wprowadzam te cztery zmienne środowiskowe:Zobacz:
{{< gallery match="images/6/*.png" >}}
Po dokonaniu tych ustawień, serwer Mariadb może zostać uruchomiony! Wszędzie naciskam "Zastosuj".
## Krok 3: Zainstaluj xWiki
Klikam na zakładkę "Rejestracja" w oknie Synology Docker i wyszukuję "xwiki". Wybieram obraz Docker "xwiki", a następnie klikam na tag "10-postgres-tomcat".
{{< gallery match="images/7/*.png" >}}
Klikam dwukrotnie na mój obraz xwiki. Następnie klikam na "Ustawienia zaawansowane" i aktywuję "Automatyczny restart" również tutaj.
{{< gallery match="images/8/*.png" >}}
Przydzielam stałe porty dla kontenera "xwiki". Bez ustalonych portów, może być tak, że "serwer xwiki" działa na innym porcie po restarcie.
{{< gallery match="images/9/*.png" >}}
Dodatkowo musi zostać utworzony "link" do kontenera "postgres". Klikam na zakładkę "Linki" i wybieram kontener bazy danych. Nazwa aliasu powinna być zapamiętana dla instalacji wiki.
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
Na koniec wprowadzam te zmienne środowiskowe:Zobacz:
{{< gallery match="images/11/*.png" >}}
Kontener może być teraz uruchomiony. Wywołuję serwer xWiki podając adres IP Synology i port mojego kontenera.
{{< gallery match="images/12/*.png" >}}