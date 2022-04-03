+++
date = "2021-04-16"
title = "Luova ulos kriisistä: palvelun varaaminen easyappointments-palvelun avulla"
difficulty = "level-3"
tags = ["buchung", "buchungstool", "click-and-meet", "corona", "Docker", "docker-compose", "easyappointments", "krise", "einzelhandel", "geschaefte"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210414-docker-easyappointments/index.fi.md"
+++
Corona-kriisi iskee pahasti palveluntarjoajiin Saksassa. Digitaaliset työkalut ja ratkaisut voivat auttaa selviytymään Corona-pandemiasta mahdollisimman turvallisesti. Tässä opetusohjelmasarjassa "Creative out of the crisis" esittelen teknologioita tai työkaluja, jotka voivat olla hyödyllisiä pienille yrityksille.Tänään esittelen "Easyappointments", "klikkaa ja tapaa" -varausvälineen palveluille, esimerkiksi kampaamoille tai kaupoille. Easyappointments koostuu kahdesta alueesta:
## Alue 1: Backend
"Backend" palveluiden ja tapaamisten hallintaa varten.
{{< gallery match="images/1/*.png" >}}

## Alue 2: Frontend
Loppukäyttäjän työkalu tapaamisten varaamiseen. Kaikki jo varatut tapaamiset ovat tällöin estettyjä, eikä niitä voi varata kahteen kertaan.
{{< gallery match="images/2/*.png" >}}

## Asennus
Olen asentanut Easyappointmentsin jo useita kertoja Docker-Composen avulla ja voin suositella tätä asennustapaa. Luon palvelimelle uuden hakemiston nimeltä "easyappointments":
{{< terminal >}}
mkdir easyappointments
cd easyappointments

{{</ terminal >}}
Sitten menen easyappointments-hakemistoon ja luon uuden tiedoston nimeltä "easyappointments.yml", jonka sisältö on seuraava:
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
Tämä tiedosto käynnistetään Docker Composen kautta. Tämän jälkeen asennus on käytettävissä aiotulla toimialueella/portilla.
{{< terminal >}}
docker-compose -f easyappointments.yml up

{{</ terminal >}}

## Luo palvelu
Palvelut voidaan luoda kohdassa "Palvelut". Tämän jälkeen jokaiselle uudelle palvelulle on osoitettava palveluntarjoaja/käyttäjä. Tämä tarkoittaa, että voin varata erikoistuneita työntekijöitä tai palveluntarjoajia.
{{< gallery match="images/3/*.png" >}}
Loppukäyttäjä voi myös valita palvelun ja haluamansa palveluntarjoajan.
{{< gallery match="images/4/*.png" >}}

## Työaika ja tauot
Yleiset päivystysajat voidaan asettaa kohdassa "Asetukset" > "Business Logic". Palveluntarjoajien/käyttäjien työaikoja voidaan kuitenkin muuttaa myös käyttäjän "työsuunnitelmassa".
{{< gallery match="images/5/*.png" >}}

## Varausten yleiskatsaus ja päiväkirja
Ajanvarauskalenteri tuo kaikki varaukset näkyviin. Varauksia voidaan luonnollisesti luoda tai muokata myös siellä.
{{< gallery match="images/6/*.png" >}}

## Väri- tai loogiset säädöt
Jos kopioit hakemiston "/app/www" ja lisäät sen "tilavuudeksi", voit mukauttaa tyylilomakkeet ja logiikan haluamallasi tavalla.
{{< gallery match="images/7/*.png" >}}
