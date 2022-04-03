+++
date = "2022-04-02"
title = "Großartiges mit Containern: Jitsy installieren"
difficulty = "level-5"
tags = ["Jitsi", "docker", "docker-compose", "meeting", "video", "server", "synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/april/20220402-docker-jitsi/index.de.md"
+++

Mit Jitsi können Sie eine sichere Videokonferenzlösungen erstellen und einsetzen können. Heute zeige ich, wie man einen Jitsi-Dienst auf einen Server installiert, 
Referenz: https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker/ .

## Schritt 1: "jitsi"-Ordner erstellen
Ich erstelle ein neues Verzeichnis namens „jitsi“ für die Installattion an.
{{< terminal >}}
mkdir jitsi/
wget https://github.com/jitsi/docker-jitsi-meet/archive/refs/tags/stable-7001.zip
unzip  stable-7001.zip -d jitsi/
rm stable-7001.zip 
cd /docker/jitsi/docker-jitsi-meet-stable-7001
{{</ terminal >}}

## Schritt 2: Konfiguration
Nun kopiere ich die Standard-Konfiguration und passe diese an.
{{< terminal >}}
cp env.example .env
{{</ terminal >}}
Siehe:
{{< gallery match="images/1/*.png" >}}

Um sichere Passwörter in den Sicherheitsoptionen der .env-Datei zu verwenden, sollte das folgende Bash-Skript einmal ausführt werden.
{{< terminal >}}
./gen-passwords.sh
{{</ terminal >}}

Nun erstelle ich noch ein paar Ordner für Jitsi.
{{< terminal >}}
mkdir -p ./jitsi-meet-cfg/{web/crontabs,web/letsencrypt,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}
{{</ terminal >}}

Anschließend kann der Jitsi-Server gestartet werden.
{{< terminal >}}
docker-compose up
{{</ terminal >}}

Danach kann man den Jitsi-Server verwenden!
{{< gallery match="images/2/*.png" >}}
