+++
date = "2021-05-30"
title = "Udemy Downloader na serwerze Synology DiskStation"
difficulty = "level-2"
tags = ["udemy", "download", "synology", "diskstation", "udemydl"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/may/20210530-udemydl/index.pl.md"
+++
W tym poradniku dowiesz się jak pobrać kursy "udemy" do użytku offline.
## Krok 1: Przygotuj folder Udemy
Tworzę nowy katalog o nazwie "udemy" w katalogu Docker.
{{< gallery match="images/1/*.png" >}}

## Krok 2: Zainstaluj obraz Ubuntu
Klikam na zakładkę "Rejestracja" w oknie Synology Docker i wyszukuję "ubunutu". Wybieram obraz Docker "ubunutu", a następnie klikam na tag "latest".
{{< gallery match="images/2/*.png" >}}
Klikam dwukrotnie na mój obraz Ubuntu. Następnie klikam na "Ustawienia zaawansowane" i aktywuję "Automatyczny restart" również tutaj.
{{< gallery match="images/3/*.png" >}}
Wybieram zakładkę "Wolumin" i klikam na "Dodaj folder". Tam tworzę nowy folder z taką ścieżką montowania "/download".
{{< gallery match="images/4/*.png" >}}
Teraz kontener może zostać uruchomiony
{{< gallery match="images/5/*.png" >}}

## Krok 4: Zainstaluj Udemy Downloader
Klikam na "Kontener" w oknie Synology Docker i dwukrotnie klikam na mój "Kontener Udemy". Następnie klikam na zakładkę "Terminal" i wpisuję następujące komendy.
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

## Krok 4: Uruchomienie downloadera Udemy
Teraz potrzebuję "tokena dostępu". Odwiedzam Udemy z moją przeglądarką Firefox i otwieram Firebug. Klikam na zakładkę "Web storage" i kopiuję "Access token".
{{< gallery match="images/8/*.png" >}}
Tworzę nowy plik w moim kontenerze:
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
