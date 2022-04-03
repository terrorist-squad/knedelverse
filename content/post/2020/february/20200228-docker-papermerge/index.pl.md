+++
date = "2020-02-28"
title = "Wielkie rzeczy z kontenerami: uruchamianie Papermerge DMS na Synology NAS"
difficulty = "level-3"
tags = ["archiv", "automatisch", "dms", "Docker", "Document-Managment-System", "google", "ocr", "papermerge", "Synology", "tesseract", "texterkennung"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200228-docker-papermerge/index.pl.md"
+++
Papermerge to młody system zarządzania dokumentami (DMS), który może automatycznie przypisywać i przetwarzać dokumenty. W tym poradniku pokazuję, jak zainstalowałem program Papermerge na stacji dysków Synology i jak działa system DMS.
## Opcja dla profesjonalistów
Jako doświadczony użytkownik Synology możesz oczywiście zalogować się przez SSH i zainstalować całą konfigurację za pomocą pliku Docker Compose.
```
version: "2.1"
services:
  papermerge:
    image: ghcr.io/linuxserver/papermerge
    container_name: papermerge
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./config>:/config
      - ./appdata/data>:/data
    ports:
      - 8090:8000
    restart: unless-stopped

```

## Krok 1: Utwórz folder
Najpierw tworzę folder do scalania papieru. Wchodzę w "Sterowanie systemem" -> "Folder współdzielony" i tworzę nowy folder o nazwie "Archiwum dokumentów".
{{< gallery match="images/1/*.png" >}}
Krok 2: Wyszukiwanie obrazu DockeraKlikam kartę "Rejestracja" w oknie Synology Docker i wyszukuję "Papermerge". Wybieram obraz Docker "linuxserver/papermerge", a następnie klikam znacznik "latest".
{{< gallery match="images/2/*.png" >}}
Po pobraniu obrazu jest on dostępny jako obraz. Docker rozróżnia dwa stany: kontener (stan dynamiczny) i obraz/obraz (stan stały). Zanim będziemy mogli utworzyć kontener z obrazu, należy dokonać kilku ustawień.
## Krok 3: Uruchomienie obrazu:
Klikam dwukrotnie obraz scalania papieru.
{{< gallery match="images/3/*.png" >}}
Następnie klikam na "Ustawienia zaawansowane" i włączam opcję "Automatyczne ponowne uruchamianie". Wybieram zakładkę "Wolumin" i klikam "Dodaj folder". W tym miejscu tworzę nowy folder bazy danych ze ścieżką montowania "/data".
{{< gallery match="images/4/*.png" >}}
Przechowuję tu także drugi folder, który dołączam do ścieżki montowania "/config". Nie ma znaczenia, gdzie znajduje się ten folder. Ważne jest jednak, aby należał on do użytkownika admin Synology.
{{< gallery match="images/5/*.png" >}}
Przydzielam stałe porty dla kontenera "Papermerge". Bez ustalonych portów może się zdarzyć, że po ponownym uruchomieniu "serwer Papermerge" będzie działał na innym porcie.
{{< gallery match="images/6/*.png" >}}
Na koniec wprowadzam trzy zmienne środowiskowe. Zmienna "PUID" to identyfikator użytkownika, a "PGID" to identyfikator grupy użytkownika admin. PGID/PUID można poznać przez SSH, wykonując polecenie "cat /etc/passwd | grep admin".
{{< gallery match="images/7/*.png" >}}
Po wprowadzeniu tych ustawień można uruchomić serwer Papermerge! Następnie można wywołać aplikację Papermerge za pomocą adresu IP stacji dyskowej Synology i przypisanego portu, na przykład http://192.168.21.23:8095.
{{< gallery match="images/8/*.png" >}}
Domyślnym loginem jest admin z hasłem admin.
## Jak działa Papermerge?
Papermerge analizuje tekst dokumentów i obrazów. Program Papermerge korzysta z biblioteki OCR/"optycznego rozpoznawania znaków" o nazwie tesseract, opublikowanej przez firmę Goolge.
{{< gallery match="images/9/*.png" >}}
Utworzyłem folder o nazwie "Wszystko z Lorem", aby przetestować automatyczne przypisywanie dokumentów. Następnie w pozycji menu "Automaty" kliknąłem razem nowy wzorzec rozpoznawania.
{{< gallery match="images/10/*.png" >}}
Wszystkie nowe dokumenty zawierające słowo "Lorem" są umieszczane w folderze "Wszystko z Lorem" i oznaczane tagiem "ma-lorem". Ważne jest, aby w znacznikach używać przecinka, w przeciwnym razie znacznik nie zostanie ustawiony. Po przesłaniu dokumentu zostanie on oznaczony i posortowany.
{{< gallery match="images/11/*.png" >}}
