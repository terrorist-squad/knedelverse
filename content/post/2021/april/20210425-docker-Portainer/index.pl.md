+++
date = "2021-04-25T09:28:11+01:00"
title = "Wspaniałe rzeczy z kontenerami: Portainer jako alternatywa dla Synology Docker GUI"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Portainer/index.pl.md"
+++

## Krok 1: Przygotuj Synology
Najpierw należy aktywować logowanie SSH na serwerze DiskStation. W tym celu należy przejść do "Panelu sterowania" > "Terminal
{{< gallery match="images/1/*.png" >}}
Następnie można zalogować się przez "SSH", podany port i hasło administratora (użytkownicy systemu Windows używają Putty lub WinSCP).
{{< gallery match="images/2/*.png" >}}
Loguję się za pomocą Terminala, winSCP lub Putty i zostawiam tę konsolę otwartą na później.
## Krok 2: Utwórz folder portainer
W katalogu Docker tworzę nowy katalog o nazwie "portainer".
{{< gallery match="images/3/*.png" >}}
Następnie za pomocą konsoli przechodzę do katalogu portainer i tworzę w nim folder oraz nowy plik o nazwie "portainer.yml".
{{< terminal >}}
cd /volume1/docker/portainer
mkdir portainer_data
vim portainer.yml

{{</ terminal >}}
Poniżej znajduje się zawartość pliku "portainer.yml":
```
version: '3'

services:
  portainer:
    image: portainer/portainer:latest
    container_name: portainer
    restart: always
    ports:
      - 90070:9000
      - 9090:8000
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./portainer_data:/data

```
Więcej przydatnych obrazów Dockera do użytku domowego można znaleźć w sekcji [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Krok 3: Rozpoczęcie pracy z portmonetką
W tym kroku mogę również dobrze wykorzystać konsolę. Uruchamiam serwer portainer za pomocą aplikacji Docker Compose.
{{< terminal >}}
sudo docker-compose -f portainer.yml up -d

{{</ terminal >}}
Następnie mogę wywołać mój serwer Portainer, podając adres IP stacji dysków i przypisany port z "Kroku 2". Wprowadzam hasło administratora i wybieram wariant lokalny.
{{< gallery match="images/4/*.png" >}}
Jak widać, wszystko działa świetnie!
{{< gallery match="images/5/*.png" >}}
