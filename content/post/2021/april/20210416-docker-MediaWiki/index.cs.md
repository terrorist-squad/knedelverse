+++
date = "2021-04-16"
title = "Skvělé věci s kontejnery: Instalace vlastního MediaWiki na diskové stanici Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "mediawiki", "wiki"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210416-docker-MediaWiki/index.cs.md"
+++
MediaWiki je wiki systém založený na PHP, který je k dispozici zdarma jako open source produkt. Dnes ukážu, jak nainstalovat službu MediaWiki na diskovou stanici Synology.
## Možnost pro profesionály
Jako zkušený uživatel Synology se samozřejmě můžete přihlásit pomocí SSH a nainstalovat celou instalaci pomocí souboru Docker Compose.
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
Další užitečné obrazy Docker pro domácí použití najdete v [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Krok 1: Příprava složky MediaWiki
V adresáři Docker vytvořím nový adresář s názvem "wiki".
{{< gallery match="images/1/*.png" >}}

## Krok 2: Instalace databáze
Poté je třeba vytvořit databázi. V okně Synology Docker kliknu na kartu "Registrace" a vyhledám "mariadb". Vyberu obraz Docker "mariadb" a kliknu na značku "latest".
{{< gallery match="images/2/*.png" >}}
Po stažení obrázku je obrázek k dispozici jako obrázek. Docker rozlišuje 2 stavy, kontejner "dynamický stav" a image (pevný stav). Před vytvořením kontejneru z obrazu je třeba provést několik nastavení. Poklepu na svůj obraz mariadb.
{{< gallery match="images/3/*.png" >}}
Pak kliknu na "Rozšířené nastavení" a aktivuji "Automatický restart". Vyberu kartu "Svazek" a kliknu na "Přidat složku". Tam vytvořím novou složku databáze s touto přípojnou cestou "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
V části "Nastavení portů" se odstraní všechny porty. To znamená, že vyberu port "3306" a odstraním jej pomocí tlačítka "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Název proměnné|Hodnota|Co to je?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Časové pásmo|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass	|Hlavní heslo databáze.|
|MYSQL_DATABASE |	my_wiki	|Jedná se o název databáze.|
|MYSQL_USER	| wikiuser |Uživatelské jméno databáze wiki.|
|MYSQL_PASSWORD	| my_wiki_pass |Heslo uživatele databáze wiki.|
{{</table>}}
Nakonec zadám tyto proměnné prostředí:Viz:
{{< gallery match="images/6/*.png" >}}
Po těchto nastaveních lze server Mariadb spustit! Všude stisknu tlačítko "Použít".
## Krok 3: Instalace MediaWiki
V okně Synology Docker kliknu na kartu "Registrace" a vyhledám "mediawiki". Vyberu obraz Docker "mediawiki" a kliknu na značku "latest".
{{< gallery match="images/7/*.png" >}}
Dvakrát kliknu na svůj obrázek v Mediawiki.
{{< gallery match="images/8/*.png" >}}
Pak kliknu na "Rozšířené nastavení" a aktivuji zde také "Automatický restart". Vyberu kartu "Svazek" a kliknu na "Přidat složku". Tam vytvořím novou složku s touto přípojnou cestou "/var/www/html/images".
{{< gallery match="images/9/*.png" >}}
Pro kontejner "MediaWiki" přiřadím pevné porty. Bez pevných portů by se mohlo stát, že "server MediaWiki" po restartu poběží na jiném portu.
{{< gallery match="images/10/*.png" >}}
Kromě toho je třeba ještě vytvořit "odkaz" na kontejner "mariadb". Kliknu na kartu Odkazy a vyberu kontejner databáze. Název aliasu by měl být zapamatován pro instalaci wiki.
{{< gallery match="images/11/*.png" >}}
Nakonec zadám proměnnou prostředí "TZ" s hodnotou "Europe/Berlin".
{{< gallery match="images/12/*.png" >}}
Nyní lze kontejner spustit. Zavolám server Mediawiki s IP adresou Synology a portem kontejneru. V části Databázový server zadám název aliasu databázového kontejneru. Zadám také název databáze, uživatelské jméno a heslo z kroku 2.
{{< gallery match="images/13/*.png" >}}