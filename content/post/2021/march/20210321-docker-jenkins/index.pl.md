+++
date = "2021-03-21"
title = "Wspaniałe rzeczy z kontenerami: Uruchamianie Jenkinsa na Synology DS"
difficulty = "level-3"
tags = ["build", "devops", "diskstation", "java", "javascript", "Jenkins", "nas", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-docker-jenkins/index.pl.md"
+++

## Krok 1: Przygotuj Synology
Najpierw należy aktywować logowanie SSH na serwerze DiskStation. W tym celu należy przejść do "Panelu sterowania" > "Terminal
{{< gallery match="images/1/*.png" >}}
Następnie można zalogować się przez "SSH", podany port i hasło administratora (użytkownicy systemu Windows używają Putty lub WinSCP).
{{< gallery match="images/2/*.png" >}}
Loguję się za pomocą Terminala, winSCP lub Putty i zostawiam tę konsolę otwartą na później.
## Krok 2: Przygotuj folder Docker
W katalogu Docker tworzę nowy katalog o nazwie "jenkins".
{{< gallery match="images/3/*.png" >}}
Następnie przechodzę do nowego katalogu i tworzę nowy folder "data":
{{< terminal >}}
sudo mkdir data

{{</ terminal >}}
Tworzę również plik o nazwie "jenkins.yml" o następującej zawartości. Przednia część portu "8081:" może być regulowana.
```
version: '2.0'
services:
  jenkins:
    restart: always
    image: jenkins/jenkins:lts
    privileged: true
    user: root
    ports:
      - 8081:8080
    container_name: jenkins
    volumes:
      - ./data:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
      - /usr/local/bin/docker:/usr/local/bin/docker

```

## Krok 3: Start
W tym kroku mogę również dobrze wykorzystać konsolę. Serwer Jenkinsa uruchamiam za pomocą aplikacji Docker Compose.
{{< terminal >}}
sudo docker-compose -f jenkins.yml up -d

{{</ terminal >}}
Następnie mogę połączyć się z serwerem Jenkinsa, podając adres IP stacji dysków i przypisany port z "Kroku 2".
{{< gallery match="images/4/*.png" >}}

## Krok 4: Konfiguracja

{{< gallery match="images/5/*.png" >}}
Ponownie używam konsoli, aby odczytać początkowe hasło:
{{< terminal >}}
cat data/secrets/initialAdminPassword

{{</ terminal >}}
Zobacz:
{{< gallery match="images/6/*.png" >}}
Wybrałem opcję "Instalacja zalecana".
{{< gallery match="images/7/*.png" >}}

## Krok 5: Moja pierwsza praca
Loguję się i tworzę zadanie Docker.
{{< gallery match="images/8/*.png" >}}
Jak widać, wszystko działa świetnie!
{{< gallery match="images/9/*.png" >}}
