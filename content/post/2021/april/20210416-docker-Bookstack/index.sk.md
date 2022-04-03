+++
date = "2021-04-16"
title = "Veľké veci s kontajnermi: Vlastná Bookstack Wiki na stanici Synology DiskStation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "bookstack", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-Bookstack/index.sk.md"
+++
Bookstack je "open source" alternatíva k MediaWiki alebo Confluence. Dnes ukážem, ako nainštalovať službu Bookstack na diskovú stanicu Synology.
## Možnosť pre profesionálov
Ako skúsený používateľ Synology sa môžete samozrejme prihlásiť pomocou SSH a nainštalovať celú inštaláciu prostredníctvom súboru Docker Compose.
```
version: '3'
services:
  bookstack:
    image: solidnerd/bookstack:0.27.4-1
    restart: always
    ports:
      - 8080:8080
    links:
      - database
    environment:
      DB_HOST: database:3306
      DB_DATABASE: my_wiki
      DB_USERNAME: wikiuser
      DB_PASSWORD: my_wiki_pass
      
  database:
    image: mariadb
    restart: always
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: my_wiki_pass1
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
Ďalšie užitočné obrazy Docker na domáce použitie nájdete v [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Krok 1: Pripravte si priečinok s knihami
V adresári Docker vytvorím nový adresár s názvom "wiki".
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
|TZ	| Europe/Berlin |Časové pásmo|
|MYSQL_ROOT_PASSWORD	|  my_wiki_pass |Hlavné heslo databázy.|
|MYSQL_DATABASE | 	my_wiki	|Toto je názov databázy.|
|MYSQL_USER	|  wikiuser	|Meno používateľa databázy wiki.|
|MYSQL_PASSWORD	|  my_wiki_pass	|Heslo používateľa databázy wiki.|
{{</table>}}
Nakoniec zadám tieto premenné prostredia:Pozri:
{{< gallery match="images/6/*.png" >}}
Po týchto nastaveniach je možné spustiť server Mariadb! Všade stlačím tlačidlo "Použiť".
## Krok 3: Nainštalujte Bookstack
V okne Synology Docker kliknem na kartu "Registrácia" a vyhľadám položku "bookstack". Vyberiem obraz Docker "solidnerd/bookstack" a potom kliknem na značku "latest".
{{< gallery match="images/7/*.png" >}}
Dvakrát kliknem na svoj obrázok Bookstack. Potom kliknem na "Rozšírené nastavenia" a aktivujem tu aj "Automatický reštart".
{{< gallery match="images/8/*.png" >}}
Pre kontajner "bookstack" priraďujem pevné porty. Bez pevných portov by sa mohlo stať, že "bookstack server" po reštarte beží na inom porte. Prvý kontajnerový port je možné vymazať. Treba pamätať aj na druhý port.
{{< gallery match="images/9/*.png" >}}
Okrem toho je ešte potrebné vytvoriť "odkaz" na kontajner "mariadb". Kliknem na kartu Odkazy a vyberiem kontajner databázy. Názov aliasu by sa mal zapamätať pre inštaláciu wiki.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Názov premennej|Hodnota|Čo to je?|
|--- | --- |---|
|TZ	| Europe/Berlin |Časové pásmo|
|DB_HOST	| wiki-db:3306	|Názvy aliasov / prepojenie kontajnera|
|DB_DATABASE	| my_wiki |Údaje z kroku 2|
|DB_USERNAME	| wikiuser |Údaje z kroku 2|
|DB_PASSWORD	| my_wiki_pass	|Údaje z kroku 2|
{{</table>}}
Nakoniec zadám tieto premenné prostredia:Pozri:
{{< gallery match="images/11/*.png" >}}
Kontajner je teraz možné spustiť. Vytvorenie databázy môže chvíľu trvať. Správanie je možné sledovať prostredníctvom podrobností o kontajneri.
{{< gallery match="images/12/*.png" >}}
Zavolám server Bookstack s IP adresou Synology a svojím kontajnerovým portom. Prihlasovacie meno je "admin@admin.com" a heslo je "password".
{{< gallery match="images/13/*.png" >}}

