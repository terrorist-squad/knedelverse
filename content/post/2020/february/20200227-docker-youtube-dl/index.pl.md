+++
date = "2020-02-27"
title = "Wspaniałe rzeczy z kontenerami: Uruchamianie programu do pobierania plików Youtube na stacji Synology Diskstation"
difficulty = "level-1"
tags = ["Docker", "docker-compose", "download", "linux", "Synology", "video", "youtube"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200227-docker-youtube-dl/index.pl.md"
+++
Wielu moich znajomych wie, że prowadzę prywatny portal video do nauki na moim Homelab - Network. Zapisałem kursy wideo z poprzednich członkostw w portalach edukacyjnych i dobre tutoriale Youtube do użytku offline na moim NAS.
{{< gallery match="images/1/*.png" >}}
Z biegiem czasu zebrałem 8845 kursów wideo z 282616 pojedynczymi filmami. Całkowity czas pracy wynosi około 2 lat. W tym tutorialu pokazuję, jak zrobić kopię zapasową dobrych tutoriali z Youtube za pomocą usługi pobierania Docker dla celów offline.
## Opcja dla profesjonalistów
Jako doświadczony użytkownik Synology, możesz oczywiście zalogować się przez SSH i zainstalować całą konfigurację za pomocą pliku Docker Compose.
```
version: "2"
services:
  youtube-dl:
    image: modenaf360/youtube-dl-nas
    container_name: youtube-dl
    environment:
      - MY_ID=admin
      - MY_PW=admin
    volumes:
      - ./YouTube:/downfolder
    ports:
      - 8080:8080
    restart: unless-stopped

```

## Krok 1
Najpierw tworzę folder z plikami do pobrania. Idę do "System Control" -> "Shared Folder" i tworzę nowy folder o nazwie "Downloads".
{{< gallery match="images/2/*.png" >}}

## Krok 2: Wyszukaj obraz Dockera
Klikam kartę "Rejestracja" w oknie Synology Docker i wyszukuję "youtube-dl-nas". Wybieram obraz Dockera "modenaf360/youtube-dl-nas", a następnie klikam na tag "latest".
{{< gallery match="images/3/*.png" >}}
Po pobraniu obrazu jest on dostępny jako obraz. Docker rozróżnia 2 stany, kontener "stan dynamiczny" i obraz/image (stan stały). Zanim będziemy mogli utworzyć kontener z obrazu, należy dokonać kilku ustawień.
## Krok 3: Wprowadź obraz do działania:
Klikam dwukrotnie na mój obrazek z youtube-dl-nas.
{{< gallery match="images/4/*.png" >}}
Następnie klikam na "Ustawienia zaawansowane" i aktywuję opcję "Automatyczny restart". Wybieram zakładkę "Volume" i klikam na "Add folder". Tam tworzę nowy folder bazy danych z tą ścieżką montowania "/downfolder".
{{< gallery match="images/5/*.png" >}}
Przydzielam stałe porty dla kontenera "Youtube Downloader". Bez ustalonych portów, może być tak, że "Youtube Downloader" działa na innym porcie po ponownym uruchomieniu.
{{< gallery match="images/6/*.png" >}}
Na koniec wprowadzam dwie zmienne środowiskowe. Zmienna "MY_ID" to moja nazwa użytkownika, a "MY_PW" to moje hasło.
{{< gallery match="images/7/*.png" >}}
Po dokonaniu tych ustawień, Downloader może zostać uruchomiony! Następnie można nawiązać połączenie z downloaderem za pośrednictwem adresu IP stacji dyskowej Synology i przypisanego portu, na przykład http://192.168.21.23:8070 .
{{< gallery match="images/8/*.png" >}}
W celu uwierzytelnienia, weź nazwę użytkownika i hasło z MY_ID i MY_PW.
## Krok 4: Ruszamy
Teraz w polu "URL" można wpisywać adresy URL do filmów wideo z serwisu Youtube i list odtwarzania, a wszystkie filmy automatycznie trafią do folderu pobierania stacji dyskowej Synology.
{{< gallery match="images/9/*.png" >}}
Folder do pobrania:
{{< gallery match="images/10/*.png" >}}