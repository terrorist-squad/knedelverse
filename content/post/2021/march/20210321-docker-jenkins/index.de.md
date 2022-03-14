+++
date = "2021-03-21"
title = "Großartiges mit Containern: Jenkins auf der Synology-DS betreiben"
difficulty = "level-3"
tags = ["build", "devops", "diskstation", "java", "javascript", "Jenkins", "nas", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-docker-jenkins/index.de.md"
+++

## Schritt 1: Synology vorbereiten
Als erstes muss der SSH-Login auf der Diskstation aktiviert werden. Dazu geht man in die „Systemsteuerung“ > „Terminal & SNMP“ und aktiviert dort die „SSH-Dienst aktivieren“-Einstellung.
{{< gallery match="images/1/*.png" >}}

Danach kann man sich via „SSH„, den angegebenen Port und den Administrator-Password anmelden (Windows-Nutzer nehmen Putty oder WinSCP).
{{< gallery match="images/2/*.png" >}}

Ich logge mich via Terminal, winSCP oder Putty ein und lasse diese Konsole erst einmal für später offen.

## Schritt 2: Docker-Ordner vorbereiten
Ich erstelle ein neues Verzeichnis namens „jenkins“ im Docker-Verzeichnis. 
{{< gallery match="images/3/*.png" >}}

Danach wechsel ich in das neue Verzeichnis und erstelle einen neuen Ordner „data“:
{{< terminal >}}
sudo mkdir data
{{</ terminal >}}

Außerdem erstelle ich eine Datei namens „jenkins.yml“ mit folgendem Inhalt. Bei den Port kann der vordere Teil „8081:“ angepasst werden.
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

## Schritt 3: Start
Auch in diesem Schritt kann ich die Konsole gut gebrauchen. Ich starte den Jenkins-Server via Docker-Compose.
{{< terminal >}}
sudo docker-compose -f jenkins.yml up -d
{{</ terminal >}}

Danach kann ich meinen Jenkins-Server mit der IP der Diskstation und den vergeben Port aus „Schritt 2“ aufrufen.
{{< gallery match="images/4/*.png" >}}

## Schritt 4: Einrichtung
{{< gallery match="images/5/*.png" >}}

Auch hier verwende ich die Konsole, um das initiale Password auszulesen:
{{< terminal >}}
cat data/secrets/initialAdminPassword
{{</ terminal >}}

Siehe:
{{< gallery match="images/6/*.png" >}}

Ich habe die „Empfohlene Installation“ gewählt.
{{< gallery match="images/7/*.png" >}}

## Schritt 5: Mein erster Job
Ich logge mich ein und erstelle meinen Docker-Job.
{{< gallery match="images/8/*.png" >}}

Wie man sehen kann, funktioniert alles prima!
{{< gallery match="images/9/*.png" >}}