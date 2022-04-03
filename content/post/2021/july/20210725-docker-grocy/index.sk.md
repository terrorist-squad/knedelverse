+++
date = "2021-07-25"
title = "Veľké veci s kontajnermi: správa chladničky s Grocy"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "kühlschrank", "erp", "mhd", "Speispläne", "cms", "Cafe", "Bistro"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/july/20210725-docker-grocy/index.sk.md"
+++
Pomocou Grocy môžete spravovať celú domácnosť, reštauráciu, kaviareň, bistro alebo potravinový trh. Môžete spravovať chladničky, jedálne lístky, úlohy, nákupné zoznamy a trvanlivosť potravín.
{{< gallery match="images/1/*.png" >}}
Dnes ukážem, ako nainštalovať službu Grocy na diskovú stanicu Synology.
## Možnosť pre profesionálov
Ako skúsený používateľ Synology sa môžete samozrejme prihlásiť pomocou SSH a nainštalovať celú inštaláciu prostredníctvom súboru Docker Compose.
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
Ďalšie užitočné obrazy Docker na domáce použitie nájdete v [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Krok 1: Príprava zložky Grocy
V adresári Docker vytvorím nový adresár s názvom "grocy".
{{< gallery match="images/2/*.png" >}}

## Krok 2: Inštalácia Grocy
V okne Synology Docker kliknem na kartu "Registrácia" a vyhľadám položku "Grocy". Vyberiem obraz Docker "linuxserver/grocy:latest" a potom kliknem na značku "latest".
{{< gallery match="images/3/*.png" >}}
Dvakrát kliknem na svoj obrázok Grocy.
{{< gallery match="images/4/*.png" >}}
Potom kliknem na "Rozšírené nastavenia" a aktivujem tu aj "Automatický reštart". Vyberiem kartu "Zväzok" a kliknem na "Pridať priečinok". Tam vytvorím nový priečinok s touto prípojnou cestou "/config".
{{< gallery match="images/5/*.png" >}}
Pre kontajner "Grocy" priraďujem pevné porty. Bez pevných portov by sa mohlo stať, že "Grocy server" po reštarte beží na inom porte.
{{< gallery match="images/6/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Názov premennej|Hodnota|Čo to je?|
|--- | --- |---|
|TZ | Europe/Berlin |Časové pásmo|
|PUID | 1024 |ID používateľa od používateľa Synology Admin|
|PGID |	100 |ID skupiny od používateľa Synology Admin|
{{</table>}}
Nakoniec zadám tieto premenné prostredia:Pozri:
{{< gallery match="images/7/*.png" >}}
Kontajner je teraz možné spustiť. Vyvolám server Grocy s IP adresou Synology a mojím kontajnerovým portom a prihlásim sa pomocou používateľského mena "admin" a hesla "admin".
{{< gallery match="images/8/*.png" >}}

