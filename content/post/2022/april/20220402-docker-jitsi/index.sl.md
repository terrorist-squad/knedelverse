+++
date = "2022-04-02"
title = "Velike stvari z zabojniki: namestitev Jitsyja"
difficulty = "level-5"
tags = ["Jitsi", "docker", "docker-compose", "meeting", "video", "server", "synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/april/20220402-docker-jitsi/index.sl.md"
+++
Z Jitsijem lahko ustvarite in namestite varno rešitev za videokonference. Danes prikazujem, kako namestiti storitev Jitsi v strežnik, referenca: https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker/ .
## Korak 1: Ustvarite mapo "jitsi"
Za namestitev ustvarim nov imenik z imenom "jitsi".
{{< terminal >}}
mkdir jitsi/
wget https://github.com/jitsi/docker-jitsi-meet/archive/refs/tags/stable-7001.zip
unzip  stable-7001.zip -d jitsi/
rm stable-7001.zip 
cd /docker/jitsi/docker-jitsi-meet-stable-7001

{{</ terminal >}}

## Korak 2: Konfiguracija
Zdaj kopiram standardno konfiguracijo in jo prilagodim.
{{< terminal >}}
cp env.example .env

{{</ terminal >}}
Oglejte si:
{{< gallery match="images/1/*.png" >}}
Za uporabo močnih gesel v varnostnih možnostih datoteke .env je treba enkrat zagnati naslednjo skripto bash.
{{< terminal >}}
./gen-passwords.sh

{{</ terminal >}}
Zdaj bom ustvaril še nekaj map za Jitsi.
{{< terminal >}}
mkdir -p ./jitsi-meet-cfg/{web/crontabs,web/letsencrypt,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}

{{</ terminal >}}
Nato lahko zaženete strežnik Jitsi.
{{< terminal >}}
docker-compose up

{{</ terminal >}}
Nato lahko uporabite strežnik Jitsi!
{{< gallery match="images/2/*.png" >}}

