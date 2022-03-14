+++
date = "2020-02-21"
title = "Velike stvari s posodami: Zagon programa Calibre s programom Docker Compose (namestitev Synology pro)"
difficulty = "level-3"
tags = ["calibre", "calibre-web", "Docker", "docker-compose", "Synology", "linux"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200221-docker-Calibre-pro/index.sl.md"
+++
Na tem blogu že obstaja lažje vodilo: [Synology-Nas: Namestite Calibre Web kot knjižnico e-knjig]({{< ref "post/2020/february/20200213-synology-calibreweb" >}} "Synology-Nas: Namestite Calibre Web kot knjižnico e-knjig"). Ta vadnica je namenjena vsem strokovnjakom za Synology DS.
## Korak 1: Pripravite Synology
Najprej je treba na napravi DiskStation aktivirati prijavo SSH. To storite tako, da greste v "Nadzorna plošča" > "Terminal".
{{< gallery match="images/1/*.png" >}}
Nato se lahko prijavite prek SSH, določenih vrat in skrbniškega gesla (uporabniki Windows uporabljajo Putty ali WinSCP).
{{< gallery match="images/2/*.png" >}}
Prijavim se prek terminala, winSCP ali Puttyja in pustim to konzolo odprto za pozneje.
## Korak 2: Ustvarite mapo s knjigami
Ustvarim novo mapo za knjižnico Calibre. To storim tako, da prikličem "Nadzor sistema" -> "Skupna mapa" in ustvarim novo mapo z imenom "Knjige". Če mape "Docker" še ni, je treba ustvariti tudi to mapo.
{{< gallery match="images/3/*.png" >}}

## Korak 3: Pripravite mapo s knjigo
Zdaj je treba prenesti in razpakirati naslednjo datoteko: https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view. Vsebino ("metadata.db") je treba postaviti v imenik nove knjige, glejte:
{{< gallery match="images/4/*.png" >}}

## Korak 4: Pripravite mapo Docker
V imeniku programa Docker ustvarim nov imenik z imenom "calibre":
{{< gallery match="images/5/*.png" >}}
Nato preidem v nov imenik in ustvarim novo datoteko z imenom "calibre.yml" z naslednjo vsebino:
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre:/briefkaste
    ports:
      - 8055:8083
    restart: unless-stopped

```
V tej novi datoteki je treba prilagoditi več mest, kot sledi: * PUID/PGID: V polje PUID/PGID je treba vnesti ID uporabnika in skupine uporabnika DS. Tukaj uporabim konzolo iz "koraka 1" in ukaze "id -u", da vidim ID uporabnika. Z ukazom "id -g" dobim ID skupine.* vrata: Za vrata je treba prilagoditi sprednji del "8055:".imenikiVse imenike v tej datoteki je treba popraviti. Pravilni naslovi so vidni v oknu lastnosti DS. (Sledi posnetek zaslona)
{{< gallery match="images/6/*.png" >}}

## Korak 5: Testni zagon
V tem koraku lahko dobro izkoristim tudi konzolo. Spremenim se v imenik Calibre in tam zaženem strežnik Calibre prek programa Docker Compose.
{{< terminal >}}
cd /volume1/docker/calibre
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}

{{< gallery match="images/7/*.png" >}}

## Korak 6: Nastavitev
Nato lahko pokličem strežnik Calibre z naslovom IP diskovne postaje in dodeljenimi vrati iz koraka 4. V nastavitvi uporabljam svojo priključno točko "/books". Po tem je strežnik že uporaben.
{{< gallery match="images/8/*.png" >}}

## Korak 7: Dokončanje nastavitve
V tem koraku je potrebna tudi konzola. Z ukazom "exec" shranim notranjo podatkovno bazo aplikacije zabojnika.
{{< terminal >}}
sudo docker exec -it calibre-web-server cp /app/calibre-web/app.db /briefkaste/app.db

{{</ terminal >}}
Nato se v imeniku Calibre pojavi nova datoteka "app.db":
{{< gallery match="images/9/*.png" >}}
Nato zaustavim strežnik Calibre:
{{< terminal >}}
sudo docker-compose -f calibre.yml down

{{</ terminal >}}
Sedaj spremenim pot do poštnega predala in nad njo ohranim podatkovno bazo aplikacije.
```
version: '2'
services:
  calibre-web:
    image: linuxserver/calibre-web
    container_name: calibre-web-server
    environment:
      - PUID=1026
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - /volume1/Buecher:/books
      - /volume1/docker/calibre/app.db:/app/calibre-web/app.db
    ports:
      - 8055:8083
    restart: unless-stopped

```
Nato lahko strežnik ponovno zaženete:
{{< terminal >}}
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}