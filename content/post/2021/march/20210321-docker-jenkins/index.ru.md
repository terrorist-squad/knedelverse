+++
date = "2021-03-21"
title = "Большие вещи с контейнерами: Запуск Jenkins на Synology DS"
difficulty = "level-3"
tags = ["build", "devops", "diskstation", "java", "javascript", "Jenkins", "nas", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210321-docker-jenkins/index.ru.md"
+++

## Шаг 1: Подготовьте Synology
Во-первых, на DiskStation должен быть активирован вход SSH. Для этого перейдите в "Панель управления" > "Терминал
{{< gallery match="images/1/*.png" >}}
Затем вы можете войти в систему через "SSH", указанный порт и пароль администратора (пользователи Windows используют Putty или WinSCP).
{{< gallery match="images/2/*.png" >}}
Я вхожу в систему через Terminal, winSCP или Putty и оставляю эту консоль открытой на потом.
## Шаг 2: Подготовьте папку Docker
Я создаю новый каталог под названием "jenkins" в каталоге Docker.
{{< gallery match="images/3/*.png" >}}
Затем я перехожу в новый каталог и создаю новую папку "data":
{{< terminal >}}
sudo mkdir data

{{</ terminal >}}
Я также создаю файл под названием "jenkins.yml" со следующим содержимым. Передняя часть порта "8081:" может быть отрегулирована.
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

## Шаг 3: Начать
На этом этапе я также могу использовать консоль. Я запускаю сервер Jenkins через Docker Compose.
{{< terminal >}}
sudo docker-compose -f jenkins.yml up -d

{{</ terminal >}}
После этого я могу позвонить на свой сервер Jenkins, используя IP-адрес дисковой станции и назначенный порт из "Шага 2".
{{< gallery match="images/4/*.png" >}}

## Шаг 4: Настройка

{{< gallery match="images/5/*.png" >}}
Опять же, я использую консоль для считывания начального пароля:
{{< terminal >}}
cat data/secrets/initialAdminPassword

{{</ terminal >}}
См:
{{< gallery match="images/6/*.png" >}}
Я выбрал "Рекомендуемая установка".
{{< gallery match="images/7/*.png" >}}

## Шаг 5: Моя первая работа
Я вхожу в систему и создаю задание Docker.
{{< gallery match="images/8/*.png" >}}
Как видите, все работает отлично!
{{< gallery match="images/9/*.png" >}}