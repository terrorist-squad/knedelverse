+++
date = "2022-03-21"
title = "Wspaniałe rzeczy z pojemników: nagrywanie plików MP3 z radia"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "radio", "mp3", "ripp", "streamripper", "radiorecorder"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/march/20220321-docker-mighty-mixxx-tapper/index.pl.md"
+++
Streamripper to narzędzie wiersza poleceń, które służy do nagrywania strumieni MP3 lub OGG/Vorbis i zapisywania ich bezpośrednio na dysku twardym. Utwory są automatycznie nazywane imionami wykonawców i zapisywane indywidualnie, a ich format jest taki, jaki został pierwotnie wysłany (czyli w efekcie tworzone są pliki z rozszerzeniem .mp3 lub .ogg). Znalazłem świetny interfejs radiorecordera i zbudowałem z niego obraz Dockera, patrz: https://github.com/terrorist-squad/mightyMixxxTapper/
{{< gallery match="images/1/*.png" >}}

## Opcja dla profesjonalistów
Jako doświadczony użytkownik Synology możesz oczywiście zalogować się przez SSH i zainstalować całą konfigurację za pomocą pliku Docker Compose.
```
version: "2.0"
services:
  mealie:
    container_name: mighty-mixxx-tapper
    image: chrisknedel/mighty-mixxx-tapper:latest
    restart: always
    ports:
      - 9000:80
    environment:
      TZ: Europa/Berlin
    volumes:
      - ./ripps/:/tmp/ripps/

```

## Krok 1: Wyszukaj obraz Dockera
Klikam kartę "Rejestracja" w oknie Synology Docker i wyszukuję "mighty-mixxx-tapper". Wybieram obraz Docker "chrisknedel/mighty-mixxx-tapper", a następnie klikam znacznik "latest".
{{< gallery match="images/2/*.png" >}}
Po pobraniu obrazu jest on dostępny jako obraz. Docker rozróżnia dwa stany: kontener (stan dynamiczny) i obraz/obraz (stan stały). Zanim będziemy mogli utworzyć kontener z obrazu, należy dokonać kilku ustawień.
## Krok 2: Uruchomienie obrazu:
Klikam dwukrotnie na obraz "mighty-mixxx-tapper".
{{< gallery match="images/3/*.png" >}}
Następnie klikam na "Ustawienia zaawansowane" i włączam opcję "Automatyczne ponowne uruchamianie". Wybieram zakładkę "Wolumin" i klikam "Dodaj folder". W tym miejscu tworzę nowy folder ze ścieżką montowania "/tmp/ripps/".
{{< gallery match="images/4/*.png" >}}
Przydzielam stałe porty dla kontenera "mighty-mixxx-tapper". Bez ustalonych portów może się zdarzyć, że serwer "mighty-mixxx-tapper-server" będzie działał na innym porcie po ponownym uruchomieniu.
{{< gallery match="images/5/*.png" >}}
Po tych ustawieniach, mighty-mixxx-tapper-server może zostać uruchomiony! Następnie można zadzwonić do mighty-mixxx-tapper przez adres IP stacji dyskowej Synology i przypisany port, na przykład http://192.168.21.23:8097.
{{< gallery match="images/6/*.png" >}}