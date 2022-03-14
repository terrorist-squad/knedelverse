+++
date = "2021-04-16"
title = "Творческий выход из кризиса: бронирование услуг с помощью easyappointments"
difficulty = "level-3"
tags = ["buchung", "buchungstool", "click-and-meet", "corona", "Docker", "docker-compose", "easyappointments", "krise", "einzelhandel", "geschaefte"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210414-docker-easyappointments/index.ru.md"
+++
Кризис Corona сильно ударил по поставщикам услуг в Германии. Цифровые инструменты и решения могут помочь пережить пандемию "Корона" максимально безопасно. В этой серии уроков "Креатив из кризиса" я показываю технологии или инструменты, которые могут быть полезны для малого бизнеса. Сегодня я показываю "Easyappointments", инструмент для бронирования услуг, например, парикмахерских или магазинов. Easyappointments состоит из двух областей:
## Область 1: Бэкэнд
Бэкэнд" для управления услугами и назначениями.
{{< gallery match="images/1/*.png" >}}

## Область 2: Frontend
Инструмент для конечного пользователя для бронирования встреч. Все уже забронированные встречи блокируются и не могут быть забронированы дважды.
{{< gallery match="images/2/*.png" >}}

## Установка
Я уже несколько раз устанавливал Easyappointments с помощью Docker-Compose и могу настоятельно рекомендовать этот метод установки. Я создаю новый каталог под названием "easyappointments" на своем сервере:
{{< terminal >}}
mkdir easyappointments
cd easyappointments

{{</ terminal >}}
Затем я захожу в каталог easyappointments и создаю новый файл под названием "easyappointments.yml" со следующим содержимым:
```
version: '2'
services:
  db:
    image: mysql
    environment:
      - MYSQL_ROOT_PASSWORD=root
      - MYSQL_DATABASE=easyappointments
      - MYSQL_USER=easyappointments
      - MYSQL_PASSWORD=easyappointments
    command: mysqld --default-authentication-plugin=mysql_native_password
    volumes:
      - ./easy-appointments-data:/var/lib/mysql
    expose:
      - 3306
    networks:
      - easyappointments-network
    restart: always

  application:
    image: jamrizzi/easyappointments
    volumes:
      - ./easy-appointments:/app/www
    depends_on:
      - db
    ports:
      - 8089:8888
    environment:
      - DB_HOST=db
      - DB_USERNAME=easyappointments
      - DB_NAME=easyappointments
      - DB_PASSWORD=easyappointments
      - TZ=Europe/Berlin
      - BASE_URL=http://192.168.178.50:8089 
    networks:
      - easyappointments-network
    restart: always

networks:
  easyappointments-network:

```
Этот файл запускается через Docker Compose. После этого установка становится доступной под предназначенным доменом/портом.
{{< terminal >}}
docker-compose -f easyappointments.yml up

{{</ terminal >}}

## Создайте услугу
Услуги можно создать в разделе "Услуги". Затем каждая новая услуга должна быть назначена поставщику услуг/пользователю. Это означает, что я могу заказать специализированных сотрудников или поставщиков услуг.
{{< gallery match="images/3/*.png" >}}
Конечный потребитель также может выбрать услугу и предпочтительного поставщика услуг.
{{< gallery match="images/4/*.png" >}}

## Рабочее время и перерывы
Общие часы дежурства можно установить в разделе "Настройки" > "Бизнес-логика". Однако рабочее время поставщиков услуг/пользователей также может быть изменено в "Рабочем плане" пользователя.
{{< gallery match="images/5/*.png" >}}

## Обзор бронирования и ежедневник
В календаре встреч все заказы видны. Разумеется, там же можно создавать и редактировать бронирования.
{{< gallery match="images/6/*.png" >}}

## Цветовые или логические корректировки
Если вы скопируете каталог "/app/www" и включите его как "том", то вы сможете адаптировать таблицы стилей и логику по своему усмотрению.
{{< gallery match="images/7/*.png" >}}