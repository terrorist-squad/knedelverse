+++
date = "2022-04-02"
title = "Wielkie rzeczy z pojemnikami: instalacja Jitsy"
difficulty = "level-5"
tags = ["Jitsi", "docker", "docker-compose", "meeting", "video", "server", "synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/april/20220402-docker-jitsi/index.pl.md"
+++
Dzięki Jitsi można stworzyć i wdrożyć bezpieczne rozwiązanie do prowadzenia wideokonferencji. Dzisiaj pokażę, jak zainstalować usługę Jitsi na serwerze, odnośnik: https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker/ .
## Krok 1: Utwórz folder "jitsi".
W celu przeprowadzenia instalacji tworzę nowy katalog o nazwie "jitsi".
{{< terminal >}}
mkdir jitsi/
wget https://github.com/jitsi/docker-jitsi-meet/archive/refs/tags/stable-7001.zip
unzip  stable-7001.zip -d jitsi/
rm stable-7001.zip 
cd /docker/jitsi/docker-jitsi-meet-stable-7001

{{</ terminal >}}

## Krok 2: Konfiguracja
Teraz kopiuję standardową konfigurację i dostosowuję ją.
{{< terminal >}}
cp env.example .env

{{</ terminal >}}
Zobacz:
{{< gallery match="images/1/*.png" >}}
Aby używać silnych haseł w opcjach bezpieczeństwa pliku .env, należy raz uruchomić następujący skrypt basha.
{{< terminal >}}
./gen-passwords.sh

{{</ terminal >}}
Teraz utworzę kilka kolejnych folderów dla Jitsi.
{{< terminal >}}
mkdir -p ./jitsi-meet-cfg/{web/crontabs,web/letsencrypt,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}

{{</ terminal >}}
Następnie można uruchomić serwer Jitsi.
{{< terminal >}}
docker-compose up

{{</ terminal >}}
Następnie można korzystać z serwera Jitsi!
{{< gallery match="images/2/*.png" >}}

