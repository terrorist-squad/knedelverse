+++
date = "2021-04-16"
title = "Creativo fuori dalla crisi: prenotare un servizio con easyappointments"
difficulty = "level-3"
tags = ["buchung", "buchungstool", "click-and-meet", "corona", "Docker", "docker-compose", "easyappointments", "krise", "einzelhandel", "geschaefte"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210414-docker-easyappointments/index.it.md"
+++
La crisi di Corona sta colpendo duramente i fornitori di servizi in Germania. Gli strumenti e le soluzioni digitali possono aiutare a superare la pandemia di Corona nel modo più sicuro possibile. In questa serie di tutorial "Creativi fuori dalla crisi" mostro tecnologie o strumenti che possono essere utili per le piccole imprese. Oggi mostro "Easyappointments", uno strumento di prenotazione "clicca e incontra" per servizi, per esempio parrucchieri o negozi. Easyappointments consiste in due aree:
## Area 1: Backend
Un "backend" per la gestione dei servizi e degli appuntamenti.
{{< gallery match="images/1/*.png" >}}

## Area 2: Frontend
Uno strumento dell'utente finale per la prenotazione di appuntamenti. Tutti gli appuntamenti già prenotati sono quindi bloccati e non possono essere prenotati due volte.
{{< gallery match="images/2/*.png" >}}

## Installazione
Ho già installato Easyappointments diverse volte con Docker-Compose e posso consigliare vivamente questo metodo di installazione. Creo una nuova directory chiamata "easyappointments" sul mio server:
{{< terminal >}}
mkdir easyappointments
cd easyappointments

{{</ terminal >}}
Poi vado nella directory easyappointments e creo un nuovo file chiamato "easyappointments.yml" con il seguente contenuto:
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
Questo file viene avviato tramite Docker Compose. In seguito, l'installazione è accessibile sotto il dominio/la porta previsti.
{{< terminal >}}
docker-compose -f easyappointments.yml up

{{</ terminal >}}

## Creare un servizio
I servizi possono essere creati sotto "Servizi". Ogni nuovo servizio deve poi essere assegnato a un fornitore/utente di servizi. Questo significa che posso prenotare impiegati specializzati o fornitori di servizi.
{{< gallery match="images/3/*.png" >}}
Il consumatore finale può anche scegliere il servizio e il fornitore di servizi preferito.
{{< gallery match="images/4/*.png" >}}

## Orari di lavoro e pause
Le ore di servizio generali possono essere impostate in "Impostazioni" > "Logica aziendale". Tuttavia, l'orario di lavoro dei fornitori di servizi/utenti può anche essere cambiato nel "Piano di lavoro" dell'utente.
{{< gallery match="images/5/*.png" >}}

## Panoramica delle prenotazioni e agenda
Il calendario degli appuntamenti rende visibili tutte le prenotazioni. Naturalmente, le prenotazioni possono anche essere create o modificate lì.
{{< gallery match="images/6/*.png" >}}

## Regolazioni di colore o logiche
Se copiate la directory "/app/www" e la includete come "volume", allora potete adattare i fogli di stile e la logica come volete.
{{< gallery match="images/7/*.png" >}}
