+++
date = "2021-03-21"
title = "Grandi cose con i container: eseguire Jenkins su Synology DS"
difficulty = "level-3"
tags = ["build", "devops", "diskstation", "java", "javascript", "Jenkins", "nas", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210321-docker-jenkins/index.it.md"
+++

## Passo 1: Preparare Synology
Innanzitutto, il login SSH deve essere attivato sulla DiskStation. Per farlo, andate nel "Pannello di controllo" > "Terminale
{{< gallery match="images/1/*.png" >}}
Poi si può accedere tramite "SSH", la porta specificata e la password dell'amministratore (gli utenti Windows usano Putty o WinSCP).
{{< gallery match="images/2/*.png" >}}
Mi collego tramite Terminale, winSCP o Putty e lascio questa console aperta per dopo.
## Passo 2: preparare la cartella Docker
Creo una nuova directory chiamata "jenkins" nella directory Docker.
{{< gallery match="images/3/*.png" >}}
Poi passo alla nuova directory e creo una nuova cartella "data":
{{< terminal >}}
sudo mkdir data

{{</ terminal >}}
Creo anche un file chiamato "jenkins.yml" con il seguente contenuto. La parte anteriore della porta "8081:" può essere regolata.
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

## Passo 3: Iniziare
Posso anche fare buon uso della console in questo passo. Avvio il server Jenkins tramite Docker Compose.
{{< terminal >}}
sudo docker-compose -f jenkins.yml up -d

{{</ terminal >}}
Dopo di che, posso chiamare il mio server Jenkins con l'IP della stazione disco e la porta assegnata dal "Passo 2".
{{< gallery match="images/4/*.png" >}}

## Passo 4: Impostazione

{{< gallery match="images/5/*.png" >}}
Di nuovo, uso la console per leggere la password iniziale:
{{< terminal >}}
cat data/secrets/initialAdminPassword

{{</ terminal >}}
Vedere:
{{< gallery match="images/6/*.png" >}}
Ho selezionato "Installazione consigliata".
{{< gallery match="images/7/*.png" >}}

## Passo 5: Il mio primo lavoro
Faccio il login e creo il mio lavoro Docker.
{{< gallery match="images/8/*.png" >}}
Come potete vedere, tutto funziona alla grande!
{{< gallery match="images/9/*.png" >}}