+++
date = "2021-04-16"
title = "Ustvarjalni izhod iz krize: rezervacija storitve z enostavnimi termini"
difficulty = "level-3"
tags = ["buchung", "buchungstool", "click-and-meet", "corona", "Docker", "docker-compose", "easyappointments", "krise", "einzelhandel", "geschaefte"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210414-docker-easyappointments/index.sl.md"
+++
Kriza v podjetju Corona je močno prizadela ponudnike storitev v Nemčiji. Digitalna orodja in rešitve vam lahko pomagajo čim bolj varno prebroditi pandemijo Corona. V tej seriji navodil "Ustvarjalno iz krize" prikazujem tehnologije ali orodja, ki so lahko koristna za mala podjetja.Danes prikazujem Easyappointments, orodje za rezervacijo storitev, na primer frizerjev ali trgovin, ki omogoča "klik in srečanje". Aplikacija Easyappointments je sestavljena iz dveh področij:
## Področje 1: zaledje
zaledje za upravljanje storitev in sestankov.
{{< gallery match="images/1/*.png" >}}

## Področje 2: Frontend
Orodje končnega uporabnika za rezervacijo sestankov. Vsi že rezervirani termini so blokirani in jih ni mogoče rezervirati dvakrat.
{{< gallery match="images/2/*.png" >}}

## Namestitev
Program Easyappointments sem že večkrat namestil s programom Docker-Compose in to metodo namestitve lahko toplo priporočam. V strežniku ustvarim nov imenik z imenom "easyappointments":
{{< terminal >}}
mkdir easyappointments
cd easyappointments

{{</ terminal >}}
Nato grem v imenik easyappointments in ustvarim novo datoteko easyappointments.yml z naslednjo vsebino:
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
Ta datoteka se zažene prek programa Docker Compose. Nato je namestitev dostopna v predvideni domeni/portalu.
{{< terminal >}}
docker-compose -f easyappointments.yml up

{{</ terminal >}}

## Ustvarjanje storitve
Storitve lahko ustvarite v razdelku "Storitve". Vsako novo storitev je nato treba dodeliti ponudniku storitev/uporabniku. To pomeni, da lahko naročim specializirane zaposlene ali ponudnike storitev.
{{< gallery match="images/3/*.png" >}}
Končni potrošnik lahko izbere tudi storitev in želenega ponudnika storitev.
{{< gallery match="images/4/*.png" >}}

## Delovni čas in odmori
Splošne dežurne ure lahko nastavite v razdelku "Nastavitve" > "Poslovna logika". Delovni čas ponudnikov storitev/uporabnikov pa je mogoče spremeniti tudi v "delovnem načrtu" uporabnika.
{{< gallery match="images/5/*.png" >}}

## Pregled rezervacij in dnevnik
V koledarju sestankov so vidne vse rezervacije. Seveda lahko rezervacije ustvarjate ali urejate tudi tam.
{{< gallery match="images/6/*.png" >}}

## Barvne ali logične prilagoditve
Če kopirate imenik "/app/www" in ga vključite kot "zvezek", lahko slogovne liste in logiko prilagodite po želji.
{{< gallery match="images/7/*.png" >}}
