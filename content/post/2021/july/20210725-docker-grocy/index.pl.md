+++
date = "2021-07-25"
title = "Wspaniałe rzeczy z pojemnikami: zarządzanie lodówką z Grocy"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "kühlschrank", "erp", "mhd", "Speispläne", "cms", "Cafe", "Bistro"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/july/20210725-docker-grocy/index.pl.md"
+++
Za pomocą aplikacji Grocy można zarządzać całym gospodarstwem domowym, restauracją, kawiarnią, bistro lub marketem spożywczym. Można zarządzać lodówkami, menu, zadaniami, listami zakupów i datą przydatności do spożycia żywności.
{{< gallery match="images/1/*.png" >}}
Dzisiaj pokażę, jak zainstalować usługę Grocy na stacji dysków Synology.
## Opcja dla profesjonalistów
Jako doświadczony użytkownik Synology możesz oczywiście zalogować się przez SSH i zainstalować całą konfigurację za pomocą pliku Docker Compose.
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
Więcej przydatnych obrazów Dockera do użytku domowego można znaleźć w sekcji [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Krok 1: Przygotuj folder Grocy
W katalogu Docker tworzę nowy katalog o nazwie "grocy".
{{< gallery match="images/2/*.png" >}}

## Krok 2: Zainstaluj Grocy
Klikam kartę "Rejestracja" w oknie Synology Docker i wyszukuję "Grocy". Wybieram obraz Dockera "linuxserver/grocy:latest", a następnie klikam znacznik "latest".
{{< gallery match="images/3/*.png" >}}
Klikam dwukrotnie obraz Grocy.
{{< gallery match="images/4/*.png" >}}
Następnie klikam na "Ustawienia zaawansowane" i włączam opcję "Automatyczne ponowne uruchamianie". Wybieram zakładkę "Wolumin" i klikam "Dodaj folder". W tym miejscu tworzę nowy folder ze ścieżką montowania "/config".
{{< gallery match="images/5/*.png" >}}
Przydzielam stałe porty dla kontenera "Grocy". Bez ustalonych portów może się zdarzyć, że po ponownym uruchomieniu "serwer Grocy" będzie działał na innym porcie.
{{< gallery match="images/6/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Nazwa zmiennej|Wartość|Co to jest?|
|--- | --- |---|
|TZ | Europe/Berlin |Strefa czasowa|
|PUID | 1024 |Identyfikator użytkownika z programu Synology Admin User|
|PGID |	100 |Identyfikator grupy od użytkownika Synology Admin User|
{{</table>}}
Na koniec wprowadzam następujące zmienne środowiskowe: Zobacz:
{{< gallery match="images/7/*.png" >}}
Teraz można uruchomić kontener. Wywołuję serwer Grocy, podając adres IP Synology i port mojego kontenera, a następnie loguję się, podając nazwę użytkownika "admin" i hasło "admin".
{{< gallery match="images/8/*.png" >}}

