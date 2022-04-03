+++
date = "2021-04-18"
title = "Skvělé věci s kontejnery: Vlastní WallaBag na diskové stanici Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "archiv", "wallabag"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-WallaBag/index.cs.md"
+++
Wallabag je program pro archivaci zajímavých webových stránek nebo článků. Dnes vám ukážu, jak nainstalovat službu Wallabag na diskovou stanici Synology.
## Možnost pro profesionály
Jako zkušený uživatel Synology se samozřejmě můžete přihlásit pomocí SSH a nainstalovat celou instalaci pomocí souboru Docker Compose.
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
Další užitečné obrazy Docker pro domácí použití najdete v [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Krok 1: Připravte si složku na nástěnné tašky
V adresáři Docker vytvořím nový adresář s názvem "wallabag".
{{< gallery match="images/1/*.png" >}}

## Krok 2: Instalace databáze
Poté je třeba vytvořit databázi. V okně Synology Docker kliknu na kartu "Registrace" a vyhledám položku "mariadb". Vyberu obraz Docker "mariadb" a kliknu na značku "latest".
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
|TZ| Europe/Berlin	|Časové pásmo|
|MYSQL_ROOT_PASSWORD	 | wallaroot |Hlavní heslo databáze.|
{{</table>}}
Nakonec zadám tyto proměnné prostředí:Viz:
{{< gallery match="images/6/*.png" >}}
Po těchto nastaveních lze server Mariadb spustit! Všude stisknu tlačítko "Použít".
{{< gallery match="images/7/*.png" >}}

## Krok 3: Instalace sáčku Wallabag
V okně Synology Docker kliknu na kartu "Registrace" a vyhledám položku "wallabag". Vyberu obraz Docker "wallabag/wallabag" a kliknu na značku "latest".
{{< gallery match="images/8/*.png" >}}
Dvakrát kliknu na obrázek svého wallabagu. Pak kliknu na "Rozšířené nastavení" a aktivuji zde také "Automatický restart".
{{< gallery match="images/9/*.png" >}}
Vyberu kartu "Svazek" a kliknu na "Přidat složku". Tam vytvořím novou složku s touto přípojnou cestou "/var/www/wallabag/web/assets/images".
{{< gallery match="images/10/*.png" >}}
Pro kontejner "wallabag" přiřazuji pevné porty. Bez pevných portů by se mohlo stát, že "server wallabag" po restartu poběží na jiném portu. První kontejnerový port lze odstranit. Je třeba pamatovat i na druhý přístav.
{{< gallery match="images/11/*.png" >}}
Kromě toho je třeba ještě vytvořit "odkaz" na kontejner "mariadb". Kliknu na kartu Odkazy a vyberu kontejner databáze. Název aliasu by měl být zapamatován pro instalaci wallabagu.
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
|SYMFONY__ENV__DOMAIN_NAME	|"http://synology-ip:container-port" <- Změňte prosím|
|SYMFONY__ENV__SERVER_NAME	|"Wallabag - Server"|
|SYMFONY__ENV__FOSUSER_CONFIRMATION	|false|
|SYMFONY__ENV__TWOFACTOR_AUTH	|false|
{{</table>}}
Nakonec zadám tyto proměnné prostředí:Viz:
{{< gallery match="images/13/*.png" >}}
Nyní lze kontejner spustit. Vytvoření databáze může nějakou dobu trvat. Chování lze sledovat prostřednictvím podrobností o kontejneru.
{{< gallery match="images/14/*.png" >}}
Zavolám server wallabag s IP adresou Synology a portem kontejneru.
{{< gallery match="images/15/*.png" >}}
Musím však říci, že osobně dávám přednost shiori jako internetovému archivu.
