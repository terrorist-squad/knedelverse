+++
date = "2021-03-07"
title = "Великие дела с контейнерами: управление и архивирование рецептов на Synology DiskStation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "rezepte", "speisen", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-docker-mealie/index.ru.md"
+++
Соберите все свои любимые рецепты в Docker-контейнер и организуйте их по своему усмотрению. Пишите собственные рецепты или импортируйте рецепты с веб-сайтов, например, "Шефкоч", "Эссен
{{< gallery match="images/1/*.png" >}}

## Вариант для профессионалов
Как опытный пользователь Synology, вы, конечно, можете войти в систему с помощью SSH и установить всю установку через файл Docker Compose.
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

## Шаг 1: Поиск образа Docker
Я перехожу на вкладку "Регистрация" в окне Synology Docker и ищу "mealie". Я выбираю образ Docker "hkotel/mealie:latest", а затем нажимаю на тег "latest".
{{< gallery match="images/2/*.png" >}}
После загрузки изображения оно доступно в виде рисунка. Docker различает 2 состояния, контейнер "динамическое состояние" и образ/изображение (фиксированное состояние). Прежде чем мы сможем создать контейнер из образа, необходимо выполнить несколько настроек.
## Шаг 2: Введите изображение в работу:
Я дважды щелкаю по своему изображению "mealie".
{{< gallery match="images/3/*.png" >}}
Затем я нажимаю на "Дополнительные настройки" и активирую "Автоматический перезапуск". Я выбираю вкладку "Том" и нажимаю "Добавить папку". Там я создаю новую папку с таким путем монтирования "/app/data".
{{< gallery match="images/4/*.png" >}}
Я назначаю фиксированные порты для контейнера "Mealie". При отсутствии фиксированных портов может оказаться, что после перезапуска "сервер Mealie" работает на другом порту.
{{< gallery match="images/5/*.png" >}}
Наконец, я ввожу две переменные окружения. Переменная "db_type" - это тип базы данных, а "TZ" - часовой пояс "Европа/Берлин".
{{< gallery match="images/6/*.png" >}}
После этих настроек Mealie Server можно запускать! После этого вы можете позвонить Mealie через Ip-адрес устройства Synology и назначенный порт, например, http://192.168.21.23:8096 .
{{< gallery match="images/7/*.png" >}}

## Как работает Мили?
Если я наведу курсор на кнопку "плюс" справа/снизу, а затем нажму на символ "цепочка", я смогу ввести url. Затем приложение Mealie автоматически выполняет поиск необходимой мета- и схемной информации.
{{< gallery match="images/8/*.png" >}}
Импорт работает отлично (я использовал эти функции с ссылками из Chef, Food
{{< gallery match="images/9/*.png" >}}
В режиме редактирования я также могу добавить категорию. Важно, чтобы я нажимал клавишу "Enter" один раз после каждой категории. В противном случае эта настройка не применяется.
{{< gallery match="images/10/*.png" >}}

## Специальные возможности
Я заметил, что категории меню не обновляются автоматически. Здесь вам поможет перезагрузка браузера.
{{< gallery match="images/11/*.png" >}}

## Другие особенности
Конечно, вы можете искать рецепты, а также составлять меню. Кроме того, вы можете настроить "Mealie" очень широко.
{{< gallery match="images/12/*.png" >}}
Mealie также отлично смотрится на мобильных устройствах:
{{< gallery match="images/13/*.*" >}}

## Rest-Api
Документацию по API можно найти по адресу "http://gewaehlte-ip:und-port ... /docs". Здесь вы найдете множество методов, которые можно использовать для автоматизации.
{{< gallery match="images/14/*.png" >}}

## Пример Api
Представьте себе следующий вымысел: "Gruner und Jahr запускает интернет-портал Essen
{{< terminal >}}
wget --spider --force-html -r -l12  "https://www.essen-und-trinken.de/rezepte/archiv/"  2>&1 | grep '/rezepte/' | grep '^--' | awk '{ print $3 }' > liste.txt

{{</ terminal >}}
Затем очистите этот список и запустите его против rest api, например:
```
#!/bin/bash
sort -u liste.txt > clear.txt

while read p; do
  echo "import url: $p"
  curl -d "{\"url\":\"$p\"}" -H "Content-Type: application/json" http://synology-ip:8096/api/recipes/create-url
  sleep 1
done < clear.txt

```
Теперь вы можете получать доступ к рецептам и в автономном режиме:
{{< gallery match="images/15/*.png" >}}
Вывод: Если вы потратите немного времени на Mealie, вы сможете создать отличную базу данных рецептов! Mealie постоянно развивается как проект с открытым исходным кодом и может быть найден по следующему адресу: https://github.com/hay-kot/mealie/.
