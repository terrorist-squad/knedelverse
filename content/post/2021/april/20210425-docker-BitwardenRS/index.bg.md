+++
date = "2021-04-25T09:28:11+01:00"
title = "BitwardenRS в Synology DiskStation"
difficulty = "level-2"
tags = ["bitwardenrs", "Docker", "docker-compose", "password-manager", "passwort", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-BitwardenRS/index.bg.md"
+++
Bitwarden е безплатна услуга за управление на пароли с отворен код, която съхранява поверителна информация, като например идентификационни данни за уебсайтове, в криптиран трезор. Днес ще покажа как да инсталирате BitwardenRS на Synology DiskStation.
## Стъпка 1: Подгответе папката BitwardenRS
Създавам нова директория, наречена "bitwarden", в директорията на Docker.
{{< gallery match="images/1/*.png" >}}

## Стъпка 2: Инсталиране на BitwardenRS
Кликвам върху раздела "Регистрация" в прозореца на Synology Docker и търся "bitwarden". Избирам образа на Docker "bitwardenrs/server" и след това щраквам върху етикета "latest".
{{< gallery match="images/2/*.png" >}}
Кликвам два пъти върху изображението на моите bitwardenrs. След това щраквам върху "Разширени настройки" и активирам "Автоматично рестартиране" и тук.
{{< gallery match="images/3/*.png" >}}
Избирам раздела "Том" и щраквам върху "Добавяне на папка". Там създавам нова папка с този път за монтиране "/data".
{{< gallery match="images/4/*.png" >}}
Присвоявам фиксирани портове за контейнера "bitwardenrs". Без фиксирани портове може да се окаже, че "bitwardenrs server" работи на различен порт след рестартиране. Първият контейнерен порт може да бъде изтрит. Другото пристанище трябва да бъде запомнено.
{{< gallery match="images/5/*.png" >}}
Контейнерът вече може да бъде стартиран. Обаждам се на сървъра bitwardenrs с IP адреса на Synology и моя контейнер порт 8084.
{{< gallery match="images/6/*.png" >}}

## Стъпка 3: Настройка на HTTPS
Кликвам върху "Control Panel" (Контролен панел) > "Reverse Proxy" (Обратен прокси сървър) и "Create" (Създаване).
{{< gallery match="images/7/*.png" >}}
След това мога да се обадя на сървъра bitwardenrs с IP адреса на Synology и моя прокси порт 8085, криптирано.
{{< gallery match="images/8/*.png" >}}