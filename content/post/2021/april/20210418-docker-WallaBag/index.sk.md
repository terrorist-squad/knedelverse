+++
date = "2021-04-18"
title = "Skvelé veci s kontajnermi: Vlastný WallaBag na diskovej stanici Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "archiv", "wallabag"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-WallaBag/index.sk.md"
+++
Wallabag je program na archiváciu zaujímavých webových stránok alebo článkov. Dnes vám ukážem, ako nainštalovať službu Wallabag na diskovú stanicu Synology.
## Možnosť pre profesionálov
Ako skúsený používateľ Synology sa môžete samozrejme prihlásiť pomocou SSH a nainštalovať celú inštaláciu prostredníctvom súboru Docker Compose.
```
version: '3'
services:
  wallabag:
    image: wallabag/wallabag
    environment:
      - MYSQL_ROOT_PASSWORD=wallaroot
      - SYMFONY__ENV__DATABASE_DRIVER=pdo_mysql
      - SYMFONY__ENV__DATABASE_HOST=db
      - SYMFONY__ENV__DATABASE_PORT=3306
      - SYMFONY__ENV__DATABASE_NAME=wallabag
      - SYMFONY__ENV__DATABASE_USER=wallabag
      - SYMFONY__ENV__DATABASE_PASSWORD=wallapass
      - SYMFONY__ENV__DATABASE_CHARSET=utf8mb4
      - SYMFONY__ENV__DOMAIN_NAME=http://192.168.178.50:8089
      - SYMFONY__ENV__SERVER_NAME="Your wallabag instance"
      - SYMFONY__ENV__FOSUSER_CONFIRMATION=false
      - SYMFONY__ENV__TWOFACTOR_AUTH=false
    ports:
      - "8089:80"
    volumes:
      - ./wallabag/images:/var/www/wallabag/web/assets/images

  db:
    image: mariadb
    environment:
      - MYSQL_ROOT_PASSWORD=wallaroot
    volumes:
      - ./mariadb:/var/lib/mysql

```
Ďalšie užitočné obrazy Docker na domáce použitie nájdete v [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Krok 1: Pripravte si priečinok s vreckom
V adresári Docker vytvorím nový adresár s názvom "wallabag".
{{< gallery match="images/1/*.png" >}}

## Krok 2: Inštalácia databázy
Potom je potrebné vytvoriť databázu. V okne Synology Docker kliknem na kartu "Registrácia" a vyhľadám položku "mariadb". Vyberiem obraz Docker "mariadb" a potom kliknem na značku "latest".
{{< gallery match="images/2/*.png" >}}
Po stiahnutí obrázka je obrázok k dispozícii ako obrázok. Docker rozlišuje 2 stavy, kontajner "dynamický stav" a obraz (pevný stav). Pred vytvorením kontajnera z obrazu je potrebné vykonať niekoľko nastavení. Dvakrát kliknem na svoj obraz mariadb.
{{< gallery match="images/3/*.png" >}}
Potom kliknem na "Rozšírené nastavenia" a aktivujem "Automatický reštart". Vyberiem kartu "Zväzok" a kliknem na "Pridať priečinok". Tam vytvorím nový priečinok databázy s touto prípojnou cestou "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
V časti "Nastavenia portov" sa odstránia všetky porty. To znamená, že vyberiem port "3306" a odstránim ho pomocou tlačidla "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Názov premennej|Hodnota|Čo to je?|
|--- | --- |---|
|TZ| Europe/Berlin	|Časové pásmo|
|MYSQL_ROOT_PASSWORD	 | wallaroot |Hlavné heslo databázy.|
{{</table>}}
Nakoniec zadám tieto premenné prostredia:Pozri:
{{< gallery match="images/6/*.png" >}}
Po týchto nastaveniach je možné spustiť server Mariadb! Všade stlačím tlačidlo "Použiť".
{{< gallery match="images/7/*.png" >}}

## Krok 3: Inštalácia vrecka Wallabag
V okne Synology Docker kliknem na kartu "Registrácia" a vyhľadám položku "wallabag". Vyberiem obraz Docker "wallabag/wallabag" a potom kliknem na značku "latest".
{{< gallery match="images/8/*.png" >}}
Dvakrát kliknem na svoj obrázok nástennej tašky. Potom kliknem na "Rozšírené nastavenia" a aktivujem tu aj "Automatický reštart".
{{< gallery match="images/9/*.png" >}}
Vyberiem kartu "Zväzok" a kliknem na "Pridať priečinok". Tam vytvorím nový priečinok s touto prípojnou cestou "/var/www/wallabag/web/assets/images".
{{< gallery match="images/10/*.png" >}}
Pre kontajner "wallabag" priraďujem pevné porty. Bez pevných portov by sa mohlo stať, že "wallabag server" po reštarte beží na inom porte. Prvý kontajnerový port je možné vymazať. Treba pamätať aj na druhý port.
{{< gallery match="images/11/*.png" >}}
Okrem toho je ešte potrebné vytvoriť "odkaz" na kontajner "mariadb". Kliknem na kartu Odkazy a vyberiem kontajner databázy. Názov aliasu by sa mal zapamätať pre inštaláciu wallabagu.
{{< gallery match="images/12/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Umgebungsvariable	|Hodnota|
|--- |---|
|MYSQL_ROOT_PASSWORD	|wallaroot|
|SYMFONY__ENV__DATABASE_DRIVER	|pdo_mysql|
|SYMFONY__ENV__DATABASE_HOST	|db|
|SYMFONY__ENV__DATABASE_PORT	|3306|
|SYMFONY__ENV__DATABASE_NAME	|wallabag|
|SYMFONY__ENV__DATABASE_USER	|wallabag|
|SYMFONY__ENV__DATABASE_PASSWORD	|wallapass|
|SYMFONY__ENV__DATABASE_CHARSET |utf8mb4|
|SYMFONY__ENV__DOMAIN_NAME	|"http://synology-ip:container-port" <- Prosím, zmeňte|
|SYMFONY__ENV__SERVER_NAME	|"Wallabag - Server"|
|SYMFONY__ENV__FOSUSER_CONFIRMATION	|nepravdivé|
|SYMFONY__ENV__TWOFACTOR_AUTH	|nepravdivé|
{{</table>}}
Nakoniec zadám tieto premenné prostredia:Pozri:
{{< gallery match="images/13/*.png" >}}
Kontajner je teraz možné spustiť. Vytvorenie databázy môže chvíľu trvať. Správanie je možné sledovať prostredníctvom podrobností o kontajneri.
{{< gallery match="images/14/*.png" >}}
Zavolám server wallabag s IP adresou Synology a svojím kontajnerovým portom.
{{< gallery match="images/15/*.png" >}}
Musím však povedať, že ja osobne uprednostňujem shiori ako internetový archív.
