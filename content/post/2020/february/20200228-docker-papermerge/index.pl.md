+++
date = "2020-02-28"
title = "Wielkie rzeczy z kontenerami: Uruchamianie Papermerge DMS na Synology NAS"
difficulty = "level-3"
tags = ["archiv", "automatisch", "dms", "Docker", "Document-Managment-System", "google", "ocr", "papermerge", "Synology", "tesseract", "texterkennung"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200228-docker-papermerge/index.pl.md"
+++
Papermerge jest młodym systemem zarządzania dokumentami (DMS), który może automatycznie przypisywać i przetwarzać dokumenty. W tym tutorialu pokazuję jak zainstalowałem Papermerge na stacji dysków Synology i jak działa DMS.
## Opcja dla profesjonalistów
Jako doświadczony użytkownik Synology, możesz oczywiście zalogować się przez SSH i zainstalować całą konfigurację za pomocą pliku Docker Compose.
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
Najpierw tworzę folder dla scalania papieru. Idę do "System Control" -> "Shared Folder" i tworzę nowy folder o nazwie "Archiwum dokumentów".
{{< gallery match="images/1/*.png" >}}
Krok 2: Wyszukiwanie obrazu DockeraKlikam kartę "Rejestracja" w oknie Synology Docker i wyszukuję "Papermerge". Wybieram obraz Dockera "linuxserver/papermerge", a następnie klikam na tag "latest".
{{< gallery match="images/2/*.png" >}}
Po pobraniu obrazu jest on dostępny jako obraz. Docker rozróżnia 2 stany, kontener "stan dynamiczny" i obraz/image (stan stały). Zanim będziemy mogli utworzyć kontener z obrazu, należy dokonać kilku ustawień.
## Krok 3: Wprowadź obraz do działania:
Klikam dwukrotnie na mój obraz scalania papieru.
{{< gallery match="images/3/*.png" >}}
Następnie klikam na "Ustawienia zaawansowane" i aktywuję opcję "Automatyczny restart". Wybieram zakładkę "Volume" i klikam na "Add folder". Tam tworzę nowy folder bazy danych z tą ścieżką montowania "/data".
{{< gallery match="images/4/*.png" >}}
Przechowuję tutaj również drugi folder, który dołączam do ścieżki montowania "/config". Nie ma znaczenia, gdzie znajduje się ten folder. Ważne jest jednak, aby należał on do użytkownika admin Synology.
{{< gallery match="images/5/*.png" >}}
Przydzielam stałe porty dla kontenera "Papermerge". Bez ustalonych portów, może być tak, że "serwer Papermerge" działa na innym porcie po restarcie.
{{< gallery match="images/6/*.png" >}}
Na koniec wprowadzam trzy zmienne środowiskowe. Zmienna "PUID" jest identyfikatorem użytkownika, a "PGID" jest identyfikatorem grupy mojego użytkownika admin. Możesz znaleźć PGID/PUID poprzez SSH za pomocą polecenia "cat /etc/passwd | grep admin".
{{< gallery match="images/7/*.png" >}}
Po dokonaniu tych ustawień, serwer Papermerge może zostać uruchomiony! Następnie można wywołać Papermerge za pomocą adresu IP stacji dyskowej Synology i przypisanego portu, na przykład http://192.168.21.23:8095.
{{< gallery match="images/8/*.png" >}}
Domyślnym loginem jest admin z hasłem admin.
## Jak działa Papermerge?
Papermerge analizuje tekst dokumentów i obrazów. Papermerge używa biblioteki OCR/"optycznego rozpoznawania znaków" o nazwie tesseract, opublikowanej przez Goolge.
{{< gallery match="images/9/*.png" >}}
Utworzyłem folder o nazwie "Wszystko z Lorem", aby przetestować automatyczne przypisywanie dokumentów. Następnie w pozycji menu "Automaty" kliknąłem razem nowy wzorzec rozpoznawania.
{{< gallery match="images/10/*.png" >}}
Wszystkie nowe dokumenty zawierające słowo "Lorem" są umieszczane w folderze "Wszystko z Lorem" i oznaczane tagiem "ma-lorem". Ważne jest, aby używać przecinka w tagach, w przeciwnym razie tag nie zostanie ustawiony. Jeśli prześlesz odpowiedni dokument, zostanie on oznaczony i posortowany.
{{< gallery match="images/11/*.png" >}}