+++
date = "2020-02-21"
title = "Skvelé veci s kontajnermi: Spustenie aplikácie Calibre pomocou nástroja Docker Compose (nastavenie Synology pro)"
difficulty = "level-3"
tags = ["calibre", "calibre-web", "Docker", "docker-compose", "Synology", "linux"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200221-docker-Calibre-pro/index.sk.md"
+++
Na tomto blogu už existuje jednoduchší návod: [Synology-Nas: Inštalácia Calibre Web ako knižnice elektronických kníh]({{< ref "post/2020/february/20200213-synology-calibreweb" >}} "Synology-Nas: Inštalácia Calibre Web ako knižnice elektronických kníh"). Tento návod je určený pre všetkých odborníkov na Synology DS.
## Krok 1: Príprava spoločnosti Synology
Najprv je potrebné aktivovať prihlásenie SSH na zariadení DiskStation. Ak to chcete urobiť, prejdite na "Ovládací panel" > "Terminál".
{{< gallery match="images/1/*.png" >}}
Potom sa môžete prihlásiť cez "SSH", zadaný port a heslo správcu (používatelia systému Windows používajú Putty alebo WinSCP).
{{< gallery match="images/2/*.png" >}}
Prihlásim sa cez terminál, winSCP alebo Putty a túto konzolu nechám otvorenú na neskôr.
## Krok 2: Vytvorenie priečinka s knihami
Vytvorím nový priečinok pre knižnicu Calibre. Vyvolám položku "Ovládanie systému" -> "Zdieľaný priečinok" a vytvorím nový priečinok s názvom "Knihy". Ak priečinok "Docker" ešte neexistuje, je potrebné ho tiež vytvoriť.
{{< gallery match="images/3/*.png" >}}

## Krok 3: Príprava priečinka s knihou
Teraz je potrebné stiahnuť a rozbaliť nasledujúci súbor: https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view. Obsah ("metadata.db") musí byť umiestnený v adresári novej knihy, pozri:
{{< gallery match="images/4/*.png" >}}

## Krok 4: Príprava priečinka Docker
V adresári Docker vytvorím nový adresár s názvom "calibre":
{{< gallery match="images/5/*.png" >}}
Potom prejdem do nového adresára a vytvorím nový súbor s názvom "calibre.yml" s nasledujúcim obsahom:
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
V tomto novom súbore je potrebné upraviť niekoľko miest nasledovne: * PUID/PGID: V poli PUID/PGID je potrebné zadať ID používateľa a ID skupiny používateľa DS. Tu použijem konzolu z kroku 1 a príkaz "id -u" na zobrazenie ID používateľa. Príkazom "id -g" získam ID skupiny.* porty: Pre port je potrebné upraviť prednú časť "8055:".adresáreVšetky adresáre v tomto súbore je potrebné opraviť. Správne adresy môžete vidieť v okne vlastností DS. (Nasleduje snímka obrazovky)
{{< gallery match="images/6/*.png" >}}

## Krok 5: Testovacie spustenie
V tomto kroku môžem tiež dobre využiť konzolu. Prepnem sa do adresára Calibre a spustím tam server Calibre prostredníctvom nástroja Docker Compose.
{{< terminal >}}
cd /volume1/docker/calibre
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}

{{< gallery match="images/7/*.png" >}}

## Krok 6: Nastavenie
Potom môžem zavolať svoj server Calibre pomocou IP adresy diskovej stanice a priradeného portu z kroku 4. V nastavení používam svoj prípojný bod "/books". Potom je už server použiteľný.
{{< gallery match="images/8/*.png" >}}

## Krok 7: Dokončenie nastavenia
V tomto kroku je potrebná aj konzola. Na uloženie databázy vnútornej aplikácie kontajnera používam príkaz "exec".
{{< terminal >}}
sudo docker exec -it calibre-web-server cp /app/calibre-web/app.db /briefkaste/app.db

{{</ terminal >}}
Potom sa v adresári Calibre zobrazí nový súbor "app.db":
{{< gallery match="images/9/*.png" >}}
Potom zastavím server Calibre:
{{< terminal >}}
sudo docker-compose -f calibre.yml down

{{</ terminal >}}
Teraz zmením cestu k poštovej schránke a databázu aplikácie nad ňou perzistuje.
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
Potom je možné server reštartovať:
{{< terminal >}}
sudo docker-compose -f calibre.yml up -d

{{</ terminal >}}