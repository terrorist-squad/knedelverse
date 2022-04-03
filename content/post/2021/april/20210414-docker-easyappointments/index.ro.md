+++
date = "2021-04-16"
title = "Creativ din criză: rezervarea unui serviciu cu easyappointments"
difficulty = "level-3"
tags = ["buchung", "buchungstool", "click-and-meet", "corona", "Docker", "docker-compose", "easyappointments", "krise", "einzelhandel", "geschaefte"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210414-docker-easyappointments/index.ro.md"
+++
Criza Corona lovește puternic furnizorii de servicii din Germania. Instrumentele și soluțiile digitale pot ajuta să trecem prin pandemia Corona în condiții cât mai sigure. În această serie de tutoriale "Ieșirea creativă din criză" vă prezint tehnologii sau instrumente care pot fi utile pentru întreprinderile mici.Astăzi vă prezint "Easyappointments", un instrument de rezervare "click and meet" pentru servicii, de exemplu coafor sau magazine. Easyappointments este format din două domenii:
## Zona 1: Backend
Un "backend" pentru gestionarea serviciilor și a programărilor.
{{< gallery match="images/1/*.png" >}}

## Domeniul 2: Frontend
Un instrument pentru utilizatorul final pentru programări. Toate programările deja rezervate sunt apoi blocate și nu pot fi rezervate de două ori.
{{< gallery match="images/2/*.png" >}}

## Instalare
Am instalat deja Easyappointments de mai multe ori cu Docker-Compose și pot recomanda cu căldură această metodă de instalare. Creez un nou director numit "easyappointments" pe serverul meu:
{{< terminal >}}
mkdir easyappointments
cd easyappointments

{{</ terminal >}}
Apoi, mă duc în directorul easyappointments și creez un nou fișier numit "easyappointments.yml" cu următorul conținut:
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
Acest fișier este pornit prin Docker Compose. Ulterior, instalația este accesibilă sub domeniul/portul dorit.
{{< terminal >}}
docker-compose -f easyappointments.yml up

{{</ terminal >}}

## Creați un serviciu
Serviciile pot fi create la rubrica "Servicii". Fiecare serviciu nou trebuie apoi atribuit unui furnizor de servicii/utilizator. Acest lucru înseamnă că pot rezerva angajați sau furnizori de servicii specializați.
{{< gallery match="images/3/*.png" >}}
De asemenea, consumatorul final poate alege serviciul și furnizorul de servicii preferat.
{{< gallery match="images/4/*.png" >}}

## Ore de lucru și pauze
Orele de serviciu generale pot fi setate în "Settings" > "Business Logic". Cu toate acestea, orele de lucru ale furnizorilor de servicii/utilizatorilor pot fi, de asemenea, modificate în "Planul de lucru" al utilizatorului.
{{< gallery match="images/5/*.png" >}}

## Prezentare generală a rezervărilor și agenda
Calendarul de programări face vizibile toate rezervările. Bineînțeles, rezervările pot fi create sau modificate tot acolo.
{{< gallery match="images/6/*.png" >}}

## Ajustări de culoare sau logice
Dacă copiați directorul "/app/www" și îl includeți ca "volum", atunci puteți adapta foile de stil și logica după cum doriți.
{{< gallery match="images/7/*.png" >}}
