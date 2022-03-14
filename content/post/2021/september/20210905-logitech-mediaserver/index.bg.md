+++
date = "2021-09-05"
title = "Страхотни неща с контейнери: медийни сървъри Logitech на дисковата станция Synology"
difficulty = "level-1"
tags = ["logitech", "synology", "diskstation", "nas", "sound-system", "multiroom"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/september/20210905-logitech-mediaserver/index.bg.md"
+++
В този урок ще научите как да инсталирате медиен сървър Logitech на Synology DiskStation.
{{< gallery match="images/1/*.jpg" >}}

## Стъпка 1: Подготовка на папката на Logitech Media Server
Създавам нова директория, наречена "logitechmediaserver", в директорията на Docker.
{{< gallery match="images/2/*.png" >}}

## Стъпка 2: Инсталиране на изображението Logitech Mediaserver
Щраквам върху раздела "Регистрация" в прозореца Synology Docker и търся "logitechmediaserver". Избирам образа на Docker "lmscommunity/logitechmediaserver" и след това щраквам върху етикета "latest".
{{< gallery match="images/3/*.png" >}}
Кликвам два пъти върху изображението на Logitech Media Server. След това щраквам върху "Разширени настройки" и активирам "Автоматично рестартиране" и тук.
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Ordner |Mountpath|
|--- |---|
|/volume1/docker/logitechmediaserver/config |/config|
|/volume1/docker/logitechmediaserver/music |/музика|
|/volume1/docker/logitechmediaserver/playlist |/playlist|
{{</table>}}
Избирам раздела "Обем" и щраквам върху "Добавяне на папка". Там създавам три папки:Вижте:
{{< gallery match="images/5/*.png" >}}
Присвоявам фиксирани портове за контейнера "Logitechmediaserver". Без фиксирани портове може да се окаже, че "Logitechmediaserver server" работи на различен порт след рестартиране.
{{< gallery match="images/6/*.png" >}}
Накрая въвеждам променлива на средата. Променливата "TZ" е часовата зона "Европа/Берлин".
{{< gallery match="images/7/*.png" >}}
След тези настройки Logitechmediaserver-Server може да бъде стартиран! След това можете да се обадите на Logitechmediaserver чрез Ip адреса на Synology устройството и назначения порт, например http://192.168.21.23:9000 .
{{< gallery match="images/8/*.png" >}}
