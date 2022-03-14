+++
date = "2021-04-16"
title = "Skvělé věci s kontejnery: Vlastní Bookstack Wiki na stanici Synology DiskStation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "bookstack", "wiki"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210416-docker-Bookstack/index.cs.md"
+++
Bookstack je "open source" alternativou k MediaWiki nebo Confluence. Dnes ukážu, jak nainstalovat službu Bookstack na diskovou stanici Synology.
## Možnost pro profesionály
Jako zkušený uživatel Synology se samozřejmě můžete přihlásit pomocí SSH a nainstalovat celou instalaci pomocí souboru Docker Compose.
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
Další užitečné obrazy Docker pro domácí použití najdete v [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Krok 1: Připravte si složku s knihami
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
|TZ	| Europe/Berlin |Časové pásmo|
|MYSQL_ROOT_PASSWORD	|  my_wiki_pass |Hlavní heslo databáze.|
|MYSQL_DATABASE | 	my_wiki	|Jedná se o název databáze.|
|MYSQL_USER	|  wikiuser	|Uživatelské jméno databáze wiki.|
|MYSQL_PASSWORD	|  my_wiki_pass	|Heslo uživatele databáze wiki.|
{{</table>}}
Nakonec zadám tyto proměnné prostředí:Viz:
{{< gallery match="images/6/*.png" >}}
Po těchto nastaveních lze server Mariadb spustit! Všude stisknu tlačítko "Použít".
## Krok 3: Nainstalujte Bookstack
V okně Synology Docker kliknu na kartu "Registrace" a vyhledám položku "bookstack". Vyberu obraz Docker "solidnerd/bookstack" a kliknu na značku "latest".
{{< gallery match="images/7/*.png" >}}
Dvakrát kliknu na svůj obrázek Bookstack. Pak kliknu na "Rozšířené nastavení" a aktivuji zde také "Automatický restart".
{{< gallery match="images/8/*.png" >}}
Pro kontejner "bookstack" přiřadím pevné porty. Bez pevných portů by se mohlo stát, že "bookstack server" po restartu poběží na jiném portu. První kontejnerový port lze odstranit. Je třeba pamatovat i na druhý přístav.
{{< gallery match="images/9/*.png" >}}
Kromě toho je třeba ještě vytvořit "odkaz" na kontejner "mariadb". Kliknu na kartu Odkazy a vyberu kontejner databáze. Název aliasu by měl být zapamatován pro instalaci wiki.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Název proměnné|Hodnota|Co to je?|
|--- | --- |---|
|TZ	| Europe/Berlin |Časové pásmo|
|DB_HOST	| wiki-db:3306	|Názvy aliasů / odkaz na kontejner|
|DB_DATABASE	| my_wiki |Údaje z kroku 2|
|DB_USERNAME	| wikiuser |Údaje z kroku 2|
|DB_PASSWORD	| my_wiki_pass	|Údaje z kroku 2|
{{</table>}}
Nakonec zadám tyto proměnné prostředí:Viz:
{{< gallery match="images/11/*.png" >}}
Nyní lze kontejner spustit. Vytvoření databáze může nějakou dobu trvat. Chování lze sledovat prostřednictvím podrobností o kontejneru.
{{< gallery match="images/12/*.png" >}}
Zavolám server Bookstack s IP adresou Synology a portem kontejneru. Přihlašovací jméno je "admin@admin.com" a heslo je "password".
{{< gallery match="images/13/*.png" >}}
