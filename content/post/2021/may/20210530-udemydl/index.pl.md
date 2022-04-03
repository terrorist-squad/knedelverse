+++
date = "2021-05-30"
title = "Program Udemy Downloader na serwerze Synology DiskStation"
difficulty = "level-2"
tags = ["udemy", "download", "synology", "diskstation", "udemydl"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-udemydl/index.pl.md"
+++
W tym poradniku dowiesz się, jak pobierać kursy "udemy" do użytku offline.
## Krok 1: Przygotuj folder Udemy
Tworzę nowy katalog o nazwie "udemy" w katalogu Docker.
{{< gallery match="images/1/*.png" >}}

## Krok 2: Zainstaluj obraz Ubuntu
Klikam kartę "Rejestracja" w oknie Synology Docker i wyszukuję "ubunutu". Wybieram obraz Docker "ubunutu", a następnie klikam znacznik "latest".
{{< gallery match="images/2/*.png" >}}
Klikam dwukrotnie na mój obraz Ubuntu. Następnie klikam na "Ustawienia zaawansowane" i włączam opcję "Automatyczne ponowne uruchamianie".
{{< gallery match="images/3/*.png" >}}
Wybieram zakładkę "Wolumin" i klikam "Dodaj folder". W tym miejscu tworzę nowy folder ze ścieżką montowania "/download".
{{< gallery match="images/4/*.png" >}}
Teraz można uruchomić kontener
{{< gallery match="images/5/*.png" >}}

## Krok 4: Zainstaluj program Udemy Downloader
W oknie Synology Docker klikam pozycję "Kontener" i dwukrotnie klikam mój "kontener Udemy". Następnie klikam zakładkę "Terminal" i wpisuję następujące polecenia.
{{< gallery match="images/6/*.png" >}}

##  Polecenia:

{{< terminal >}}
apt-get update
apt-get install python3 python3-pip wget unzip
cd /download
wget https://github.com/r0oth3x49/udemy-dl/archive/refs/heads/master.zip
unzip master.zip
cd udemy-dl-master
pip3 pip install -r requirements.txt

{{</ terminal >}}
Zrzuty ekranu:
{{< gallery match="images/7/*.png" >}}

## Krok 4: Uruchomienie programu do pobierania plików Udemy
Teraz potrzebny jest "token dostępu". Odwiedzam Udemy za pomocą przeglądarki Firefox i otwieram Firebug. Klikam kartę "Web storage" i kopiuję "Access token".
{{< gallery match="images/8/*.png" >}}
W kontenerze tworzę nowy plik:
{{< terminal >}}
echo "access_token=859wjuhV7PMLsZu15GOWias9A0iFnRjkL9pJXOv2" > /download/cookie.txt

{{</ terminal >}}
Następnie mogę pobrać kursy, które już kupiłem:
{{< terminal >}}
cd /download
python3 udemy-dl-master/udemy-dl.py -k /download/cookie.txt https://www.udemy.com/course/ansible-grundlagen/learn/

{{</ terminal >}}
Zobacz:
{{< gallery match="images/9/*.png" >}}

