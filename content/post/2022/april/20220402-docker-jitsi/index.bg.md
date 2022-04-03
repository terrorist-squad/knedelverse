+++
date = "2022-04-02"
title = "Големи неща с контейнери: инсталиране на Jitsy"
difficulty = "level-5"
tags = ["Jitsi", "docker", "docker-compose", "meeting", "video", "server", "synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/april/20220402-docker-jitsi/index.bg.md"
+++
С Jitsi можете да създадете и внедрите сигурно решение за видеоконферентна връзка. Днес ще покажа как да инсталирате услуга Jitsi на сървър, справка: https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker/ .
## Стъпка 1: Създаване на папка "jitsi"
Създавам нова директория, наречена "jitsi", за инсталацията.
{{< terminal >}}
mkdir jitsi/
wget https://github.com/jitsi/docker-jitsi-meet/archive/refs/tags/stable-7001.zip
unzip  stable-7001.zip -d jitsi/
rm stable-7001.zip 
cd /docker/jitsi/docker-jitsi-meet-stable-7001

{{</ terminal >}}

## Стъпка 2: Конфигуриране
Сега копирам стандартната конфигурация и я адаптирам.
{{< terminal >}}
cp env.example .env

{{</ terminal >}}
Вижте:
{{< gallery match="images/1/*.png" >}}
За да използвате силни пароли в опциите за сигурност на .env файла, трябва да се изпълни веднъж следният bash скрипт.
{{< terminal >}}
./gen-passwords.sh

{{</ terminal >}}
Сега ще създам още няколко папки за Jitsi.
{{< terminal >}}
mkdir -p ./jitsi-meet-cfg/{web/crontabs,web/letsencrypt,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}

{{</ terminal >}}
След това може да се стартира сървърът Jitsi.
{{< terminal >}}
docker-compose up

{{</ terminal >}}
След това можете да използвате сървъра Jitsi!
{{< gallery match="images/2/*.png" >}}

