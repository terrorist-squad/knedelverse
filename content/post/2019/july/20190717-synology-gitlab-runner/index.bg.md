+++
date = "2019-07-17"
title = "Synology-Nas: Gitlab - Runner в контейнер Docker"
difficulty = "level-4"
tags = ["Docker", "git", "gitlab", "gitlab-runner", "raspberry-pi"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-synology-gitlab-runner/index.bg.md"
+++
Как да инсталирам Gitlab runner като контейнер Docker на моя Synology NAS?
## Стъпка 1: Търсене на образ на Docker
Кликвам върху раздела "Регистрация" в прозореца на Synology Docker и търся Gitlab. Избирам образа на Docker "gitlab/gitlab-runner" и след това избирам маркера "bleeding".
{{< gallery match="images/1/*.png" >}}

## Стъпка 2: Въведете изображението в действие:

##  Проблем с хостовете
Моята synology-gitlab-insterlation винаги се идентифицира само с име на хост. Тъй като взех оригиналния пакет Synology Gitlab от центъра за пакети, това поведение не може да бъде променено впоследствие.  Като заобиколен вариант мога да включа свой собствен файл hosts. Тук можете да видите, че името на хоста "peter" принадлежи на IP адреса на Nas 192.168.12.42.
```
127.0.0.1       localhost                                                       
::1     localhost ip6-localhost ip6-loopback                                    
fe00::0 ip6-localnet                                                            
ff00::0 ip6-mcastprefix                                                         
ff02::1 ip6-allnodes                                                            
ff02::2 ip6-allrouters               
192.168.12.42 peter

```
Този файл просто се съхранява в устройството Synology NAS.
{{< gallery match="images/2/*.png" >}}

## Стъпка 3: Настройка на GitLab Runner
Кликвам върху изображението на моя Runner:
{{< gallery match="images/3/*.png" >}}
Активирам настройката "Активиране на автоматичното рестартиране":
{{< gallery match="images/4/*.png" >}}
След това щраквам върху "Разширени настройки" и избирам раздела "Обем":
{{< gallery match="images/5/*.png" >}}
Щраквам върху Add File (Добавяне на файл) и включвам моя хостс файл по пътя "/etc/hosts". Тази стъпка е необходима само ако имената на хостовете не могат да бъдат разрешени.
{{< gallery match="images/6/*.png" >}}
Приемам настройките и щраквам върху "Напред".
{{< gallery match="images/7/*.png" >}}
Сега намирам инициализираното изображение в раздел Контейнер:
{{< gallery match="images/8/*.png" >}}
Избирам контейнера (за мен gitlab-gitlab-runner2) и щраквам върху "Подробности". След това щраквам върху раздела "Терминал" и създавам нова сесия на bash. Тук въвеждам командата "gitlab-runner register". За регистрацията ми е необходима информация, която мога да намеря в инсталацията на GitLab под http://gitlab-adresse:port/admin/runners.   
{{< gallery match="images/9/*.png" >}}
Ако имате нужда от повече пакети, можете да ги инсталирате чрез "apt-get update" и след това "apt-get install python ...".
{{< gallery match="images/10/*.png" >}}
След това мога да включа бегача в проектите си и да го използвам:
{{< gallery match="images/11/*.png" >}}
