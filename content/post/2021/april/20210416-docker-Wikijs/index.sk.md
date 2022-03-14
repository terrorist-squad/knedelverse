+++
date = "2021-04-16"
title = "Veľké veci s kontajnermi: Inštalácia Wiki.js na Synology Diskstation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "wikijs", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-Wikijs/index.sk.md"
+++
Wiki.js je výkonný softvér wiki s otvoreným zdrojovým kódom, ktorý vďaka svojmu jednoduchému rozhraniu spríjemňuje dokumentáciu. Dnes vám ukážem, ako nainštalovať službu Wiki.js do zariadenia Synology DiskStation.
## Možnosť pre profesionálov
Ako skúsený používateľ Synology sa môžete samozrejme prihlásiť pomocou SSH a nainštalovať celú inštaláciu prostredníctvom súboru Docker Compose.
```
version: '3'
services:
  wikijs:
    image: requarks/wiki:latest
    restart: always
    ports:
      - 8082:3000
    links:
      - database
    environment:
      DB_TYPE: mysql
      DB_HOST: database
      DB_PORT: 3306
      DB_NAME: my_wiki
      DB_USER: wikiuser
      DB_PASS: my_wiki_pass
      TZ: 'Europe/Berlin'

  database:
    image: mysql
    restart: always
    expose:
      - 3306
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: my_wiki_pass
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
Ďalšie užitočné obrazy Docker na domáce použitie nájdete v Dockerverse.
## Krok 1: Príprava priečinka wiki
V adresári Docker vytvorím nový adresár s názvom "wiki".
{{< gallery match="images/1/*.png" >}}

## Krok 2: Inštalácia databázy
Potom je potrebné vytvoriť databázu. V okne Synology Docker kliknem na kartu "Registrácia" a vyhľadám položku "mysql". Vyberiem obraz Docker "mysql" a potom kliknem na značku "latest".
{{< gallery match="images/2/*.png" >}}
Po stiahnutí obrázka je obrázok k dispozícii ako obrázok. Docker rozlišuje 2 stavy, kontajner "dynamický stav" a obraz (pevný stav). Pred vytvorením kontajnera z obrazu je potrebné vykonať niekoľko nastavení. Dvakrát kliknem na svoj obraz mysql.
{{< gallery match="images/3/*.png" >}}
Potom kliknem na "Rozšírené nastavenia" a aktivujem "Automatický reštart". Vyberiem kartu "Zväzok" a kliknem na "Pridať priečinok". Tam vytvorím nový priečinok databázy s touto prípojnou cestou "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
V časti "Nastavenia portov" sa odstránia všetky porty. To znamená, že vyberiem port "3306" a odstránim ho pomocou tlačidla "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Názov premennej|Hodnota|Čo to je?|
|--- | --- |---|
|TZ	| Europe/Berlin |Časové pásmo|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass |Hlavné heslo databázy.|
|MYSQL_DATABASE |	my_wiki |Toto je názov databázy.|
|MYSQL_USER	| wikiuser |Meno používateľa databázy wiki.|
|MYSQL_PASSWORD |	my_wiki_pass	|Heslo používateľa databázy wiki.|
{{</table>}}
Nakoniec zadám tieto štyri premenné prostredia:Pozri:
{{< gallery match="images/6/*.png" >}}
Po týchto nastaveniach je možné spustiť server Mariadb! Všade stlačím tlačidlo "Použiť".
## Krok 3: Inštalácia Wiki.js
V okne Synology Docker kliknem na kartu "Registrácia" a vyhľadám položku "wiki". Vyberiem obraz Docker "requarks/wiki" a potom kliknem na značku "latest".
{{< gallery match="images/7/*.png" >}}
Dvakrát kliknem na svoj obrázok WikiJS. Potom kliknem na "Rozšírené nastavenia" a aktivujem tu aj "Automatický reštart".
{{< gallery match="images/8/*.png" >}}
Pre kontajner "WikiJS" priraďujem pevné porty. Bez pevných portov by sa mohlo stať, že "bookstack server" po reštarte beží na inom porte.
{{< gallery match="images/9/*.png" >}}
Okrem toho je ešte potrebné vytvoriť "odkaz" na kontajner "mysql". Kliknem na kartu Odkazy a vyberiem kontajner databázy. Názov aliasu by sa mal zapamätať pre inštaláciu wiki.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Názov premennej|Hodnota|Čo to je?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Časové pásmo|
|DB_HOST	| wiki-db	|Názvy aliasov / prepojenie kontajnera|
|DB_TYPE	| mysql	||
|DB_PORT	| 3306	 ||
|DB_PASSWORD	| my_wiki	|Údaje z kroku 2|
|DB_USER	| wikiuser |Údaje z kroku 2|
|DB_PASS	| my_wiki_pass	|Údaje z kroku 2|
{{</table>}}
Nakoniec zadám tieto premenné prostredia:Pozri:
{{< gallery match="images/11/*.png" >}}
Kontajner je teraz možné spustiť. Zavolám server Wiki.js s IP adresou Synology a svojím kontajnerovým portom/3000.
{{< gallery match="images/12/*.png" >}}