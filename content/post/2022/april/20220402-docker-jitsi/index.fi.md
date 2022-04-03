+++
date = "2022-04-02"
title = "Suuria asioita säiliöillä: Jitsyn asentaminen"
difficulty = "level-5"
tags = ["Jitsi", "docker", "docker-compose", "meeting", "video", "server", "synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/april/20220402-docker-jitsi/index.fi.md"
+++
Jitsin avulla voit luoda ja ottaa käyttöön turvallisen videoneuvotteluratkaisun. Tänään näytän, miten Jitsi-palvelu asennetaan palvelimelle, viite: https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker/ .
## Vaihe 1: Luo "jitsi"-kansio
Luon asennusta varten uuden hakemiston nimeltä "jitsi".
{{< terminal >}}
mkdir jitsi/
wget https://github.com/jitsi/docker-jitsi-meet/archive/refs/tags/stable-7001.zip
unzip  stable-7001.zip -d jitsi/
rm stable-7001.zip 
cd /docker/jitsi/docker-jitsi-meet-stable-7001

{{</ terminal >}}

## Vaihe 2: Konfigurointi
Nyt kopioin vakiokokoonpanon ja mukautan sitä.
{{< terminal >}}
cp env.example .env

{{</ terminal >}}
Katso:
{{< gallery match="images/1/*.png" >}}
Jos haluat käyttää vahvoja salasanoja .env-tiedoston suojausasetuksissa, seuraava bash-skripti on ajettava kerran.
{{< terminal >}}
./gen-passwords.sh

{{</ terminal >}}
Nyt luon vielä muutaman kansion Jitsiä varten.
{{< terminal >}}
mkdir -p ./jitsi-meet-cfg/{web/crontabs,web/letsencrypt,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}

{{</ terminal >}}
Tämän jälkeen Jitsi-palvelin voidaan käynnistää.
{{< terminal >}}
docker-compose up

{{</ terminal >}}
Sen jälkeen voit käyttää Jitsi-palvelinta!
{{< gallery match="images/2/*.png" >}}

