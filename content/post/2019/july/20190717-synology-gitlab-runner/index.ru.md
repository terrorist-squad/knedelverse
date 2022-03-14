+++
date = "2019-07-17"
title = "Synology-Nas: Gitlab - Runner в контейнере Docker"
difficulty = "level-4"
tags = ["Docker", "git", "gitlab", "gitlab-runner", "raspberry-pi"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-synology-gitlab-runner/index.ru.md"
+++
Как установить Gitlab runner в качестве контейнера Docker на NAS Synology?
## Шаг 1: Поиск образа Docker
Я перехожу на вкладку "Регистрация" в окне Synology Docker и ищу Gitlab. Я выбираю образ Docker "gitlab/gitlab-runner", а затем выбираю тег "bleeding".
{{< gallery match="images/1/*.png" >}}

## Шаг 2: Введите изображение в работу:

##  Проблема с хостами
Моя синология-gitlab-insterlation всегда идентифицирует себя только по имени хоста. Поскольку я взял оригинальный пакет Synology Gitlab из центра пакетов, это поведение не может быть изменено впоследствии.  В качестве обходного пути я могу включить свой собственный файл hosts. Здесь видно, что имя хоста "peter" принадлежит IP-адресу Nas 192.168.12.42.
```
127.0.0.1       localhost                                                       
::1     localhost ip6-localhost ip6-loopback                                    
fe00::0 ip6-localnet                                                            
ff00::0 ip6-mcastprefix                                                         
ff02::1 ip6-allnodes                                                            
ff02::2 ip6-allrouters               
192.168.12.42 peter

```
Этот файл просто хранится на сетевом хранилище Synology NAS.
{{< gallery match="images/2/*.png" >}}

## Шаг 3: Настройка GitLab Runner
Я нажимаю на изображение своего бегуна:
{{< gallery match="images/3/*.png" >}}
Я активирую настройку "Включить автоматический перезапуск":
{{< gallery match="images/4/*.png" >}}
Затем я нажимаю "Дополнительные параметры" и выбираю вкладку "Объем":
{{< gallery match="images/5/*.png" >}}
Я нажимаю Добавить файл и включаю свой файл hosts по пути "/etc/hosts". Этот шаг необходим только в том случае, если имена хостов не могут быть разрешены.
{{< gallery match="images/6/*.png" >}}
Я принимаю настройки и нажимаю далее.
{{< gallery match="images/7/*.png" >}}
Теперь я нахожу инициализированный образ в разделе Container:
{{< gallery match="images/8/*.png" >}}
Я выбираю контейнер (для меня это gitlab-gitlab-runner2) и нажимаю "Details". Затем я перехожу на вкладку "Терминал" и создаю новый сеанс bash. Здесь я ввожу команду "gitlab-runner register". Для регистрации мне нужна информация, которую я могу найти в моей установке GitLab по адресу http://gitlab-adresse:port/admin/runners.   
{{< gallery match="images/9/*.png" >}}
Если вам нужны дополнительные пакеты, вы можете установить их через "apt-get update", а затем "apt-get install python ...".
{{< gallery match="images/10/*.png" >}}
После этого я могу включить бегунок в свои проекты и использовать его:
{{< gallery match="images/11/*.png" >}}