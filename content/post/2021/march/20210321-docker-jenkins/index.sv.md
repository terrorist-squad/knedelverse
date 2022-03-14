+++
date = "2021-03-21"
title = "Stora saker med behållare: Kör Jenkins på Synology DS"
difficulty = "level-3"
tags = ["build", "devops", "diskstation", "java", "javascript", "Jenkins", "nas", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210321-docker-jenkins/index.sv.md"
+++

## Steg 1: Förbered Synology
Först måste SSH-inloggningen aktiveras på DiskStationen. Detta gör du genom att gå till "Kontrollpanelen" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Därefter kan du logga in via "SSH", den angivna porten och administratörslösenordet (Windows-användare använder Putty eller WinSCP).
{{< gallery match="images/2/*.png" >}}
Jag loggar in via Terminal, winSCP eller Putty och lämnar denna konsol öppen för senare.
## Steg 2: Förbered Docker-mappen
Jag skapar en ny katalog som heter "jenkins" i Docker-katalogen.
{{< gallery match="images/3/*.png" >}}
Sedan byter jag till den nya katalogen och skapar en ny mapp "data":
{{< terminal >}}
sudo mkdir data

{{</ terminal >}}
Jag skapar också en fil som heter "jenkins.yml" med följande innehåll. Den främre delen av porten "8081:" kan justeras.
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

## Steg 3: Starta
Jag kan också utnyttja konsolen i det här steget. Jag startar Jenkins-servern via Docker Compose.
{{< terminal >}}
sudo docker-compose -f jenkins.yml up -d

{{</ terminal >}}
Därefter kan jag ringa min Jenkins-server med diskstationens IP och den tilldelade porten från "Steg 2".
{{< gallery match="images/4/*.png" >}}

## Steg 4: Inställning

{{< gallery match="images/5/*.png" >}}
Återigen använder jag konsolen för att läsa upp det ursprungliga lösenordet:
{{< terminal >}}
cat data/secrets/initialAdminPassword

{{</ terminal >}}
Se:
{{< gallery match="images/6/*.png" >}}
Jag har valt "Rekommenderad installation".
{{< gallery match="images/7/*.png" >}}

## Steg 5: Mitt första jobb
Jag loggar in och skapar mitt Docker-jobb.
{{< gallery match="images/8/*.png" >}}
Som du kan se fungerar allt utmärkt!
{{< gallery match="images/9/*.png" >}}