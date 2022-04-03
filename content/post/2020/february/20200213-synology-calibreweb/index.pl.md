+++
date = "2020-02-13"
title = "Synology-Nas: Zainstaluj Calibre Web jako bibliotekę ebooków"
difficulty = "level-1"
tags = ["calbre-web", "calibre", "Docker", "ds918", "ebook", "epub", "nas", "pdf", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200213-synology-calibreweb/index.pl.md"
+++
Jak zainstalować Calibre-Web jako kontener Docker na serwerze Synology NAS? Uwaga: Ta metoda instalacji jest przestarzała i nie jest zgodna z aktualnym oprogramowaniem Calibre. Zapoznaj się z tym nowym samouczkiem:[Wielkie rzeczy z kontenerami: Uruchamianie Calibre za pomocą Docker Compose]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Wielkie rzeczy z kontenerami: Uruchamianie Calibre za pomocą Docker Compose"). Ten samouczek jest przeznaczony dla wszystkich profesjonalistów zajmujących się obsługą Synology DS.
## Krok 1: Utwórz folder
Najpierw tworzę folder dla biblioteki Calibre.  Wywołuję "Kontrolę systemu" -> "Folder współdzielony" i tworzę nowy folder "Książki".
{{< gallery match="images/1/*.png" >}}

##  Krok 2: Utwórz bibliotekę Calibre
Teraz kopiuję istniejącą bibliotekę lub "[tę pustą przykładową bibliotekę](https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view)" do nowego katalogu. Ja sam skopiowałem istniejącą bibliotekę aplikacji desktopowej.
{{< gallery match="images/2/*.png" >}}

## Krok 3: Wyszukaj obraz Dockera
Klikam kartę "Rejestracja" w oknie Synology Docker i wyszukuję "Calibre". Wybieram obraz Dockera "janeczku/calibre-web", a następnie klikam znacznik "latest".
{{< gallery match="images/3/*.png" >}}
Po pobraniu obrazu jest on dostępny jako obraz. Docker rozróżnia dwa stany: kontener (stan dynamiczny) i obraz/obraz (stan stały). Zanim będziemy mogli utworzyć kontener z obrazu, należy dokonać kilku ustawień.
## Krok 4: Uruchomienie obrazu:
Klikam dwukrotnie mój obraz w programie Calibre.
{{< gallery match="images/4/*.png" >}}
Następnie klikam na "Ustawienia zaawansowane" i włączam opcję "Automatyczne ponowne uruchamianie". Wybieram zakładkę "Wolumin" i klikam "Dodaj folder". W tym miejscu tworzę nowy folder bazy danych ze ścieżką montowania "/calibre".
{{< gallery match="images/5/*.png" >}}
Kontenerowi Calibre przypisuję stałe porty. Przy braku stałych portów może się zdarzyć, że po ponownym uruchomieniu Calibre będzie działać na innym porcie.
{{< gallery match="images/6/*.png" >}}
Po wprowadzeniu tych ustawień można uruchomić program Calibre!
{{< gallery match="images/7/*.png" >}}
Wywołuję teraz adres IP Synology z przypisanym portem Calibre i widzę następujący obraz. Jako "Lokalizacja bazy danych Calibre" wpisuję "/calibre". Pozostałe ustawienia są kwestią gustu.
{{< gallery match="images/8/*.png" >}}
Domyślnym loginem jest "admin" z hasłem "admin123".
{{< gallery match="images/9/*.png" >}}
Gotowe! Oczywiście teraz mogę również połączyć się z aplikacją na pulpicie za pośrednictwem "folderu książek". Zamieniam bibliotekę w aplikacji, a następnie wybieram folder Nas.
{{< gallery match="images/10/*.png" >}}
Coś w tym stylu:
{{< gallery match="images/11/*.png" >}}
Jeśli teraz edytuję meta-infos w aplikacji desktopowej, są one również automatycznie aktualizowane w aplikacji internetowej.
{{< gallery match="images/12/*.png" >}}
