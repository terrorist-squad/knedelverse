+++
date = "2022-04-02"
title = "Lucruri grozave cu containere: Instalarea Jitsy"
difficulty = "level-5"
tags = ["Jitsi", "docker", "docker-compose", "meeting", "video", "server", "synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/april/20220402-docker-jitsi/index.ro.md"
+++
Cu Jitsi puteți crea și implementa o soluție de videoconferință securizată. Astăzi vă arăt cum să instalați un serviciu Jitsi pe un server, referință: https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker/ .
## Pasul 1: Creați folderul "jitsi"
Creez un nou director numit "jitsi" pentru instalare.
{{< terminal >}}
mkdir jitsi/
wget https://github.com/jitsi/docker-jitsi-meet/archive/refs/tags/stable-7001.zip
unzip  stable-7001.zip -d jitsi/
rm stable-7001.zip 
cd /docker/jitsi/docker-jitsi-meet-stable-7001

{{</ terminal >}}

## Pasul 2: Configurarea
Acum copiez configurația standard și o adaptez.
{{< terminal >}}
cp env.example .env

{{</ terminal >}}
A se vedea:
{{< gallery match="images/1/*.png" >}}
Pentru a utiliza parole puternice în opțiunile de securitate ale fișierului .env, următorul script bash trebuie executat o singură dată.
{{< terminal >}}
./gen-passwords.sh

{{</ terminal >}}
Acum voi mai crea câteva dosare pentru Jitsi.
{{< terminal >}}
mkdir -p ./jitsi-meet-cfg/{web/crontabs,web/letsencrypt,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}

{{</ terminal >}}
Serverul Jitsi poate fi apoi pornit.
{{< terminal >}}
docker-compose up

{{</ terminal >}}
După aceea, puteți utiliza serverul Jitsi!
{{< gallery match="images/2/*.png" >}}

