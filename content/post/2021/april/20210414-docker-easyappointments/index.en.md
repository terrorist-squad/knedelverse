+++
date = "2021-04-16"
title = "Creative out of the crisis: booking a service with easyappointments"
difficulty = "level-3"
tags = ["buchung", "buchungstool", "click-and-meet", "corona", "Docker", "docker-compose", "easyappointments", "krise", "einzelhandel", "geschaefte"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210414-docker-easyappointments/index.en.md"
+++
The Corona crisis is hitting service providers in Germany hard. Digital tools and solutions can help to get through the Corona pandemic as safely as possible. In this tutorial series "Creative out of the crisis" I show technologies or tools that can be useful for small businesses.Today I show "Easyappointments", a "click and meet" booking tool for services, for example hairdressers or shops. Easyappointments consists of two areas:
## Area 1: Backend
A "backend" for managing service and appointments.
{{< gallery match="images/1/*.png" >}}

## Area 2: Frontend
An end user tool for booking appointments. All already booked appointments are locked afterwards and cannot be booked twice.
{{< gallery match="images/2/*.png" >}}

## Installation
I have installed easyappointments several times using docker-compose and highly recommend this installation method. I create a new directory named "easyappointments" on my server:
{{< terminal >}}
mkdir easyappointments
cd easyappointments

{{</ terminal >}}
After that I go to the easyappointments directory and create a new file called "easyappointments.yml" with the following content:
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
This file is started via Docker Compose. After that, the installation is accessible under the intended domain/port.
{{< terminal >}}
docker-compose -f easyappointments.yml up

{{</ terminal >}}

## Create a service
Services can be created under "Services". Each new service must then be assigned to a service provider/user. This means that I can book specialized employees or service providers.
{{< gallery match="images/3/*.png" >}}
The end consumer can also choose the service and the preferred service provider.
{{< gallery match="images/4/*.png" >}}

## Working hours and breaks
General working hours can be set under "Settings" > "Business Logic". But also the working hours of service providers/users can be changed in the "Working plan" of the user.
{{< gallery match="images/5/*.png" >}}

## Booking overview and diary
The appointment calendar makes all bookings visible. Of course, bookings can also be created or edited there.
{{< gallery match="images/6/*.png" >}}

## Colour or logical adjustments
If you copy out the "/app/www" directory and mount it as a "volume", then you can customize the stylesheets and logic as you like.
{{< gallery match="images/7/*.png" >}}