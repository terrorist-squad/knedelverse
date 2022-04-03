+++
date = "2022-04-02"
title = "Store ting med containere: Installation af Jitsy"
difficulty = "level-5"
tags = ["Jitsi", "docker", "docker-compose", "meeting", "video", "server", "synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/april/20220402-docker-jitsi/index.da.md"
+++
Med Jitsi kan du oprette og implementere en sikker videokonferenceløsning. I dag viser jeg, hvordan man installerer en Jitsi-tjeneste på en server, reference: https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker/ .
## Trin 1: Opret mappen "jitsi"
Jeg opretter en ny mappe med navnet "jitsi" til installationen.
{{< terminal >}}
mkdir jitsi/
wget https://github.com/jitsi/docker-jitsi-meet/archive/refs/tags/stable-7001.zip
unzip  stable-7001.zip -d jitsi/
rm stable-7001.zip 
cd /docker/jitsi/docker-jitsi-meet-stable-7001

{{</ terminal >}}

## Trin 2: Konfiguration
Nu kopierer jeg standardkonfigurationen og tilpasser den.
{{< terminal >}}
cp env.example .env

{{</ terminal >}}
Se:
{{< gallery match="images/1/*.png" >}}
For at bruge stærke adgangskoder i sikkerhedsindstillingerne i .env-filen skal følgende bash-script køres én gang.
{{< terminal >}}
./gen-passwords.sh

{{</ terminal >}}
Nu opretter jeg et par mapper mere til Jitsi.
{{< terminal >}}
mkdir -p ./jitsi-meet-cfg/{web/crontabs,web/letsencrypt,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}

{{</ terminal >}}
Jitsi-serveren kan derefter startes.
{{< terminal >}}
docker-compose up

{{</ terminal >}}
Herefter kan du bruge Jitsi-serveren!
{{< gallery match="images/2/*.png" >}}

