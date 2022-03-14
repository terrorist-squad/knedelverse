+++
date = "2021-03-21"
title = "Страхотни неща с контейнери: стартиране на Jenkins на Synology DS"
difficulty = "level-3"
tags = ["build", "devops", "diskstation", "java", "javascript", "Jenkins", "nas", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/march/20210321-docker-jenkins/index.bg.md"
+++

## Стъпка 1: Подготовка на Synology
Първо, SSH входът трябва да бъде активиран на DiskStation. За да направите това, отидете в "Контролен панел" > "Терминал
{{< gallery match="images/1/*.png" >}}
След това можете да влезете в системата чрез "SSH", посочения порт и паролата на администратора (потребителите на Windows използват Putty или WinSCP).
{{< gallery match="images/2/*.png" >}}
Влизам в системата чрез терминал, winSCP или Putty и оставям тази конзола отворена за по-късно.
## Стъпка 2: Подготовка на папката Docker
Създавам нова директория, наречена "jenkins", в директорията на Docker.
{{< gallery match="images/3/*.png" >}}
След това преминавам в новата директория и създавам нова папка "data":
{{< terminal >}}
sudo mkdir data

{{</ terminal >}}
Също така създавам файл, наречен "jenkins.yml", със следното съдържание. Предната част на порта "8081:" може да се регулира.
```
version: '2.0'
services:
  jenkins:
    restart: always
    image: jenkins/jenkins:lts
    privileged: true
    user: root
    ports:
      - 8081:8080
    container_name: jenkins
    volumes:
      - ./data:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock
      - /usr/local/bin/docker:/usr/local/bin/docker

```

## Стъпка 3: Стартиране
В тази стъпка мога да използвам добре и конзолата. Стартирам сървъра Jenkins чрез Docker Compose.
{{< terminal >}}
sudo docker-compose -f jenkins.yml up -d

{{</ terminal >}}
След това мога да се обадя на моя сървър Jenkins с IP адреса на дисковата станция и назначения порт от стъпка 2.
{{< gallery match="images/4/*.png" >}}

## Стъпка 4: Настройка

{{< gallery match="images/5/*.png" >}}
Отново използвам конзолата, за да прочета първоначалната парола:
{{< terminal >}}
cat data/secrets/initialAdminPassword

{{</ terminal >}}
Вижте:
{{< gallery match="images/6/*.png" >}}
Избрах "Препоръчителна инсталация".
{{< gallery match="images/7/*.png" >}}

## Стъпка 5: Първата ми работа
Влизам в системата и създавам задачата си за Docker.
{{< gallery match="images/8/*.png" >}}
Както можете да видите, всичко работи чудесно!
{{< gallery match="images/9/*.png" >}}