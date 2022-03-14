+++
date = "2021-04-25T09:28:11+01:00"
title = "Страхотни неща с контейнери: Portainer като алтернатива на Synology Docker GUI"
difficulty = "level-3"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Portainer/index.bg.md"
+++

## Стъпка 1: Подготовка на Synology
Първо, SSH входът трябва да бъде активиран на DiskStation. За да направите това, отидете в "Контролен панел" > "Терминал
{{< gallery match="images/1/*.png" >}}
След това можете да влезете в системата чрез "SSH", посочения порт и паролата на администратора (потребителите на Windows използват Putty или WinSCP).
{{< gallery match="images/2/*.png" >}}
Влизам в системата чрез терминал, winSCP или Putty и оставям тази конзола отворена за по-късно.
## Стъпка 2: Създаване на папка с контейнери
Създавам нова директория, наречена "portainer", в директорията на Docker.
{{< gallery match="images/3/*.png" >}}
След това отивам в директорията portainer с конзолата и създавам там папка и нов файл, наречен "portainer.yml".
{{< terminal >}}
cd /volume1/docker/portainer
mkdir portainer_data
vim portainer.yml

{{</ terminal >}}
Ето съдържанието на файла "portainer.yml":
```
version: '3'

services:
  portainer:
    image: portainer/portainer:latest
    container_name: portainer
    restart: always
    ports:
      - 90070:9000
      - 9090:8000
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./portainer_data:/data

```
Още полезни образи на Docker за домашна употреба можете да намерите в [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Стъпка 3: Стартиране на завесата
В тази стъпка мога да използвам добре и конзолата. Стартирам сървъра portainer чрез Docker Compose.
{{< terminal >}}
sudo docker-compose -f portainer.yml up -d

{{</ terminal >}}
След това мога да извикам сървъра Portainer с IP адреса на дисковата станция и назначения порт от стъпка 2. Въвеждам паролата си за администратор и избирам локалния вариант.
{{< gallery match="images/4/*.png" >}}
Както можете да видите, всичко работи чудесно!
{{< gallery match="images/5/*.png" >}}