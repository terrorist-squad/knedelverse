+++
date = "2022-04-02"
title = "Veľké veci s kontajnermi: Inštalácia Jitsy"
difficulty = "level-5"
tags = ["Jitsi", "docker", "docker-compose", "meeting", "video", "server", "synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/april/20220402-docker-jitsi/index.sk.md"
+++
Pomocou Jitsi môžete vytvoriť a nasadiť bezpečné videokonferenčné riešenie. Dnes ukážem, ako nainštalovať službu Jitsi na server, odkaz: https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker/ .
## Krok 1: Vytvorenie priečinka "jitsi"
Pre inštaláciu vytvorím nový adresár s názvom "jitsi".
{{< terminal >}}
mkdir jitsi/
wget https://github.com/jitsi/docker-jitsi-meet/archive/refs/tags/stable-7001.zip
unzip  stable-7001.zip -d jitsi/
rm stable-7001.zip 
cd /docker/jitsi/docker-jitsi-meet-stable-7001

{{</ terminal >}}

## Krok 2: Konfigurácia
Teraz skopírujem štandardnú konfiguráciu a prispôsobím ju.
{{< terminal >}}
cp env.example .env

{{</ terminal >}}
Pozri:
{{< gallery match="images/1/*.png" >}}
Ak chcete použiť silné heslá v bezpečnostných možnostiach súboru .env, je potrebné raz spustiť nasledujúci skript bash.
{{< terminal >}}
./gen-passwords.sh

{{</ terminal >}}
Teraz vytvorím niekoľko ďalších priečinkov pre Jitsi.
{{< terminal >}}
mkdir -p ./jitsi-meet-cfg/{web/crontabs,web/letsencrypt,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}

{{</ terminal >}}
Potom je možné spustiť server Jitsi.
{{< terminal >}}
docker-compose up

{{</ terminal >}}
Potom môžete používať server Jitsi!
{{< gallery match="images/2/*.png" >}}

