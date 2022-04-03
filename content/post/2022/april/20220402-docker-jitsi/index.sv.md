+++
date = "2022-04-02"
title = "Stora saker med behållare: Installera Jitsy"
difficulty = "level-5"
tags = ["Jitsi", "docker", "docker-compose", "meeting", "video", "server", "synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/april/20220402-docker-jitsi/index.sv.md"
+++
Med Jitsi kan du skapa och distribuera en säker videokonferenslösning. Idag visar jag hur man installerar en Jitsi-tjänst på en server, referens: https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker/ .
## Steg 1: Skapa mappen "jitsi".
Jag skapar en ny katalog med namnet "jitsi" för installationen.
{{< terminal >}}
mkdir jitsi/
wget https://github.com/jitsi/docker-jitsi-meet/archive/refs/tags/stable-7001.zip
unzip  stable-7001.zip -d jitsi/
rm stable-7001.zip 
cd /docker/jitsi/docker-jitsi-meet-stable-7001

{{</ terminal >}}

## Steg 2: Konfiguration
Nu kopierar jag standardkonfigurationen och anpassar den.
{{< terminal >}}
cp env.example .env

{{</ terminal >}}
Se:
{{< gallery match="images/1/*.png" >}}
För att använda starka lösenord i säkerhetsalternativen i .env-filen ska följande bash-skript köras en gång.
{{< terminal >}}
./gen-passwords.sh

{{</ terminal >}}
Nu skapar jag ytterligare några mappar för Jitsi.
{{< terminal >}}
mkdir -p ./jitsi-meet-cfg/{web/crontabs,web/letsencrypt,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}

{{</ terminal >}}
Jitsi-servern kan sedan startas.
{{< terminal >}}
docker-compose up

{{</ terminal >}}
Därefter kan du använda Jitsi-servern!
{{< gallery match="images/2/*.png" >}}

