+++
date = "2021-07-25"
title = "Wspaniałe rzeczy z pojemnikami: zarządzanie lodówką z Grocy"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "kühlschrank", "erp", "mhd", "Speispläne", "cms", "Cafe", "Bistro"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/july/20210725-docker-grocy/index.pl.md"
+++
Z Grocy możesz zarządzać całym gospodarstwem domowym, restauracją, kawiarnią, bistro lub marketem spożywczym. Możesz zarządzać lodówkami, menu, zadaniami, listami zakupów i datą przydatności do spożycia żywności.
{{< gallery match="images/1/*.png" >}}
Dziś pokażę jak zainstalować usługę Grocy na stacji dysków Synology.
## Opcja dla profesjonalistów
Jako doświadczony użytkownik Synology, możesz oczywiście zalogować się przez SSH i zainstalować całą konfigurację za pomocą pliku Docker Compose.
```
version: "2.1"
services:
  grocy:
    image: ghcr.io/linuxserver/grocy
    container_name: grocy
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./data:/config
    ports:
      - 9283:80
    restart: unless-stopped

```
Więcej przydatnych obrazów Dockera do użytku domowego można znaleźć w dziale [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Krok 1: Przygotuj folder Grocy
Tworzę nowy katalog o nazwie "grocy" w katalogu Dockera.
{{< gallery match="images/2/*.png" >}}

## Krok 2: Zainstaluj Grocy
Klikam kartę "Rejestracja" w oknie Synology Docker i wyszukuję "Grocy". Wybieram obraz Dockera "linuxserver/grocy:latest", a następnie klikam na tag "latest".
{{< gallery match="images/3/*.png" >}}
Klikam dwukrotnie na mój obraz Grocy.
{{< gallery match="images/4/*.png" >}}
Następnie klikam na "Ustawienia zaawansowane" i aktywuję "Automatyczny restart" również tutaj. Wybieram zakładkę "Volume" i klikam na "Add Folder". Tam tworzę nowy folder z tą ścieżką montowania "/config".
{{< gallery match="images/5/*.png" >}}
Przypisuję stałe porty dla kontenera "Grocy". Bez ustalonych portów może się zdarzyć, że "serwer Grocy" po restarcie działa na innym porcie.
{{< gallery match="images/6/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nazwa zmiennej|Wartość|Co to jest?|
|--- | --- |---|
|TZ | Europe/Berlin |Strefa czasowa|
|PUID | 1024 |ID użytkownika z Synology Admin User|
|PGID |	100 |Identyfikator grupy od użytkownika Synology Admin|
{{</table>}}
Na koniec wprowadzam te zmienne środowiskowe:Zobacz:
{{< gallery match="images/7/*.png" >}}
Kontener może być teraz uruchomiony. Wywołuję serwer Grocy, podając adres IP Synology i port mojego kontenera, a następnie loguję się, podając nazwę użytkownika "admin" i hasło "admin".
{{< gallery match="images/8/*.png" >}}
