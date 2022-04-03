+++
date = "2022-04-02"
title = "Великие дела с контейнерами: установка Jitsy"
difficulty = "level-5"
tags = ["Jitsi", "docker", "docker-compose", "meeting", "video", "server", "synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2022/april/20220402-docker-jitsi/index.ru.md"
+++
С помощью Jitsi вы можете создать и развернуть безопасное решение для видеоконференций. Сегодня я покажу, как установить службу Jitsi на сервер, ссылка: https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-docker/ .
## Шаг 1: Создайте папку "jitsi"
Я создаю новый каталог под названием "jitsi" для установки.
{{< terminal >}}
mkdir jitsi/
wget https://github.com/jitsi/docker-jitsi-meet/archive/refs/tags/stable-7001.zip
unzip  stable-7001.zip -d jitsi/
rm stable-7001.zip 
cd /docker/jitsi/docker-jitsi-meet-stable-7001

{{</ terminal >}}

## Шаг 2: Конфигурация
Теперь я копирую стандартную конфигурацию и адаптирую ее.
{{< terminal >}}
cp env.example .env

{{</ terminal >}}
См:
{{< gallery match="images/1/*.png" >}}
Чтобы использовать надежные пароли в параметрах безопасности файла .env, необходимо один раз запустить следующий сценарий bash.
{{< terminal >}}
./gen-passwords.sh

{{</ terminal >}}
Теперь я создам еще несколько папок для Jitsi.
{{< terminal >}}
mkdir -p ./jitsi-meet-cfg/{web/crontabs,web/letsencrypt,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}

{{</ terminal >}}
После этого можно запускать сервер Jitsi.
{{< terminal >}}
docker-compose up

{{</ terminal >}}
После этого вы можете использовать сервер Jitsi!
{{< gallery match="images/2/*.png" >}}

