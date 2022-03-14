+++
date = "2020-02-28"
title = "Страхотни неща с контейнери: стартиране на Papermerge DMS на Synology NAS"
difficulty = "level-3"
tags = ["archiv", "automatisch", "dms", "Docker", "Document-Managment-System", "google", "ocr", "papermerge", "Synology", "tesseract", "texterkennung"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200228-docker-papermerge/index.bg.md"
+++
Papermerge е млада система за управление на документи (DMS), която може автоматично да разпределя и обработва документи. В този урок показвам как инсталирах Papermerge на моята дискова станция Synology и как работи DMS.
## Възможност за професионалисти
Като опитен потребител на Synology можете, разбира се, да влезете в системата с помощта на SSH и да инсталирате цялата инсталация чрез файла Docker Compose.
```
version: "2.1"
services:
  papermerge:
    image: ghcr.io/linuxserver/papermerge
    container_name: papermerge
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./config>:/config
      - ./appdata/data>:/data
    ports:
      - 8090:8000
    restart: unless-stopped

```

## Стъпка 1: Създаване на папка
Първо създавам папка за сливането на документи. Отивам в "Управление на системата" -> "Споделена папка" и създавам нова папка, наречена "Архив на документи".
{{< gallery match="images/1/*.png" >}}
Стъпка 2: Търсене на образ на DockerЩракнете върху раздела "Регистрация" в прозореца на Synology Docker и потърсете "Papermerge". Избирам образа на Docker "linuxserver/papermerge" и след това щраквам върху етикета "latest".
{{< gallery match="images/2/*.png" >}}
След изтеглянето на изображението то е достъпно като изображение. Docker прави разлика между 2 състояния - контейнер "динамично състояние" и образ/имдж (фиксирано състояние). Преди да можем да създадем контейнер от изображението, трябва да се направят няколко настройки.
## Стъпка 3: Въведете изображението в експлоатация:
Кликвам два пъти върху изображението за сливане на хартия.
{{< gallery match="images/3/*.png" >}}
След това щракнах върху "Разширени настройки" и активирах "Автоматично рестартиране". Избирам раздела "Обем" и щраквам върху "Добавяне на папка". Там създавам нова папка с база данни с този път за монтиране "/data".
{{< gallery match="images/4/*.png" >}}
Тук съхранявам и втора папка, която включвам в пътя за монтиране "/config". Няма значение къде се намира тази папка. Важно е обаче той да принадлежи на потребителя администратор на Synology.
{{< gallery match="images/5/*.png" >}}
Присвоявам фиксирани портове за контейнера "Papermerge". Без фиксирани портове може да се окаже, че "сървърът на Papermerge" работи на друг порт след рестартиране.
{{< gallery match="images/6/*.png" >}}
Накрая въвеждам три променливи на средата. Променливата "PUID" е идентификаторът на потребителя, а "PGID" е идентификаторът на групата на моя потребител администратор. Можете да откриете PGID/PUID чрез SSH с командата "cat /etc/passwd | grep admin".
{{< gallery match="images/7/*.png" >}}
След тези настройки сървърът Papermerge може да бъде стартиран! След това Papermerge може да бъде извикан чрез Ip адреса на устройството Synology и назначения порт, например http://192.168.21.23:8095.
{{< gallery match="images/8/*.png" >}}
Входът по подразбиране е admin с парола admin.
## Как работи Papermerge?
Papermerge анализира текста на документи и изображения. Papermerge използва библиотека за OCR/"оптично разпознаване на символи", наречена tesseract, публикувана от Goolge.
{{< gallery match="images/9/*.png" >}}
Създадох папка, наречена "Всичко с Lorem", за да тествам автоматичното задаване на документи. След това щракнах върху нов модел за разпознаване в менюто "Автомати".
{{< gallery match="images/10/*.png" >}}
Всички нови документи, съдържащи думата "Lorem", се поставят в папката "Всичко с Lorem" и се маркират с "has-lorem". Важно е да използвате запетая в таговете, в противен случай тагът няма да бъде зададен. Ако качите съответния документ, той ще бъде маркиран и сортиран.
{{< gallery match="images/11/*.png" >}}