+++
date = "2021-04-16"
title = "Kreatívne z krízy: rezervácia služby s jednoduchými termínmi"
difficulty = "level-3"
tags = ["buchung", "buchungstool", "click-and-meet", "corona", "Docker", "docker-compose", "easyappointments", "krise", "einzelhandel", "geschaefte"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210414-docker-easyappointments/index.sk.md"
+++
Kríza spoločnosti Corona tvrdo zasiahla poskytovateľov služieb v Nemecku. Digitálne nástroje a riešenia môžu pomôcť prekonať pandémiu Corona čo najbezpečnejšie. V tejto sérii návodov "Kreatívne z krízy" ukazujem technológie alebo nástroje, ktoré môžu byť užitočné pre malé podniky.Dnes ukazujem "Easyappointments", nástroj na rezerváciu služieb, napríklad kaderníctva alebo obchodov. Easyappointments pozostáva z dvoch oblastí:
## Oblasť 1: Backend
"Backend" na správu služieb a schôdzok.
{{< gallery match="images/1/*.png" >}}

## Oblasť 2: Frontend
Nástroj pre koncového používateľa na rezerváciu schôdzok. Všetky už rezervované termíny sú potom zablokované a nie je možné ich rezervovať dvakrát.
{{< gallery match="images/2/*.png" >}}

## Inštalácia
Aplikáciu Easyappointments som už niekoľkokrát nainštaloval pomocou nástroja Docker-Compose a tento spôsob inštalácie môžem vrelo odporučiť. Na svojom serveri vytvorím nový adresár s názvom "easyappointments":
{{< terminal >}}
mkdir easyappointments
cd easyappointments

{{</ terminal >}}
Potom prejdem do adresára easyappointments a vytvorím nový súbor s názvom "easyappointments.yml" s nasledujúcim obsahom:
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
Tento súbor sa spúšťa prostredníctvom nástroja Docker Compose. Potom je inštalácia prístupná pod určenou doménou/portom.
{{< terminal >}}
docker-compose -f easyappointments.yml up

{{</ terminal >}}

## Vytvorenie služby
Služby môžete vytvoriť v časti "Služby". Každú novú službu je potom potrebné priradiť poskytovateľovi služieb/užívateľovi. To znamená, že si môžem objednať špecializovaných zamestnancov alebo poskytovateľov služieb.
{{< gallery match="images/3/*.png" >}}
Koncový spotrebiteľ si tiež môže vybrať službu a preferovaného poskytovateľa služieb.
{{< gallery match="images/4/*.png" >}}

## Pracovný čas a prestávky
Všeobecnú pracovnú dobu môžete nastaviť v časti "Nastavenia" > "Obchodná logika". Pracovný čas poskytovateľov služieb/užívateľov však možno zmeniť aj v "Pracovnom pláne" používateľa.
{{< gallery match="images/5/*.png" >}}

## Prehľad rezervácií a denník
V kalendári stretnutí sú viditeľné všetky rezervácie. Rezervácie môžete samozrejme vytvárať alebo upravovať aj tam.
{{< gallery match="images/6/*.png" >}}

## Farebné alebo logické úpravy
Ak skopírujete adresár "/app/www" a zaradíte ho ako "zväzok", môžete si upraviť súbory štýlov a logiku podľa svojich predstáv.
{{< gallery match="images/7/*.png" >}}