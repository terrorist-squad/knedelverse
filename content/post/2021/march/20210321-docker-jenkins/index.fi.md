+++
date = "2021-03-21"
title = "Suuria asioita konttien avulla: Jenkinsin käyttäminen Synology DS:llä"
difficulty = "level-3"
tags = ["build", "devops", "diskstation", "java", "javascript", "Jenkins", "nas", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-docker-jenkins/index.fi.md"
+++

## Vaihe 1: Synologyn valmistelu
Ensin SSH-kirjautuminen on aktivoitava DiskStationissa. Tee tämä menemällä "Ohjauspaneeli" > "Pääte" > "Pääte".
{{< gallery match="images/1/*.png" >}}
Sitten voit kirjautua sisään "SSH:n", määritetyn portin ja järjestelmänvalvojan salasanan kautta (Windows-käyttäjät käyttävät Puttya tai WinSCP:tä).
{{< gallery match="images/2/*.png" >}}
Kirjaudun sisään terminaalin, winSCP:n tai Puttyn kautta ja jätän tämän konsolin auki myöhempää käyttöä varten.
## Vaihe 2: Valmistele Docker-kansio
Luon Docker-hakemistoon uuden hakemiston nimeltä "jenkins".
{{< gallery match="images/3/*.png" >}}
Sitten vaihdan uuteen hakemistoon ja luon uuden kansion "data":
{{< terminal >}}
sudo mkdir data

{{</ terminal >}}
Luon myös tiedoston nimeltä "jenkins.yml", jonka sisältö on seuraava. Portin "8081:" etuosaa voidaan säätää.
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

## Vaihe 3: Aloita
Voin myös hyödyntää konsolia tässä vaiheessa. Käynnistän Jenkins-palvelimen Docker Composen kautta.
{{< terminal >}}
sudo docker-compose -f jenkins.yml up -d

{{</ terminal >}}
Tämän jälkeen voin soittaa Jenkins-palvelimelle levyaseman IP-osoitteella ja vaiheessa 2 määritetyllä portilla.
{{< gallery match="images/4/*.png" >}}

## Vaihe 4: Asennus

{{< gallery match="images/5/*.png" >}}
Käytän jälleen konsolia alkuperäisen salasanan lukemiseen:
{{< terminal >}}
cat data/secrets/initialAdminPassword

{{</ terminal >}}
Katso:
{{< gallery match="images/6/*.png" >}}
Olen valinnut "Suositeltava asennus".
{{< gallery match="images/7/*.png" >}}

## Vaihe 5: Ensimmäinen työpaikka
Kirjaudun sisään ja luon Docker-työni.
{{< gallery match="images/8/*.png" >}}
Kuten näet, kaikki toimii hienosti!
{{< gallery match="images/9/*.png" >}}