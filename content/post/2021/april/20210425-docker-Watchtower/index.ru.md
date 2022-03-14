+++
date = "2021-04-25T09:28:11+01:00"
title = "Краткая история: Автоматическое обновление контейнеров с помощью Watchtower"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "watchtower"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-Watchtower/index.ru.md"
+++
Если вы запускаете контейнеры Docker на своей дисковой станции, вы, естественно, хотите, чтобы они всегда были в актуальном состоянии. Watchtower обновляет образы и контейнеры автоматически. Таким образом, вы сможете пользоваться новейшими функциями и обеспечивать самую современную защиту данных. Сегодня я покажу вам, как установить Watchtower на дисковую станцию Synology.
## Шаг 1: Подготовьте Synology
Во-первых, на DiskStation должен быть активирован вход SSH. Для этого перейдите в "Панель управления" > "Терминал
{{< gallery match="images/1/*.png" >}}
Затем вы можете войти в систему через "SSH", указанный порт и пароль администратора (пользователи Windows используют Putty или WinSCP).
{{< gallery match="images/2/*.png" >}}
Я вхожу в систему через Terminal, winSCP или Putty и оставляю эту консоль открытой на потом.
## Шаг 2: Установите сторожевую башню
Для этого я использую консоль:
{{< terminal >}}
docker run --name watchtower --restart always -v /var/run/docker.sock:/var/run/docker.sock containrrr/watchtower

{{</ terminal >}}
После этого Watchtower всегда работает в фоновом режиме.
{{< gallery match="images/3/*.png" >}}
