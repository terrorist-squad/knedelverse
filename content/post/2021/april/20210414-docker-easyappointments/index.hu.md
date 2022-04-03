+++
date = "2021-04-16"
title = "Kreatív ki a válságból: szolgáltatásfoglalás easyappointments szolgáltatással"
difficulty = "level-3"
tags = ["buchung", "buchungstool", "click-and-meet", "corona", "Docker", "docker-compose", "easyappointments", "krise", "einzelhandel", "geschaefte"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210414-docker-easyappointments/index.hu.md"
+++
A Corona-válság keményen sújtja a németországi szolgáltatókat. A digitális eszközök és megoldások segíthetnek abban, hogy a lehető legbiztonságosabban vészeljük át a Corona-járványt. Ebben a "Kreatívan a válságból" című sorozatban olyan technológiákat vagy eszközöket mutatok be, amelyek hasznosak lehetnek a kisvállalkozások számára.Ma az "Easyappointments", egy "kattints és találkozz" foglalási eszközt mutatok be szolgáltatások, például fodrászok vagy üzletek számára. Az Easyappointments két területből áll:
## 1. terület: Backend
A szolgáltatások és találkozók kezelésére szolgáló "backend".
{{< gallery match="images/1/*.png" >}}

## 2. terület: Frontend
Végfelhasználói eszköz időpontfoglaláshoz. A már lefoglalt időpontok blokkolva vannak, és nem foglalhatók le kétszer.
{{< gallery match="images/2/*.png" >}}

## Telepítés
Már többször telepítettem az Easyappointments-et a Docker-Compose segítségével, és nagyon ajánlom ezt a telepítési módszert. Létrehozok egy új könyvtárat "easyappointments" néven a szerveremen:
{{< terminal >}}
mkdir easyappointments
cd easyappointments

{{</ terminal >}}
Ezután bemegyek az easyappointments könyvtárba, és létrehozok egy új fájlt "easyappointments.yml" néven a következő tartalommal:
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
Ez a fájl a Docker Compose segítségével indul. Ezt követően a telepítés a kívánt tartomány/port alatt elérhetővé válik.
{{< terminal >}}
docker-compose -f easyappointments.yml up

{{</ terminal >}}

## Szolgáltatás létrehozása
A szolgáltatásokat a "Szolgáltatások" menüpont alatt lehet létrehozni. Ezután minden új szolgáltatást egy szolgáltatóhoz/felhasználóhoz kell rendelni. Ez azt jelenti, hogy speciális alkalmazottakat vagy szolgáltatókat foglalhatok.
{{< gallery match="images/3/*.png" >}}
A végfelhasználó is kiválaszthatja a szolgáltatást és az általa preferált szolgáltatót.
{{< gallery match="images/4/*.png" >}}

## Munkaidő és szünetek
Az általános szolgálati idő a "Beállítások" > "Üzleti logika" menüpont alatt állítható be. A szolgáltatók/felhasználók munkaideje azonban a felhasználó "Munkatervében" is módosítható.
{{< gallery match="images/5/*.png" >}}

## Foglalási áttekintés és naptár
A határidőnaptár minden foglalást láthatóvá tesz. Természetesen a foglalások ott is létrehozhatók vagy szerkeszthetők.
{{< gallery match="images/6/*.png" >}}

## Szín vagy logikai beállítások
Ha kimásolod a "/app/www" könyvtárat, és "kötetként" csatolod, akkor a stíluslapokat és a logikát tetszés szerint módosíthatod.
{{< gallery match="images/7/*.png" >}}
