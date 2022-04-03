+++
date = "2022-04-02"
title = "Grandi cose con i contenitori: installare Jitsy"
difficulty = "level-5"
tags = ["Jitsi", "docker", "docker-compose", "meeting", "video", "server", "synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/april/20220402-docker-jitsi/index.it.md"
+++
Con Jitsi è possibile creare e distribuire una soluzione di videoconferenza sicura. Oggi mostro come installare un servizio Jitsi su un server, riferimento: https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker/ .
## Passo 1: creare la cartella "jitsi
Creo una nuova directory chiamata "jitsi" per l'installazione.
{{< terminal >}}
mkdir jitsi/
wget https://github.com/jitsi/docker-jitsi-meet/archive/refs/tags/stable-7001.zip
unzip  stable-7001.zip -d jitsi/
rm stable-7001.zip 
cd /docker/jitsi/docker-jitsi-meet-stable-7001

{{</ terminal >}}

## Passo 2: Configurazione
Ora copio la configurazione standard e la adatto.
{{< terminal >}}
cp env.example .env

{{</ terminal >}}
Vedere:
{{< gallery match="images/1/*.png" >}}
Per usare password forti nelle opzioni di sicurezza del file .env, il seguente script bash dovrebbe essere eseguito una volta.
{{< terminal >}}
./gen-passwords.sh

{{</ terminal >}}
Ora creerò qualche altra cartella per Jitsi.
{{< terminal >}}
mkdir -p ./jitsi-meet-cfg/{web/crontabs,web/letsencrypt,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}

{{</ terminal >}}
Il server Jitsi può quindi essere avviato.
{{< terminal >}}
docker-compose up

{{</ terminal >}}
Dopo di che puoi usare il server Jitsi!
{{< gallery match="images/2/*.png" >}}

