+++
date = "2021-03-21"
title = "Nagyszerű dolgok konténerekkel: Jenkins futtatása a Synology DS-en"
difficulty = "level-3"
tags = ["build", "devops", "diskstation", "java", "javascript", "Jenkins", "nas", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-docker-jenkins/index.hu.md"
+++

## 1. lépés: A Synology előkészítése
Először is aktiválni kell az SSH bejelentkezést a DiskStationön. Ehhez menjen a "Vezérlőpult" > "Terminál" > "Terminál" menüpontba.
{{< gallery match="images/1/*.png" >}}
Ezután bejelentkezhet az "SSH"-n keresztül, a megadott porton és a rendszergazdai jelszóval (Windows felhasználók a Putty vagy a WinSCP segítségével).
{{< gallery match="images/2/*.png" >}}
Terminal, winSCP vagy Putty segítségével jelentkezem be, és ezt a konzolt későbbre nyitva hagyom.
## 2. lépés: Docker mappa előkészítése
Létrehozok egy új könyvtárat "jenkins" néven a Docker könyvtárban.
{{< gallery match="images/3/*.png" >}}
Ezután átváltok az új könyvtárba, és létrehozok egy új "data" mappát:
{{< terminal >}}
sudo mkdir data

{{</ terminal >}}
Létrehozok egy "jenkins.yml" nevű fájlt is a következő tartalommal. A "8081:" port elülső része állítható.
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

## 3. lépés: Indítás
Ebben a lépésben is jól tudom használni a konzolt. A Jenkins-kiszolgálót a Docker Compose-on keresztül indítom el.
{{< terminal >}}
sudo docker-compose -f jenkins.yml up -d

{{</ terminal >}}
Ezután a Jenkins-kiszolgálót a lemezállomás IP-címével és a 2. lépésben megadott porttal hívhatom.
{{< gallery match="images/4/*.png" >}}

## 4. lépés: Beállítás

{{< gallery match="images/5/*.png" >}}
Ismét a konzol segítségével olvasom ki a kezdeti jelszót:
{{< terminal >}}
cat data/secrets/initialAdminPassword

{{</ terminal >}}
Lásd:
{{< gallery match="images/6/*.png" >}}
Az "Ajánlott telepítés" opciót választottam.
{{< gallery match="images/7/*.png" >}}

## 5. lépés: Az első munkám
Bejelentkezem és létrehozom a Docker-feladatomat.
{{< gallery match="images/8/*.png" >}}
Mint láthatod, minden remekül működik!
{{< gallery match="images/9/*.png" >}}
