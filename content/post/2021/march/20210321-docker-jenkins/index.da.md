+++
date = "2021-03-21"
title = "Store ting med containere: Kørsel af Jenkins på Synology DS"
difficulty = "level-3"
tags = ["build", "devops", "diskstation", "java", "javascript", "Jenkins", "nas", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-docker-jenkins/index.da.md"
+++

## Trin 1: Forbered Synology
Først skal SSH-login være aktiveret på DiskStationen. Du kan gøre dette ved at gå til "Kontrolpanel" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Derefter kan du logge ind via "SSH", den angivne port og administratoradgangskoden (Windows-brugere bruger Putty eller WinSCP).
{{< gallery match="images/2/*.png" >}}
Jeg logger ind via Terminal, winSCP eller Putty og lader denne konsol være åben til senere.
## Trin 2: Forbered Docker-mappen
Jeg opretter en ny mappe med navnet "jenkins" i Docker-mappen.
{{< gallery match="images/3/*.png" >}}
Derefter skifter jeg til den nye mappe og opretter en ny mappe "data":
{{< terminal >}}
sudo mkdir data

{{</ terminal >}}
Jeg opretter også en fil med navnet "jenkins.yml" med følgende indhold. Den forreste del af porten "8081:" kan justeres.
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

## Trin 3: Start
Jeg kan også gøre god brug af konsollen i dette trin. Jeg starter Jenkins-serveren via Docker Compose.
{{< terminal >}}
sudo docker-compose -f jenkins.yml up -d

{{</ terminal >}}
Derefter kan jeg ringe til min Jenkins-server med diskstationens IP-nummer og den tildelte port fra "Trin 2".
{{< gallery match="images/4/*.png" >}}

## Trin 4: Opsætning

{{< gallery match="images/5/*.png" >}}
Igen bruger jeg konsollen til at læse den oprindelige adgangskode op:
{{< terminal >}}
cat data/secrets/initialAdminPassword

{{</ terminal >}}
Se:
{{< gallery match="images/6/*.png" >}}
Jeg har valgt "Anbefalet installation".
{{< gallery match="images/7/*.png" >}}

## Trin 5: Mit første job
Jeg logger ind og opretter mit Docker-job.
{{< gallery match="images/8/*.png" >}}
Som du kan se, fungerer alting fint!
{{< gallery match="images/9/*.png" >}}
