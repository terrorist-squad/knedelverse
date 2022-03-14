+++
date = "2021-04-16"
title = "Velké věci s kontejnery: Instalace Wiki.js na stanici Synology Diskstation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "wikijs", "wiki"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210416-docker-Wikijs/index.cs.md"
+++
Wiki.js je výkonný open source wiki software, který díky svému jednoduchému rozhraní zpříjemňuje práci s dokumentací. Dnes vám ukážu, jak nainstalovat službu Wiki.js na stanici Synology DiskStation.
## Možnost pro profesionály
Jako zkušený uživatel Synology se samozřejmě můžete přihlásit pomocí SSH a nainstalovat celou instalaci pomocí souboru Docker Compose.
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
Další užitečné obrazy Docker pro domácí použití najdete v Dockerverse.
## Krok 1: Příprava složky wiki
V adresáři Docker vytvořím nový adresář s názvem "wiki".
{{< gallery match="images/1/*.png" >}}

## Krok 2: Instalace databáze
Poté je třeba vytvořit databázi. V okně Synology Docker kliknu na kartu "Registrace" a vyhledám "mysql". Vyberu obraz Docker "mysql" a kliknu na značku "latest".
{{< gallery match="images/2/*.png" >}}
Po stažení obrázku je obrázek k dispozici jako obrázek. Docker rozlišuje 2 stavy, kontejner "dynamický stav" a image (pevný stav). Než z obrazu vytvoříme kontejner, je třeba provést několik nastavení. Poklepu na svůj obraz mysql.
{{< gallery match="images/3/*.png" >}}
Pak kliknu na "Rozšířená nastavení" a aktivuji "Automatický restart". Vyberu kartu "Svazek" a kliknu na "Přidat složku". Tam vytvořím novou složku databáze s touto přípojnou cestou "/var/lib/mysql".
{{< gallery match="images/4/*.png" >}}
V části "Nastavení portů" se odstraní všechny porty. To znamená, že vyberu port "3306" a odstraním jej pomocí tlačítka "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Název proměnné|Hodnota|Co to je?|
|--- | --- |---|
|TZ	| Europe/Berlin |Časové pásmo|
|MYSQL_ROOT_PASSWORD	| my_wiki_pass |Hlavní heslo databáze.|
|MYSQL_DATABASE |	my_wiki |Jedná se o název databáze.|
|MYSQL_USER	| wikiuser |Uživatelské jméno databáze wiki.|
|MYSQL_PASSWORD |	my_wiki_pass	|Heslo uživatele databáze wiki.|
{{</table>}}
Nakonec zadám tyto čtyři proměnné prostředí:Viz:
{{< gallery match="images/6/*.png" >}}
Po těchto nastaveních lze server Mariadb spustit! Všude stisknu tlačítko "Použít".
## Krok 3: Instalace Wiki.js
V okně Synology Docker kliknu na kartu "Registrace" a vyhledám položku "wiki". Vyberu obraz Docker "requarks/wiki" a kliknu na značku "latest".
{{< gallery match="images/7/*.png" >}}
Dvakrát kliknu na obrázek WikiJS. Pak kliknu na "Rozšířené nastavení" a aktivuji zde také "Automatický restart".
{{< gallery match="images/8/*.png" >}}
Kontejneru "WikiJS" přiřadím pevné porty. Bez pevných portů by se mohlo stát, že "bookstack server" po restartu poběží na jiném portu.
{{< gallery match="images/9/*.png" >}}
Kromě toho je třeba ještě vytvořit "odkaz" na kontejner "mysql". Kliknu na kartu Odkazy a vyberu kontejner databáze. Název aliasu by měl být zapamatován pro instalaci wiki.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Název proměnné|Hodnota|Co to je?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Časové pásmo|
|DB_HOST	| wiki-db	|Názvy aliasů / odkaz na kontejner|
|DB_TYPE	| mysql	||
|DB_PORT	| 3306	 ||
|DB_PASSWORD	| my_wiki	|Údaje z kroku 2|
|DB_USER	| wikiuser |Údaje z kroku 2|
|DB_PASS	| my_wiki_pass	|Údaje z kroku 2|
{{</table>}}
Nakonec zadám tyto proměnné prostředí:Viz:
{{< gallery match="images/11/*.png" >}}
Nyní lze kontejner spustit. Volám server Wiki.js s IP adresou Synology a portem kontejneru/3000.
{{< gallery match="images/12/*.png" >}}