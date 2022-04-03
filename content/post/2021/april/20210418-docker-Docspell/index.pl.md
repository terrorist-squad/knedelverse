+++
date = "2021-04-18"
title = "Wspaniałe rzeczy z kontenerami: Uruchamianie Docspell DMS na stacji Synology DiskStation"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "Document-Managment-System"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-Docspell/index.pl.md"
+++
Docspell to system zarządzania dokumentami dla stacji Synology DiskStation. Dzięki Docspell dokumenty mogą być indeksowane, wyszukiwane i znajdowane znacznie szybciej. Dzisiaj pokażę, jak zainstalować usługę Docspell na stacji dysków Synology.
## Krok 1: Przygotuj Synology
Najpierw należy aktywować logowanie SSH na serwerze DiskStation. W tym celu należy przejść do "Panelu sterowania" > "Terminal
{{< gallery match="images/1/*.png" >}}
Następnie można zalogować się przez "SSH", podany port i hasło administratora (użytkownicy systemu Windows używają Putty lub WinSCP).
{{< gallery match="images/2/*.png" >}}
Loguję się za pomocą Terminala, winSCP lub Putty i zostawiam tę konsolę otwartą na później.
## Krok 2: Utwórz folder Docspel
W katalogu Docker tworzę nowy katalog o nazwie "docspell".
{{< gallery match="images/3/*.png" >}}
Teraz należy pobrać i rozpakować w katalogu następujący plik: https://github.com/eikek/docspell/archive/refs/heads/master.zip . Używam do tego konsoli:
{{< terminal >}}
cd /volume1/docker/docspell/
mkdir docs
mkdir postgres_data
wget https://github.com/eikek/docspell/archive/refs/heads/master.zip 
/bin/7z x master.zip

{{</ terminal >}}
Następnie edytuję plik "docker/docker-compose.yml" i wprowadzam adresy Synology w polach "consumedir" i "db":
{{< gallery match="images/4/*.png" >}}
Następnie można rozpocząć pracę z plikiem Compose:
{{< terminal >}}
cd docspell-master/docker/
docker-compose up -d

{{</ terminal >}}
Po kilku minutach mogę połączyć się z moim serwerem Docspell, podając adres IP stacji dysków i przypisany port/7878.
{{< gallery match="images/5/*.png" >}}
Wyszukiwanie dokumentów działa sprawnie. Szkoda, że teksty w obrazach nie są indeksowane. Za pomocą programu Papermerge można również wyszukiwać teksty w obrazach.
