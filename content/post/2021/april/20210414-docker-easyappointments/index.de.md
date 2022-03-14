+++
date = "2021-04-16"
title = "Kreativ aus der Krise: Buchung einer Dienstleistung mit easyappointments"
difficulty = "level-3"
tags = ["buchung", "buchungstool", "click-and-meet", "corona", "Docker", "docker-compose", "easyappointments", "krise", "einzelhandel", "geschaefte"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210414-docker-easyappointments/index.de.md"
+++

Die Corona-Krise trifft die Dienstleister in Deutschland mit aller Härte. Digitale Tools und Lösungen können dabei helfen, so sicher wie möglich durch die Corona-Pandemie zu kommen. In dieser Tutorial-Reihe „Kreativ aus der Krise“ zeige ich Technologien bzw. Tools, die für Kleinunternehmen nützlich sein können.

Heute zeige ich „Easyappointments“, ein „click and meet“-Buchungstool für Dienstleistungen, zum Beispiel Friseure oder Geschäfte. Easyappointments besteht aus zwei Bereichen:

## Bereich 1: Backend
Ein „Backend“ für das Verwalten von Dienstleistung und Terminen.
{{< gallery match="images/1/*.png" >}}

## Bereich 2: Frontend
Ein Endverbraucher-Tool für die Termin-Buchung. Alle bereits verbuchten Termine werden danach gesperrt und können nicht doppelt belegt werden.
{{< gallery match="images/2/*.png" >}}

## Installation
Ich habe Easyappointments schon mehrfach mit Docker-Compose installiert und kann diese Installationsart sehr empfehlen. Ich erstelle ein neues Verzeichnis namens „easyappointments“ auf meinem Server:
{{< terminal >}}
mkdir easyappointments
cd easyappointments
{{</ terminal >}}

Danach gehe ich in das easyappointments–Verzeichnis und erstelle dort neue Datei namens „easyappointments.yml“ mit folgendem Inhalt:
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

Diese Datei wird via Docker-Compose gestartet. Danach ist die Installation unter der vorgesehenen Domain/port erreichbar.
{{< terminal >}}
docker-compose -f easyappointments.yml up
{{</ terminal >}}

## Anlegen einer Dienstleistung
Unter „Services“ lassen sich Dienstleistungen anlegen. Jede neue Dienstleistung muss danach einen Dienstleister/User zugeordnet werden. Das heißt, dass ich spezialisierte Mitarbeiter bzw. Dienstleister buchen kann. 
{{< gallery match="images/3/*.png" >}}

Auch der Endverbrauch kann die Dienstleistung und den bevorzugten Dienstleister wählen.
{{< gallery match="images/4/*.png" >}}

## Arbeitszeiten und Pausen
Allgemeine Dienstzeiten lassen sich unter „Settings“ > „Business Logic“ einstellen. Aber auch die Dienstzeiten von Dienstleistern/User kann man im „Working plan“ des Users ändern.
{{< gallery match="images/5/*.png" >}}

## Buchungsübersicht und Terminkalender
Der Terminkalender macht alle Buchungen sichtbar. Natürlich lassen sich auch dort Buchungen erstellen oder editieren.
{{< gallery match="images/6/*.png" >}}

## Farbliche bzw. logische Anpassungen
Wenn man sich das „/app/www“-Verzeichnis rauskopiert und als „Volume“ einbindet, dann kann man die Stylesheets und Logik beliebig anpassen.
{{< gallery match="images/7/*.png" >}}