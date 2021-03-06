+++
date = "2021-03-07"
title = "Страхотни неща с контейнери: управление и архивиране на рецепти в Synology DiskStation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "rezepte", "speisen", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-docker-mealie/index.bg.md"
+++
Съберете всичките си любими рецепти в контейнер Docker и ги организирайте, както желаете. Напишете свои собствени рецепти или импортирайте рецепти от уебсайтове, например "Chefkoch", "Essen
{{< gallery match="images/1/*.png" >}}

## Възможност за професионалисти
Като опитен потребител на Synology можете, разбира се, да влезете в системата с помощта на SSH и да инсталирате цялата инсталация чрез файла Docker Compose.
```
version: "2.0"
services:
  mealie:
    container_name: mealie
    image: hkotel/mealie:latest
    restart: always
    ports:
      - 9000:80
    environment:
      db_type: sqlite
      TZ: Europa/Berlin
    volumes:
      - ./mealie/data/:/app/data

```

## Стъпка 1: Търсене на образ на Docker
Кликвам върху раздела "Регистрация" в прозореца на Synology Docker и търся "mealie". Избирам образа на Docker "hkotel/mealie:latest" и след това щраквам върху етикета "latest".
{{< gallery match="images/2/*.png" >}}
След изтеглянето на изображението то е достъпно като изображение. Docker прави разлика между 2 състояния - контейнер "динамично състояние" и образ/имдж (фиксирано състояние). Преди да можем да създадем контейнер от изображението, трябва да се направят няколко настройки.
## Стъпка 2: Въведете изображението в действие:
Кликвам два пъти върху моето изображение "mealie".
{{< gallery match="images/3/*.png" >}}
След това щракнах върху "Разширени настройки" и активирах "Автоматично рестартиране". Избирам раздела "Том" и щраквам върху "Добавяне на папка". Там създавам нова папка с този път за монтиране "/app/data".
{{< gallery match="images/4/*.png" >}}
Присвоявам фиксирани портове за контейнера "Mealie". При липса на фиксирани портове може да се окаже, че "сървърът на Mealie" работи на друг порт след рестартиране.
{{< gallery match="images/5/*.png" >}}
Накрая въвеждам две променливи на средата. Променливата "db_type" е типът на базата данни, а "TZ" е часовата зона "Europe/Berlin".
{{< gallery match="images/6/*.png" >}}
След тези настройки сървърът Mealie може да бъде стартиран! След това можете да се обадите на Mealie чрез Ip адреса на устройството Synology и назначения порт, например http://192.168.21.23:8096 .
{{< gallery match="images/7/*.png" >}}

## Как работи Mealie?
Ако преместя мишката върху бутона "плюс" отдясно/отдолу и след това щракна върху символа "верига", мога да въведа URL адрес. След това приложението Mealie автоматично търси необходимата мета и схема информация.
{{< gallery match="images/8/*.png" >}}
Импортът работи чудесно (използвал съм тези функции с урни адреси от Chef, Food
{{< gallery match="images/9/*.png" >}}
В режим на редактиране мога също така да добавя категория. Важно е да натискам клавиша "Enter" веднъж след всяка категория. В противен случай тази настройка не се прилага.
{{< gallery match="images/10/*.png" >}}

## Специални функции
Забелязах, че категориите в менюто не се актуализират автоматично. Трябва да помогнете тук с презареждане на браузъра.
{{< gallery match="images/11/*.png" >}}

## Други функции
Разбира се, можете да търсите рецепти, както и да създавате менюта. Освен това можете да персонализирате "Mealie" в много голяма степен.
{{< gallery match="images/12/*.png" >}}
Mealie изглежда чудесно и на мобилни устройства:
{{< gallery match="images/13/*.*" >}}

## Rest-Api
Документацията на API може да бъде намерена на адрес "http://gewaehlte-ip:und-port ... /docs". Тук ще намерите много методи, които могат да се използват за автоматизация.
{{< gallery match="images/14/*.png" >}}

## Пример за Api
Представете си следната измислица: "Gruner und Jahr стартира интернет портала Essen
{{< terminal >}}
wget --spider --force-html -r -l12  "https://www.essen-und-trinken.de/rezepte/archiv/"  2>&1 | grep '/rezepte/' | grep '^--' | awk '{ print $3 }' > liste.txt

{{</ terminal >}}
След това изчистете този списък и го изпратете към интерфейса за почивка, например:
```
#!/bin/bash
sort -u liste.txt > clear.txt

while read p; do
  echo "import url: $p"
  curl -d "{\"url\":\"$p\"}" -H "Content-Type: application/json" http://synology-ip:8096/api/recipes/create-url
  sleep 1
done < clear.txt

```
Сега можете да получите достъп до рецептите и офлайн:
{{< gallery match="images/15/*.png" >}}
Заключение: Ако отделите малко време на Mealie, можете да изградите страхотна база данни с рецепти! Mealie се разработва постоянно като проект с отворен код и може да бъде намерен на следния адрес: https://github.com/hay-kot/mealie/
