+++
date = "2021-04-16"
title = "Veľké veci s kontajnermi: Inštalácia vlastného MediaWiki na diskovej stanici Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "mediawiki", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-MediaWiki/index.sk.md"
+++
MediaWiki je systém wiki založený na jazyku PHP, ktorý je k dispozícii bezplatne ako produkt s otvoreným zdrojovým kódom. Dnes ukážem, ako nainštalovať službu MediaWiki na diskovú stanicu Synology.
## Možnosť pre profesionálov
Ako skúsený používateľ Synology sa môžete samozrejme prihlásiť pomocou SSH a nainštalovať celú inštaláciu prostredníctvom súboru Docker Compose.
```
version: '3'
services:
  mediawiki:
    image: mediawiki
    restart: always
    ports:
      - 8081:80
    links:
      - database
    volumes:
      - ./images:/var/www/html/images
      # After initial setup, download LocalSettings.php to the same directory as
      # this yaml and uncomment the following line and use compose to restart
      # the mediawiki service
      # - ./LocalSettings.php:/var/www/html/LocalSettings.php

  database:
    image: mariadb
    restart: always
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      # @see https://phabricator.wikimedia.org/source/mediawiki/browse/master/includes/DefaultSettings.php
      MYSQL_ROOT_PASSWORD: my_wiki_pass1
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass

```
Ďalšie užitočné obrazy Docker na domáce použitie nájdete v [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Krok 1: Príprava priečinka MediaWiki
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
|TZ	| Europe/Berlin	|Časové pásmo|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass	|Hlavné heslo databázy.|
|MYSQL_DATABASE |	my_wiki	|Toto je názov databázy.|
|MYSQL_USER	| wikiuser |Meno používateľa databázy wiki.|
|MYSQL_PASSWORD	| my_wiki_pass |Heslo používateľa databázy wiki.|
{{</table>}}
Nakoniec zadám tieto premenné prostredia:Pozri:
{{< gallery match="images/6/*.png" >}}
Po týchto nastaveniach je možné spustiť server Mariadb! Všade stlačím tlačidlo "Použiť".
## Krok 3: Inštalácia MediaWiki
V okne Synology Docker kliknem na kartu "Registrácia" a vyhľadám "mediawiki". Vyberiem obraz Docker "mediawiki" a potom kliknem na značku "latest".
{{< gallery match="images/7/*.png" >}}
Dvakrát kliknem na svoj obrázok Mediawiki.
{{< gallery match="images/8/*.png" >}}
Potom kliknem na "Rozšírené nastavenia" a aktivujem tu aj "Automatický reštart". Vyberiem kartu "Zväzok" a kliknem na "Pridať priečinok". Tam vytvorím nový priečinok s touto prípojnou cestou "/var/www/html/images".
{{< gallery match="images/9/*.png" >}}
Pre kontajner "MediaWiki" priraďujem pevné porty. Bez pevných portov by sa mohlo stať, že "server MediaWiki" po reštarte beží na inom porte.
{{< gallery match="images/10/*.png" >}}
Okrem toho je ešte potrebné vytvoriť "odkaz" na kontajner "mariadb". Kliknem na kartu Odkazy a vyberiem kontajner databázy. Názov aliasu by sa mal zapamätať pre inštaláciu wiki.
{{< gallery match="images/11/*.png" >}}
Nakoniec zadám premennú prostredia "TZ" s hodnotou "Europe/Berlin".
{{< gallery match="images/12/*.png" >}}
Kontajner je teraz možné spustiť. Zavolám server Mediawiki s IP adresou Synology a svojím kontajnerovým portom. V položke Databázový server zadám názov aliasu databázového kontajnera. Zadám aj názov databázy, meno používateľa a heslo z kroku 2.
{{< gallery match="images/13/*.png" >}}