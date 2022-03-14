+++
date = "2021-04-16"
title = "Творческо излизане от кризата: резервиране на услуга с лесни срещи"
difficulty = "level-3"
tags = ["buchung", "buchungstool", "click-and-meet", "corona", "Docker", "docker-compose", "easyappointments", "krise", "einzelhandel", "geschaefte"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210414-docker-easyappointments/index.bg.md"
+++
Кризата с короната се отразява тежко на доставчиците на услуги в Германия. Цифровите инструменти и решения могат да ви помогнат да преминете през пандемията Корона възможно най-безопасно. В тази поредица от уроци "Творчески изход от кризата" показвам технологии или инструменти, които могат да бъдат полезни за малкия бизнес.Днес показвам "Easyappointments", инструмент за резервации на услуги, например фризьорски салони или магазини, който се използва за "кликване и среща". Easyappointments се състои от две области:
## Област 1: Backend
"Бекенд" за управление на услуги и срещи.
{{< gallery match="images/1/*.png" >}}

## Област 2: Frontend
Инструмент за крайния потребител за резервиране на срещи. Всички вече резервирани срещи се блокират и не могат да бъдат резервирани два пъти.
{{< gallery match="images/2/*.png" >}}

## Инсталация
Вече съм инсталирал Easyappointments няколко пъти с Docker-Compose и мога горещо да препоръчам този метод на инсталиране. Създавам нова директория, наречена "easyappointments", на моя сървър:
{{< terminal >}}
mkdir easyappointments
cd easyappointments

{{</ terminal >}}
След това влизам в директорията easyappointments и създавам нов файл, наречен "easyappointments.yml", със следното съдържание:
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
Този файл се стартира чрез Docker Compose. След това инсталацията е достъпна в предвидения домейн/порт.
{{< terminal >}}
docker-compose -f easyappointments.yml up

{{</ terminal >}}

## Създаване на услуга
Услугите могат да се създават в раздел "Услуги". След това всяка нова услуга трябва да бъде присвоена на доставчик на услуги/потребител. Това означава, че мога да резервирам специализирани служители или доставчици на услуги.
{{< gallery match="images/3/*.png" >}}
Крайният потребител също може да избере услугата и предпочитания доставчик на услуги.
{{< gallery match="images/4/*.png" >}}

## Работно време и почивки
Общите часове на дежурство могат да бъдат зададени в "Настройки" > "Бизнес логика". Работното време на доставчиците на услуги/потребителите обаче може да бъде променено и в "Работен план" на потребителя.
{{< gallery match="images/5/*.png" >}}

## Преглед на резервациите и дневник
Календарът на срещите прави всички резервации видими. Разбира се, там могат да се създават и редактират резервации.
{{< gallery match="images/6/*.png" >}}

## Цветни или логически корекции
Ако копирате директорията "/app/www" и я включите като "том", можете да адаптирате таблиците със стилове и логиката, както желаете.
{{< gallery match="images/7/*.png" >}}