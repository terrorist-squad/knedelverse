+++
date = "2022-04-02"
title = "Velké věci s kontejnery: Instalace Jitsy"
difficulty = "level-5"
tags = ["Jitsi", "docker", "docker-compose", "meeting", "video", "server", "synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/april/20220402-docker-jitsi/index.cs.md"
+++
Pomocí Jitsi můžete vytvořit a nasadit bezpečné videokonferenční řešení. Dnes ukážu, jak nainstalovat službu Jitsi na server, odkaz: https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker/ .
## Krok 1: Vytvoření složky "jitsi"
Pro instalaci vytvořím nový adresář s názvem "jitsi".
{{< terminal >}}
mkdir jitsi/
wget https://github.com/jitsi/docker-jitsi-meet/archive/refs/tags/stable-7001.zip
unzip  stable-7001.zip -d jitsi/
rm stable-7001.zip 
cd /docker/jitsi/docker-jitsi-meet-stable-7001

{{</ terminal >}}

## Krok 2: Konfigurace
Nyní zkopíruji standardní konfiguraci a přizpůsobím ji.
{{< terminal >}}
cp env.example .env

{{</ terminal >}}
Viz:
{{< gallery match="images/1/*.png" >}}
Chcete-li použít silná hesla v možnostech zabezpečení souboru .env, je třeba jednou spustit následující skript bash.
{{< terminal >}}
./gen-passwords.sh

{{</ terminal >}}
Nyní vytvořím několik dalších složek pro Jitsi.
{{< terminal >}}
mkdir -p ./jitsi-meet-cfg/{web/crontabs,web/letsencrypt,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}

{{</ terminal >}}
Poté lze spustit server Jitsi.
{{< terminal >}}
docker-compose up

{{</ terminal >}}
Poté můžete používat server Jitsi!
{{< gallery match="images/2/*.png" >}}

