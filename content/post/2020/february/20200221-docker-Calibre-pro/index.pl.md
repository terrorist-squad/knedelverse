+++
date = "2020-02-21"
title = "Wspaniałe rzeczy z kontenerami: Uruchamianie Calibre za pomocą Docker Compose (konfiguracja Synology pro)"
difficulty = "level-3"
tags = ["calibre", "calibre-web", "Docker", "docker-compose", "Synology", "linux"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200221-docker-Calibre-pro/index.pl.md"
+++
Na tym blogu jest już łatwiejszy tutorial: [Synology-Nas: Zainstaluj Calibre Web jako bibliotekę ebooków]({{< ref "post/2020/february/20200213-synology-calibreweb" >}} "Synology-Nas: Zainstaluj Calibre Web jako bibliotekę ebooków"). Ten samouczek jest przeznaczony dla wszystkich profesjonalistów zajmujących się obsługą Synology DS.
## Krok 1: Przygotuj Synology
Najpierw należy aktywować logowanie SSH na serwerze DiskStation. W tym celu należy wejść w "Panel sterowania" > "Terminal
{{< gallery match="images/1/*.png" >}}
Następnie można zalogować się poprzez "SSH", podany port i hasło administratora (użytkownicy Windows używają Putty lub WinSCP).
{{< gallery match="images/2/*.png" >}}
Loguję się przez Terminal, winSCP lub Putty i zostawiam tę konsolę otwartą na później.
## Krok 2: Utwórz folder książki
Tworzę nowy folder dla biblioteki Calibre. Aby to zrobić, wywołuję "System Control" -> "Shared Folder" i tworzę nowy folder o nazwie "Books". Jeśli nie ma jeszcze folderu "Docker", to również musi on zostać utworzony.
{{< gallery match="images/3/*.png" >}}

## Krok 3: Przygotowanie folderu z książkami
Teraz należy pobrać i rozpakować następujący plik: https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view. Zawartość ("metadata.db") musi być umieszczona w nowym katalogu książki, patrz:
{{< gallery match="images/4/*.png" >}}

## Krok 4: Przygotuj folder Docker
Tworzę nowy katalog o nazwie "calibre" w katalogu Docker:
{{< gallery match="images/5/*.png" >}}
Następnie przechodzę do nowego katalogu i tworzę nowy plik o nazwie "calibre.yml" z następującą zawartością:
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre:/briefkaste
    ports:
      - 8055:8083
    restart: unless-stopped

```
W tym nowym pliku należy dostosować kilka miejsc w następujący sposób:* PUID/PGID: W PUID/PGID należy wprowadzić identyfikator użytkownika i grupy użytkownika DS. Tutaj używam konsoli z "Kroku 1" i komendy "id -u" aby zobaczyć ID użytkownika. Za pomocą polecenia "id -g" otrzymam ID grupy.* ports: Dla portu, przednia część "8055:" musi zostać skorygowana.directoriesWszystkie katalogi w tym pliku muszą zostać skorygowane. Prawidłowe adresy są widoczne w oknie właściwości systemu DS. (Zrzut ekranu poniżej)
{{< gallery match="images/6/*.png" >}}

## Krok 5: Uruchomienie testu
W tym kroku mogę również dobrze wykorzystać konsolę. Przechodzę do katalogu Calibre i tam uruchamiam serwer Calibre poprzez Docker Compose.
{{< terminal >}}
cd /volume1/docker/calibre
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}

{{< gallery match="images/7/*.png" >}}

## Krok 6: Konfiguracja
Następnie mogę zadzwonić do mojego serwera Calibre z IP stacji dysków i przypisanego portu z "Krok 4". Używam mojego punktu montowania "/books" w konfiguracji. Po tym, serwer jest już zdatny do użytku.
{{< gallery match="images/8/*.png" >}}

## Krok 7: Zakończenie konfiguracji
Konsola jest również potrzebna w tym kroku. Używam polecenia "exec", aby zapisać bazę danych kontenera-wewnętrznej aplikacji.
{{< terminal >}}
sudo docker exec -it calibre-web-server cp /app/calibre-web/app.db /briefkaste/app.db

{{</ terminal >}}
Po tym widzę nowy plik "app.db" w katalogu Calibre:
{{< gallery match="images/9/*.png" >}}
Następnie zatrzymuję serwer Calibre:
{{< terminal >}}
sudo docker-compose -f calibre.yml down

{{</ terminal >}}
Teraz zmieniam ścieżkę letterbox i nad nią persystuję bazę danych aplikacji.
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre/app.db:/app/calibre-web/app.db
    ports:
      - 8055:8083
    restart: unless-stopped

```
Po tym można ponownie uruchomić serwer:
{{< terminal >}}
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}