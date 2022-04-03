+++
date = "2022-04-02"
title = "Nagyszerű dolgok konténerekkel: Jitsy telepítése"
difficulty = "level-5"
tags = ["Jitsi", "docker", "docker-compose", "meeting", "video", "server", "synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/april/20220402-docker-jitsi/index.hu.md"
+++
A Jitsi segítségével biztonságos videokonferencia-megoldást hozhat létre és telepíthet. Ma megmutatom, hogyan kell telepíteni egy Jitsi szolgáltatást egy szerverre, hivatkozás: https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker/ .
## 1. lépés: "jitsi" mappa létrehozása
Létrehozok egy új könyvtárat "jitsi" néven a telepítéshez.
{{< terminal >}}
mkdir jitsi/
wget https://github.com/jitsi/docker-jitsi-meet/archive/refs/tags/stable-7001.zip
unzip  stable-7001.zip -d jitsi/
rm stable-7001.zip 
cd /docker/jitsi/docker-jitsi-meet-stable-7001

{{</ terminal >}}

## 2. lépés: Konfiguráció
Most lemásolom a szabványos konfigurációt, és átdolgozom.
{{< terminal >}}
cp env.example .env

{{</ terminal >}}
Lásd:
{{< gallery match="images/1/*.png" >}}
Ahhoz, hogy erős jelszavakat használjunk az .env fájl biztonsági beállításaiban, a következő bash szkriptet egyszer kell futtatni.
{{< terminal >}}
./gen-passwords.sh

{{</ terminal >}}
Most létrehozok még néhány mappát Jitsi számára.
{{< terminal >}}
mkdir -p ./jitsi-meet-cfg/{web/crontabs,web/letsencrypt,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}

{{</ terminal >}}
A Jitsi-kiszolgáló ezután elindítható.
{{< terminal >}}
docker-compose up

{{</ terminal >}}
Ezután már használhatod a Jitsi szervert!
{{< gallery match="images/2/*.png" >}}

