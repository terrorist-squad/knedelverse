+++
date = "2021-04-16"
title = "Kreatywne wyjście z kryzysu: rezerwacja usług za pomocą easyappointments"
difficulty = "level-3"
tags = ["buchung", "buchungstool", "click-and-meet", "corona", "Docker", "docker-compose", "easyappointments", "krise", "einzelhandel", "geschaefte"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210414-docker-easyappointments/index.pl.md"
+++
Kryzys związany z firmą Corona mocno uderza w dostawców usług w Niemczech. Narzędzia i rozwiązania cyfrowe mogą pomóc w jak najbezpieczniejszym przejściu pandemii Corony. W serii poradników "Kreatywne wychodzenie z kryzysu" pokazuję technologie i narzędzia, które mogą być przydatne dla małych firm. Dzisiaj przedstawiam "Easyappointments", narzędzie do rezerwacji usług typu "kliknij i spotkaj się", np. dla fryzjerów lub sklepów. Program Łatwe Nominacje składa się z dwóch obszarów:
## Obszar 1: zaplecze
zaplecze" do zarządzania usługami i terminami.
{{< gallery match="images/1/*.png" >}}

## Obszar 2: Frontend
Narzędzie dla użytkowników końcowych służące do rezerwacji terminów. Wszystkie już zarezerwowane terminy są blokowane i nie można ich rezerwować dwukrotnie.
{{< gallery match="images/2/*.png" >}}

## Instalacja
Zainstalowałem już kilka razy Easyappointments za pomocą Docker-Compose i mogę gorąco polecić tę metodę instalacji. Na moim serwerze tworzę nowy katalog o nazwie "easyappointments":
{{< terminal >}}
mkdir easyappointments
cd easyappointments

{{</ terminal >}}
Następnie przechodzę do katalogu easyappointments i tworzę nowy plik o nazwie "easyappointments.yml" o następującej zawartości:
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
Ten plik jest uruchamiany za pomocą aplikacji Docker Compose. Następnie instalacja jest dostępna pod przewidzianą domeną/portem.
{{< terminal >}}
docker-compose -f easyappointments.yml up

{{</ terminal >}}

## Utwórz usługę
Usługi można tworzyć w zakładce "Usługi". Następnie każda nowa usługa musi zostać przypisana do usługodawcy/użytkownika. Oznacza to, że mogę zarezerwować wyspecjalizowanych pracowników lub usługodawców.
{{< gallery match="images/3/*.png" >}}
Konsument końcowy może również wybrać usługę i preferowanego dostawcę usług.
{{< gallery match="images/4/*.png" >}}

## Czas pracy i przerwy
Ogólne godziny dyżuru można ustawić w obszarze "Ustawienia" > "Logika biznesowa". Godziny pracy usługodawców/użytkowników można jednak również zmienić w "Planie pracy" użytkownika.
{{< gallery match="images/5/*.png" >}}

## Przegląd i terminarz rezerwacji
W kalendarzu spotkań widoczne są wszystkie rezerwacje. Oczywiście można tam również tworzyć i edytować rezerwacje.
{{< gallery match="images/6/*.png" >}}

## Korekty kolorystyczne lub logiczne
Jeśli skopiujesz katalog "/app/www" i dołączysz go jako "wolumin", będziesz mógł dowolnie dostosować arkusze stylów i logikę.
{{< gallery match="images/7/*.png" >}}
