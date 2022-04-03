+++
date = "2020-02-21"
title = "Wspaniałe rzeczy z kontenerami: Uruchamianie Calibre za pomocą Docker Compose (konfiguracja Synology pro)"
difficulty = "level-3"
tags = ["calibre", "calibre-web", "Docker", "docker-compose", "Synology", "linux"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200221-docker-Calibre-pro/index.pl.md"
+++
Na tym blogu jest już dostępny łatwiejszy poradnik: [Synology-Nas: Zainstaluj Calibre Web jako bibliotekę ebooków]({{< ref "post/2020/february/20200213-synology-calibreweb" >}} "Synology-Nas: Zainstaluj Calibre Web jako bibliotekę ebooków"). Ten samouczek jest przeznaczony dla wszystkich profesjonalistów zajmujących się obsługą Synology DS.
## Krok 1: Przygotuj Synology
Najpierw należy aktywować logowanie SSH na serwerze DiskStation. W tym celu należy przejść do "Panelu sterowania" > "Terminal
{{< gallery match="images/1/*.png" >}}
Następnie można zalogować się przez "SSH", podany port i hasło administratora (użytkownicy systemu Windows używają Putty lub WinSCP).
{{< gallery match="images/2/*.png" >}}
Loguję się za pomocą Terminala, winSCP lub Putty i zostawiam tę konsolę otwartą na później.
## Krok 2: Utwórz folder książek
Tworzę nowy folder dla biblioteki Calibre. W tym celu wywołuję polecenie "Kontrola systemu" -> "Folder udostępniony" i tworzę nowy folder o nazwie "Książki". Jeśli nie ma jeszcze folderu "Docker", należy go utworzyć.
{{< gallery match="images/3/*.png" >}}

## Krok 3: Przygotowanie folderu z książkami
Teraz należy pobrać i rozpakować następujący plik: https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view. Zawartość ("metadata.db") musi być umieszczona w nowym katalogu książki, zob:
{{< gallery match="images/4/*.png" >}}

## Krok 4: Przygotuj folder Docker
W katalogu Docker tworzę nowy katalog o nazwie "calibre":
{{< gallery match="images/5/*.png" >}}
Następnie przechodzę do nowego katalogu i tworzę nowy plik o nazwie "calibre.yml" o następującej zawartości:
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
W tym nowym pliku należy dostosować kilka miejsc w następujący sposób:* PUID/PGID: W polu PUID/PGID należy wprowadzić identyfikator użytkownika i grupy użytkownika DS. Tutaj używam konsoli z "Kroku 1" i polecenia "id -u", aby zobaczyć identyfikator użytkownika. Za pomocą polecenia "id -g" otrzymam identyfikator grupy.* ports: W przypadku portu należy skorygować przednią część "8055:".directoriesWszystkie katalogi w tym pliku muszą zostać skorygowane. Prawidłowe adresy można zobaczyć w oknie właściwości systemu DS. (Zrzut ekranu poniżej)
{{< gallery match="images/6/*.png" >}}

## Krok 5: Uruchomienie testu
W tym kroku mogę również dobrze wykorzystać konsolę. Przechodzę do katalogu Calibre i uruchamiam tam serwer Calibre za pomocą aplikacji Docker Compose.
{{< terminal >}}
cd /volume1/docker/calibre
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}

{{< gallery match="images/7/*.png" >}}

## Krok 6: Konfiguracja
Następnie mogę wywołać mój serwer Calibre, podając adres IP stacji dysków i przypisany port z "Kroku 4". W ustawieniach używam punktu montowania "/books". Po tej operacji serwer jest już zdatny do użytku.
{{< gallery match="images/8/*.png" >}}

## Krok 7: Zakończenie konfiguracji
W tym kroku potrzebna jest również konsola. Do zapisania wewnętrznej bazy danych aplikacji w kontenerze używam polecenia "exec".
{{< terminal >}}
sudo docker exec -it calibre-web-server cp /app/calibre-web/app.db /briefkaste/app.db

{{</ terminal >}}
Następnie w katalogu Calibre pojawia się nowy plik "app.db":
{{< gallery match="images/9/*.png" >}}
Następnie zatrzymuję serwer Calibre:
{{< terminal >}}
sudo docker-compose -f calibre.yml down

{{</ terminal >}}
Teraz zmieniam ścieżkę do skrzynki pocztowej i zapisuję w niej bazę danych aplikacji.
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
Następnie można ponownie uruchomić serwer:
{{< terminal >}}
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}
