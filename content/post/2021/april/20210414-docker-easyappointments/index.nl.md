+++
date = "2021-04-16"
title = "Creatief uit de crisis: een dienst boeken met easyappointments"
difficulty = "level-3"
tags = ["buchung", "buchungstool", "click-and-meet", "corona", "Docker", "docker-compose", "easyappointments", "krise", "einzelhandel", "geschaefte"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210414-docker-easyappointments/index.nl.md"
+++
De Corona-crisis treft de dienstverleners in Duitsland hard. Digitale hulpmiddelen en oplossingen kunnen helpen om de Corona-pandemie zo veilig mogelijk door te komen. In deze tutorial serie "Creatief uit de crisis" laat ik technologieën of tools zien die nuttig kunnen zijn voor kleine bedrijven.Vandaag laat ik "Easyappointments" zien, een "klik en ontmoet" boekingstool voor diensten, bijvoorbeeld kappers of winkels. Easyappointments bestaat uit twee gebieden:
## Gebied 1: Achterkant
Een "backend" voor het beheer van diensten en afspraken.
{{< gallery match="images/1/*.png" >}}

## Gebied 2: Frontend
Een hulpmiddel voor de eindgebruiker om afspraken te maken. Alle reeds geboekte afspraken worden dan geblokkeerd en kunnen niet tweemaal worden geboekt.
{{< gallery match="images/2/*.png" >}}

## Installatie
Ik heb Easyappointments al verschillende keren geïnstalleerd met Docker-Compose en kan deze installatiemethode ten zeerste aanbevelen. Ik maak een nieuwe map aan genaamd "easyappointments" op mijn server:
{{< terminal >}}
mkdir easyappointments
cd easyappointments

{{</ terminal >}}
Dan ga ik naar de easyappointments directory en maak een nieuw bestand aan genaamd "easyappointments.yml" met de volgende inhoud:
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
Dit bestand wordt gestart via Docker Compose. Daarna is de installatie toegankelijk onder het beoogde domein/poort.
{{< terminal >}}
docker-compose -f easyappointments.yml up

{{</ terminal >}}

## Een dienst creëren
Diensten kunnen worden aangemaakt onder "Diensten". Elke nieuwe dienst moet vervolgens worden toegewezen aan een dienstverlener/gebruiker. Dit betekent dat ik gespecialiseerde werknemers of dienstverleners kan boeken.
{{< gallery match="images/3/*.png" >}}
De eindgebruiker kan ook de dienst en de dienstverlener van zijn voorkeur kiezen.
{{< gallery match="images/4/*.png" >}}

## Werktijden en pauzes
Algemene diensturen kunnen worden ingesteld onder "Instellingen" > "Bedrijfslogica". De werktijden van dienstverleners/gebruikers kunnen echter ook worden gewijzigd in het "Werkplan" van de gebruiker.
{{< gallery match="images/5/*.png" >}}

## Boekingsoverzicht en agenda
De afsprakenkalender maakt alle boekingen zichtbaar. Natuurlijk kunnen ook daar boekingen worden aangemaakt of bewerkt.
{{< gallery match="images/6/*.png" >}}

## Kleur of logische aanpassingen
Als je de "/app/www" directory kopieert en opneemt als een "volume", dan kun je de stylesheets en logica aanpassen zoals je wilt.
{{< gallery match="images/7/*.png" >}}
