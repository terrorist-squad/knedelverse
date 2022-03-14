+++
date = "2021-05-30"
title = "Изтегляне на Udemy в Synology DiskStation"
difficulty = "level-2"
tags = ["udemy", "download", "synology", "diskstation", "udemydl"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-udemydl/index.bg.md"
+++
В този урок ще научите как да изтегляте курсове на "udemy" за офлайн употреба.
## Стъпка 1: Подгответе папката Udemy
Създавам нова директория, наречена "udemy", в директорията на Docker.
{{< gallery match="images/1/*.png" >}}

## Стъпка 2: Инсталиране на образа на Ubuntu
Кликвам върху раздела "Регистрация" в прозореца на Synology Docker и търся "ubunutu". Избирам образа на Docker "ubunutu" и след това щраквам върху етикета "latest".
{{< gallery match="images/2/*.png" >}}
Щракнах два пъти върху моето изображение на Ubuntu. След това щраквам върху "Разширени настройки" и активирам "Автоматично рестартиране" и тук.
{{< gallery match="images/3/*.png" >}}
Избирам раздела "Обем" и щраквам върху "Добавяне на папка". Там създавам нова папка с този път за монтиране "/download".
{{< gallery match="images/4/*.png" >}}
Сега контейнерът може да бъде стартиран
{{< gallery match="images/5/*.png" >}}

## Стъпка 4: Инсталиране на Udemy Downloader
Кликвам върху "Контейнер" в прозореца Synology Docker и кликвам два пъти върху моя "Контейнер Udemy". След това щракнах върху раздела "Терминал" и въведох следните команди.
{{< gallery match="images/6/*.png" >}}

##  Команди:

{{< terminal >}}
apt-get update
apt-get install python3 python3-pip wget unzip
cd /download
wget https://github.com/r0oth3x49/udemy-dl/archive/refs/heads/master.zip
unzip master.zip
cd udemy-dl-master
pip3 pip install -r requirements.txt

{{</ terminal >}}
Снимки на екрана:
{{< gallery match="images/7/*.png" >}}

## Стъпка 4: Пускане в действие на програмата за изтегляне на Udemy
Сега се нуждая от "токен за достъп". Посещавам Udemy с браузъра си Firefox и отварям Firebug. Кликвам върху раздела "Уеб съхранение" и копирам "Токен за достъп".
{{< gallery match="images/8/*.png" >}}
Създавам нов файл в контейнера си:
{{< terminal >}}
echo "access_token=859wjuhV7PMLsZu15GOWias9A0iFnRjkL9pJXOv2" > /download/cookie.txt

{{</ terminal >}}
След това мога да изтегля курсовете, които вече съм закупил:
{{< terminal >}}
cd /download
python3 udemy-dl-master/udemy-dl.py -k /download/cookie.txt https://www.udemy.com/course/ansible-grundlagen/learn/

{{</ terminal >}}
Вижте:
{{< gallery match="images/9/*.png" >}}
