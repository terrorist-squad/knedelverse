+++
date = "2021-04-18"
title = "Wspaniałe rzeczy z kontenerami: Instalacja własnego dokuWiki na stacji dysków Synology"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dokuwiki", "wiki"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210418-docker-dokuWiki/index.pl.md"
+++
DokuWiki jest zgodnym ze standardami, łatwym w użyciu i jednocześnie niezwykle wszechstronnym oprogramowaniem wiki typu open source. Dziś pokażę jak zainstalować usługę DokuWiki na stacji dysków Synology.
## Opcja dla profesjonalistów
Jako doświadczony użytkownik Synology, możesz oczywiście zalogować się przez SSH i zainstalować całą konfigurację za pomocą pliku Docker Compose.
```
version: '3'
services:
  dokuwiki:
    image:  bitnami/dokuwiki:latest
    restart: always
    ports:
      - 8080:8080
      - 8443:8443
    environment:
      TZ: 'Europe/Berlin'
      DOKUWIKI_USERNAME: 'admin'
      DOKUWIKI_FULL_NAME: 'wiki'
      DOKUWIKI_PASSWORD: 'password'
    volumes:
      - ./data:/bitnami/dokuwiki

```
Więcej przydatnych obrazów Dockera do użytku domowego można znaleźć w dziale [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Krok 1: Przygotuj folder wiki
Tworzę nowy katalog o nazwie "wiki" w katalogu Dockera.
{{< gallery match="images/1/*.png" >}}

## Krok 2: Zainstaluj DokuWiki
Następnie należy utworzyć bazę danych. Klikam kartę "Rejestracja" w oknie Synology Docker i wyszukuję "dokuwiki". Wybieram obraz Dockera "bitnami/dokuwiki", a następnie klikam na tag "latest".
{{< gallery match="images/2/*.png" >}}
Po pobraniu obrazu jest on dostępny jako obraz. Docker rozróżnia 2 stany, kontener "stan dynamiczny" i obraz (stan stały). Zanim utworzymy kontener z obrazu, należy dokonać kilku ustawień. Klikam dwukrotnie na mój obraz dokuwiki.
{{< gallery match="images/3/*.png" >}}
Przydzielam stałe porty dla kontenera "dokuwiki". Bez ustalonych portów, może być tak, że "serwer dokuwiki" działa na innym porcie po restarcie.
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nazwa zmiennej|Wartość|Co to jest?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Strefa czasowa|
|DOKUWIKI_USERNAME	| admin|Nazwa użytkownika administratora|
|DOKUWIKI_FULL_NAME |	wiki	|Nazwa WIki|
|DOKUWIKI_PASSWORD	| password	|Hasło administratora|
{{</table>}}
Na koniec wprowadzam te zmienne środowiskowe:Zobacz:
{{< gallery match="images/5/*.png" >}}
Kontener może być teraz uruchomiony. Wywołuję serwer dokuWIki podając adres IP Synology i port mojego kontenera.
{{< gallery match="images/6/*.png" >}}
