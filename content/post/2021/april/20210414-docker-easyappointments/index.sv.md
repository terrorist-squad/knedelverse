+++
date = "2021-04-16"
title = "Kreativt ur krisen: boka en tjänst med easyappointments"
difficulty = "level-3"
tags = ["buchung", "buchungstool", "click-and-meet", "corona", "Docker", "docker-compose", "easyappointments", "krise", "einzelhandel", "geschaefte"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210414-docker-easyappointments/index.sv.md"
+++
Corona-krisen drabbar tjänsteleverantörerna i Tyskland hårt. Digitala verktyg och lösningar kan hjälpa dig att ta dig igenom Corona-pandemin på ett så säkert sätt som möjligt. I den här handledningsserien "Kreativt ur krisen" visar jag teknik eller verktyg som kan vara användbara för småföretag.I dag visar jag "Easyappointments", ett bokningsverktyg för att boka tjänster, till exempel frisörer eller butiker, genom att klicka och mötas. Easy Appointments består av två områden:
## Område 1: Baksidan
En "backend" för hantering av tjänster och möten.
{{< gallery match="images/1/*.png" >}}

## Område 2: Frontend
Ett slutanvändarverktyg för att boka möten. Alla redan bokade möten blockeras då och kan inte bokas två gånger.
{{< gallery match="images/2/*.png" >}}

## Installation
Jag har redan installerat Easyappointments flera gånger med Docker-Compose och kan varmt rekommendera denna installationsmetod. Jag skapar en ny katalog som heter "easyappointments" på min server:
{{< terminal >}}
mkdir easyappointments
cd easyappointments

{{</ terminal >}}
Sedan går jag in i katalogen easyappointments och skapar en ny fil som heter "easyappointments.yml" med följande innehåll:
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
Den här filen startas via Docker Compose. Därefter är installationen tillgänglig under den avsedda domänen/porten.
{{< terminal >}}
docker-compose -f easyappointments.yml up

{{</ terminal >}}

## Skapa en tjänst
Tjänster kan skapas under "Tjänster". Varje ny tjänst måste sedan tilldelas en tjänsteleverantör/användare. Det innebär att jag kan boka specialiserade medarbetare eller tjänsteleverantörer.
{{< gallery match="images/3/*.png" >}}
Slutkonsumenten kan också välja tjänst och önskad tjänsteleverantör.
{{< gallery match="images/4/*.png" >}}

## Arbetstid och raster
Allmänna jourtider kan ställas in under "Inställningar" > "Affärslogik". Arbetstiderna för tjänsteleverantörer/användare kan dock också ändras i användarens "Arbetsplan".
{{< gallery match="images/5/*.png" >}}

## Bokningsöversikt och dagbok
I kalenderlistan är alla bokningar synliga. Naturligtvis kan bokningar också skapas eller redigeras där.
{{< gallery match="images/6/*.png" >}}

## Färg eller logiska justeringar
Om du kopierar ut katalogen "/app/www" och inkluderar den som en "volym" kan du anpassa formatmallarna och logiken som du vill.
{{< gallery match="images/7/*.png" >}}
