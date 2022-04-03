+++
date = "2022-04-02"
title = "Grote dingen met containers: Jitsy installeren"
difficulty = "level-5"
tags = ["Jitsi", "docker", "docker-compose", "meeting", "video", "server", "synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/april/20220402-docker-jitsi/index.nl.md"
+++
Met Jitsi kunt u een veilige videoconferencing-oplossing creëren en implementeren. Vandaag laat ik zien hoe je een Jitsi service op een server installeert, referentie: https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker/ .
## Stap 1: Maak de "jitsi" map aan
Ik maak een nieuwe directory genaamd "jitsi" voor de installatie.
{{< terminal >}}
mkdir jitsi/
wget https://github.com/jitsi/docker-jitsi-meet/archive/refs/tags/stable-7001.zip
unzip  stable-7001.zip -d jitsi/
rm stable-7001.zip 
cd /docker/jitsi/docker-jitsi-meet-stable-7001

{{</ terminal >}}

## Stap 2: Configuratie
Nu kopieer ik de standaard configuratie en pas het aan.
{{< terminal >}}
cp env.example .env

{{</ terminal >}}
Zie:
{{< gallery match="images/1/*.png" >}}
Om sterke wachtwoorden te gebruiken in de beveiligingsopties van het .env bestand, moet het volgende bash script eenmalig worden uitgevoerd.
{{< terminal >}}
./gen-passwords.sh

{{</ terminal >}}
Nu zal ik nog een paar mappen maken voor Jitsi.
{{< terminal >}}
mkdir -p ./jitsi-meet-cfg/{web/crontabs,web/letsencrypt,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}

{{</ terminal >}}
De Jitsi server kan dan worden opgestart.
{{< terminal >}}
docker-compose up

{{</ terminal >}}
Daarna kunt u de Jitsi server gebruiken!
{{< gallery match="images/2/*.png" >}}

