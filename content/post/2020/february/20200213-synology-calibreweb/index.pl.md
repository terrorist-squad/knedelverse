+++
date = "2020-02-13"
title = "Synology-Nas: Zainstaluj Calibre Web jako bibliotekę ebooków"
difficulty = "level-1"
tags = ["calbre-web", "calibre", "Docker", "ds918", "ebook", "epub", "nas", "pdf", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200213-synology-calibreweb/index.pl.md"
+++
Jak zainstalować Calibre-Web jako kontener Docker na serwerze NAS firmy Synology? Uwaga: Ta metoda instalacji jest przestarzała i nie jest zgodna z aktualnym oprogramowaniem Calibre. Proszę spojrzeć na ten nowy tutorial:[Wielkie rzeczy z kontenerami: Uruchamianie Calibre z Docker Compose]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Wielkie rzeczy z kontenerami: Uruchamianie Calibre z Docker Compose"). Ten samouczek jest przeznaczony dla wszystkich profesjonalistów zajmujących się obsługą Synology DS.
## Krok 1: Utwórz folder
Najpierw tworzę folder dla biblioteki Calibre.  Wywołuję "Kontrolę systemu" -> "Udostępniony folder" i tworzę nowy folder "Książki".
{{< gallery match="images/1/*.png" >}}

##  Krok 2: Utwórz bibliotekę Calibre
Teraz kopiuję istniejącą bibliotekę lub "[ta pusta przykładowa biblioteka](https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view)" do nowego katalogu. Ja sam skopiowałem istniejącą bibliotekę aplikacji desktopowej.
{{< gallery match="images/2/*.png" >}}

## Krok 3: Wyszukaj obraz Dockera
Klikam kartę "Rejestracja" w oknie Synology Docker i wyszukuję "Calibre". Wybieram obraz Dockera "janeczku/calibre-web", a następnie klikam na tag "latest".
{{< gallery match="images/3/*.png" >}}
Po pobraniu obrazu jest on dostępny jako obraz. Docker rozróżnia 2 stany, kontener "stan dynamiczny" i obraz/image (stan stały). Zanim będziemy mogli utworzyć kontener z obrazu, należy dokonać kilku ustawień.
## Krok 4: Wprowadź obraz do działania:
Klikam dwukrotnie na mój obraz z Calibre.
{{< gallery match="images/4/*.png" >}}
Następnie klikam na "Ustawienia zaawansowane" i aktywuję opcję "Automatyczny restart". Wybieram zakładkę "Volume" i klikam na "Add Folder". Tam tworzę nowy folder bazy danych z tą ścieżką montowania "/calibre".
{{< gallery match="images/5/*.png" >}}
Przydzielam stałe porty dla kontenera Calibre. Bez ustalonych portów może się zdarzyć, że Calibre po ponownym uruchomieniu działa na innym porcie.
{{< gallery match="images/6/*.png" >}}
Po tych ustawieniach można uruchomić Calibre!
{{< gallery match="images/7/*.png" >}}
Wywołuję teraz mój adres IP Synology z przypisanym portem Calibre i widzę następujący obraz. Wpisuję "/calibre" jako "Lokalizacja bazy danych Calibre". Pozostałe ustawienia są kwestią gustu.
{{< gallery match="images/8/*.png" >}}
Domyślnym loginem jest "admin" z hasłem "admin123".
{{< gallery match="images/9/*.png" >}}
Zrobione! Oczywiście teraz mogę również podłączyć aplikację desktopową przez mój "folder książek". Zamieniam bibliotekę w mojej aplikacji, a następnie wybieram folder Nas.
{{< gallery match="images/10/*.png" >}}
Coś w tym stylu:
{{< gallery match="images/11/*.png" >}}
Jeśli teraz edytuję meta-infos w aplikacji desktopowej, są one również automatycznie aktualizowane w aplikacji internetowej.
{{< gallery match="images/12/*.png" >}}