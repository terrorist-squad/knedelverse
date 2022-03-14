+++
date = "2021-03-21"
title = "Geweldige dingen met containers: Jenkins draaien op de Synology DS"
difficulty = "level-3"
tags = ["build", "devops", "diskstation", "java", "javascript", "Jenkins", "nas", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210321-docker-jenkins/index.nl.md"
+++

## Stap 1: Synology voorbereiden
Eerst moet de SSH-aanmelding op het DiskStation worden geactiveerd. Om dit te doen, ga naar het "Configuratiescherm" > "Terminal
{{< gallery match="images/1/*.png" >}}
Vervolgens kunt u inloggen via "SSH", de opgegeven poort en het beheerderswachtwoord (Windows-gebruikers gebruiken Putty of WinSCP).
{{< gallery match="images/2/*.png" >}}
Ik log in via Terminal, winSCP of Putty en laat deze console open voor later.
## Stap 2: Docker map klaarmaken
Ik maak een nieuwe directory genaamd "jenkins" in de Docker directory.
{{< gallery match="images/3/*.png" >}}
Dan ga ik naar de nieuwe map en maak een nieuwe map "data":
{{< terminal >}}
sudo mkdir data

{{</ terminal >}}
Ik maak ook een bestand aan genaamd "jenkins.yml" met de volgende inhoud. Het voorste deel van de poort "8081:" kan worden aangepast.
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

## Stap 3: Start
Ik kan ook goed gebruik maken van de console in deze stap. Ik start de Jenkins server via Docker Compose.
{{< terminal >}}
sudo docker-compose -f jenkins.yml up -d

{{</ terminal >}}
Daarna kan ik mijn Jenkins server oproepen met het IP van het diskstation en de toegewezen poort uit "Stap 2".
{{< gallery match="images/4/*.png" >}}

## Stap 4: Instelling

{{< gallery match="images/5/*.png" >}}
Nogmaals, ik gebruik de console om het initiële wachtwoord uit te lezen:
{{< terminal >}}
cat data/secrets/initialAdminPassword

{{</ terminal >}}
Zie:
{{< gallery match="images/6/*.png" >}}
Ik heb de "Aanbevolen installatie" geselecteerd.
{{< gallery match="images/7/*.png" >}}

## Stap 5: Mijn eerste baan
Ik log in en maak mijn Docker job aan.
{{< gallery match="images/8/*.png" >}}
Zoals u kunt zien, werkt alles geweldig!
{{< gallery match="images/9/*.png" >}}