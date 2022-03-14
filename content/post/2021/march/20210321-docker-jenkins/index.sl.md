+++
date = "2021-03-21"
title = "Velike stvari s kontejnerji: Zagon programa Jenkins na strežniku Synology DS"
difficulty = "level-3"
tags = ["build", "devops", "diskstation", "java", "javascript", "Jenkins", "nas", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210321-docker-jenkins/index.sl.md"
+++

## Korak 1: Pripravite Synology
Najprej je treba na napravi DiskStation aktivirati prijavo SSH. To storite tako, da greste v "Nadzorna plošča" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Nato se lahko prijavite prek SSH, določenih vrat in skrbniškega gesla (uporabniki Windows uporabljajo Putty ali WinSCP).
{{< gallery match="images/2/*.png" >}}
Prijavim se prek terminala, winSCP ali Puttyja in pustim to konzolo odprto za pozneje.
## Korak 2: Pripravite mapo Docker
V imeniku Docker ustvarim nov imenik z imenom "jenkins".
{{< gallery match="images/3/*.png" >}}
Nato preidem v nov imenik in ustvarim novo mapo "podatki":
{{< terminal >}}
sudo mkdir data

{{</ terminal >}}
Ustvarim tudi datoteko z imenom "jenkins.yml" z naslednjo vsebino. Sprednji del vrat "8081:" je mogoče prilagoditi.
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

## Korak 3: Začetek
V tem koraku lahko dobro izkoristim tudi konzolo. Strežnik Jenkins zaženem prek programa Docker Compose.
{{< terminal >}}
sudo docker-compose -f jenkins.yml up -d

{{</ terminal >}}
Nato lahko pokličem strežnik Jenkins z IP diskovne postaje in dodeljenimi vrati iz koraka 2.
{{< gallery match="images/4/*.png" >}}

## Korak 4: Nastavitev

{{< gallery match="images/5/*.png" >}}
Za branje začetnega gesla ponovno uporabim konzolo:
{{< terminal >}}
cat data/secrets/initialAdminPassword

{{</ terminal >}}
Oglejte si:
{{< gallery match="images/6/*.png" >}}
Izbral sem možnost "Priporočena namestitev".
{{< gallery match="images/7/*.png" >}}

## 5. korak: Moja prva zaposlitev
Prijavim se in ustvarim svoje opravilo Docker.
{{< gallery match="images/8/*.png" >}}
Kot lahko vidite, vse deluje odlično!
{{< gallery match="images/9/*.png" >}}