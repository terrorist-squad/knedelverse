+++
date = "2021-04-16"
title = "Kreativ ud af krisen: booking af en tjeneste med easyappointments"
difficulty = "level-3"
tags = ["buchung", "buchungstool", "click-and-meet", "corona", "Docker", "docker-compose", "easyappointments", "krise", "einzelhandel", "geschaefte"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210414-docker-easyappointments/index.da.md"
+++
Corona-krisen rammer tjenesteudbyderne i Tyskland hårdt. Digitale værktøjer og løsninger kan hjælpe dig med at komme så sikkert igennem Corona-pandemien som muligt. I denne tutorial-serie "Kreativ ud af krisen" viser jeg teknologier eller værktøjer, der kan være nyttige for små virksomheder.I dag viser jeg "Easyappointments", et "klik og mødes"-bookingværktøj til tjenester, f.eks. frisører eller butikker. Easyappointments består af to områder:
## Område 1: Backend
En "backend" til administration af tjenester og aftaler.
{{< gallery match="images/1/*.png" >}}

## Område 2: Frontend
Et slutbrugerværktøj til booking af aftaler. Alle aftaler, der allerede er booket, er derefter blokeret og kan ikke bookes to gange.
{{< gallery match="images/2/*.png" >}}

## Installation
Jeg har allerede installeret Easyappointments flere gange med Docker-Compose og kan varmt anbefale denne installationsmetode. Jeg opretter en ny mappe med navnet "easyappointments" på min server:
{{< terminal >}}
mkdir easyappointments
cd easyappointments

{{</ terminal >}}
Derefter går jeg ind i mappen easyappointments og opretter en ny fil med navnet "easyappointments.yml" med følgende indhold:
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
Denne fil startes via Docker Compose. Herefter er installationen tilgængelig under det ønskede domæne/port.
{{< terminal >}}
docker-compose -f easyappointments.yml up

{{</ terminal >}}

## Opret en tjeneste
Tjenester kan oprettes under "Tjenester". Hver ny tjeneste skal derefter tilknyttes en tjenesteudbyder/bruger. Det betyder, at jeg kan bestille specialiserede medarbejdere eller tjenesteydere.
{{< gallery match="images/3/*.png" >}}
Slutbrugeren kan også vælge tjeneste og den foretrukne tjenesteudbyder.
{{< gallery match="images/4/*.png" >}}

## Arbejdstid og pauser
Generelle vagttider kan indstilles under "Indstillinger" > "Forretningslogik". Tjenesteudbydernes/brugernes arbejdstider kan dog også ændres i brugerens "Arbejdsplan".
{{< gallery match="images/5/*.png" >}}

## Bookingoversigt og dagbog
Aftalekalenderen gør alle bookinger synlige. Selvfølgelig kan bookinger også oprettes eller redigeres der.
{{< gallery match="images/6/*.png" >}}

## Farve eller logiske justeringer
Hvis du kopierer mappen "/app/www" ud og inkluderer den som et "volumen", kan du tilpasse stylesheets og logikken som du ønsker.
{{< gallery match="images/7/*.png" >}}
