+++
date = "2021-04-17"
title = "Skvělé věci s kontejnery: Spuštění vlastní xWiki na diskové stanici Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "xwiki", "wiki",]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210417-docker-xWiki/index.cs.md"
+++
XWiki je svobodná softwarová platforma wiki napsaná v jazyce Java a navržená s ohledem na rozšiřitelnost. Dnes vám ukážu, jak nainstalovat službu xWiki na stanici Synology DiskStation.
## Možnost pro profesionály
Jako zkušený uživatel Synology se samozřejmě můžete přihlásit pomocí SSH a nainstalovat celou instalaci pomocí souboru Docker Compose.
```
version: '3'
services:
  xwiki:
    image: xwiki:10-postgres-tomcat
    restart: always
    ports:
      - 8080:8080
    links:
      - db
    environment:
      DB_HOST: db
      DB_DATABASE: xwiki
      DB_DATABASE: xwiki
      DB_PASSWORD: xwiki
      TZ: 'Europe/Berlin'

  db:
    image: postgres:latest
    restart: always
    volumes:
      - ./postgresql:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=xwiki
      - POSTGRES_PASSWORD=xwiki
      - POSTGRES_DB=xwiki
      - TZ='Europe/Berlin'

```
Další užitečné obrazy Docker pro domácí použití najdete v [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Krok 1: Příprava složky wiki
V adresáři Docker vytvořím nový adresář s názvem "wiki".
{{< gallery match="images/1/*.png" >}}

## Krok 2: Instalace databáze
Poté je třeba vytvořit databázi. V okně Synology Docker kliknu na kartu "Registrace" a vyhledám "postgres". Vyberu obraz Docker "postgres" a kliknu na značku "latest".
{{< gallery match="images/2/*.png" >}}
Po stažení obrázku je obrázek k dispozici jako obrázek. Docker rozlišuje 2 stavy, kontejner "dynamický stav" a image (pevný stav). Než z obrazu vytvoříme kontejner, je třeba provést několik nastavení. Poklepu na svůj obraz postgres.
{{< gallery match="images/3/*.png" >}}
Pak kliknu na "Rozšířené nastavení" a aktivuji "Automatický restart". Vyberu kartu "Svazek" a kliknu na "Přidat složku". Tam vytvořím novou složku databáze s touto přípojnou cestou "/var/lib/postgresql/data".
{{< gallery match="images/4/*.png" >}}
V části "Nastavení portů" se odstraní všechny porty. To znamená, že vyberu port "5432" a odstraním jej pomocí tlačítka "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Název proměnné|Hodnota|Co to je?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Časové pásmo|
|POSTGRES_DB	| xwiki |Jedná se o název databáze.|
|POSTGRES_USER	| xwiki |Uživatelské jméno databáze wiki.|
|POSTGRES_PASSWORD	| xwiki |Heslo uživatele databáze wiki.|
{{</table>}}
Nakonec zadám tyto čtyři proměnné prostředí:Viz:
{{< gallery match="images/6/*.png" >}}
Po těchto nastaveních lze server Mariadb spustit! Všude stisknu tlačítko "Použít".
## Krok 3: Instalace xWiki
V okně Synology Docker kliknu na kartu "Registrace" a vyhledám "xwiki". Vyberu obraz Docker "xwiki" a kliknu na značku "10-postgres-tomcat".
{{< gallery match="images/7/*.png" >}}
Dvakrát kliknu na svůj obrázek xwiki. Pak kliknu na "Rozšířené nastavení" a aktivuji zde také "Automatický restart".
{{< gallery match="images/8/*.png" >}}
Pro kontejner "xwiki" přiřadím pevné porty. Bez pevných portů by se mohlo stát, že "server xwiki" po restartu poběží na jiném portu.
{{< gallery match="images/9/*.png" >}}
Kromě toho je třeba vytvořit "odkaz" na kontejner "postgres". Kliknu na kartu Odkazy a vyberu kontejner databáze. Název aliasu by měl být zapamatován pro instalaci wiki.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Název proměnné|Hodnota|Co to je?|
|--- | --- |---|
|TZ |	Europe/Berlin	|Časové pásmo|
|DB_HOST	| db |Názvy aliasů / odkaz na kontejner|
|DB_DATABASE	| xwiki	|Údaje z kroku 2|
|DB_USER	| xwiki	|Údaje z kroku 2|
|DB_PASSWORD	| xwiki |Údaje z kroku 2|
{{</table>}}
Nakonec zadám tyto proměnné prostředí:Viz:
{{< gallery match="images/11/*.png" >}}
Nyní lze kontejner spustit. Zavolám server xWiki s IP adresou Synology a portem kontejneru.
{{< gallery match="images/12/*.png" >}}
