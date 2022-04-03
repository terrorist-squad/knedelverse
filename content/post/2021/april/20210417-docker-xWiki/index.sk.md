+++
date = "2021-04-17"
title = "Veľké veci s kontajnermi: Spustenie vlastnej xWiki na diskovej stanici Synology"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "xwiki", "wiki",]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210417-docker-xWiki/index.sk.md"
+++
XWiki je slobodná softvérová platforma wiki napísaná v jazyku Java a navrhnutá s ohľadom na rozšíriteľnosť. Dnes vám ukážem, ako nainštalovať službu xWiki do zariadenia Synology DiskStation.
## Možnosť pre profesionálov
Ako skúsený používateľ Synology sa môžete samozrejme prihlásiť pomocou SSH a nainštalovať celú inštaláciu prostredníctvom súboru Docker Compose.
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
Ďalšie užitočné obrazy Docker na domáce použitie nájdete v [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Krok 1: Príprava priečinka wiki
V adresári Docker vytvorím nový adresár s názvom "wiki".
{{< gallery match="images/1/*.png" >}}

## Krok 2: Inštalácia databázy
Potom je potrebné vytvoriť databázu. V okne Synology Docker kliknem na kartu "Registrácia" a vyhľadám položku "postgres". Vyberiem obraz Docker "postgres" a potom kliknem na značku "latest".
{{< gallery match="images/2/*.png" >}}
Po stiahnutí obrázka je obrázok k dispozícii ako obrázok. Docker rozlišuje 2 stavy, kontajner "dynamický stav" a obraz (pevný stav). Pred vytvorením kontajnera z obrazu je potrebné vykonať niekoľko nastavení. Dvakrát kliknem na svoj obraz postgres.
{{< gallery match="images/3/*.png" >}}
Potom kliknem na "Rozšírené nastavenia" a aktivujem "Automatický reštart". Vyberiem kartu "Volume" a kliknem na "Add folder". Tam vytvorím nový priečinok databázy s touto prípojnou cestou "/var/lib/postgresql/data".
{{< gallery match="images/4/*.png" >}}
V časti "Nastavenia portov" sa odstránia všetky porty. To znamená, že vyberiem port "5432" a odstránim ho pomocou tlačidla "-".
{{< gallery match="images/5/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Názov premennej|Hodnota|Čo to je?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Časové pásmo|
|POSTGRES_DB	| xwiki |Toto je názov databázy.|
|POSTGRES_USER	| xwiki |Meno používateľa databázy wiki.|
|POSTGRES_PASSWORD	| xwiki |Heslo používateľa databázy wiki.|
{{</table>}}
Nakoniec zadám tieto štyri premenné prostredia:Pozri:
{{< gallery match="images/6/*.png" >}}
Po týchto nastaveniach je možné spustiť server Mariadb! Všade stlačím tlačidlo "Použiť".
## Krok 3: Inštalácia xWiki
V okne Synology Docker kliknem na kartu "Registrácia" a vyhľadám položku "xwiki". Vyberiem obraz Docker "xwiki" a potom kliknem na značku "10-postgres-tomcat".
{{< gallery match="images/7/*.png" >}}
Dvakrát kliknem na svoj obrázok xwiki. Potom kliknem na "Rozšírené nastavenia" a aktivujem tu aj "Automatický reštart".
{{< gallery match="images/8/*.png" >}}
Pre kontajner "xwiki" priraďujem pevné porty. Bez pevných portov by sa mohlo stať, že "server xwiki" po reštarte beží na inom porte.
{{< gallery match="images/9/*.png" >}}
Okrem toho je potrebné vytvoriť "odkaz" na kontajner "postgres". Kliknem na kartu Odkazy a vyberiem kontajner databázy. Názov aliasu by sa mal zapamätať pre inštaláciu wiki.
{{< gallery match="images/10/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Názov premennej|Hodnota|Čo to je?|
|--- | --- |---|
|TZ |	Europe/Berlin	|Časové pásmo|
|DB_HOST	| db |Názvy aliasov / prepojenie kontajnera|
|DB_DATABASE	| xwiki	|Údaje z kroku 2|
|DB_USER	| xwiki	|Údaje z kroku 2|
|DB_PASSWORD	| xwiki |Údaje z kroku 2|
{{</table>}}
Nakoniec zadám tieto premenné prostredia:Pozri:
{{< gallery match="images/11/*.png" >}}
Kontajner je teraz možné spustiť. Zavolám server xWiki s IP adresou Synology a svojím kontajnerovým portom.
{{< gallery match="images/12/*.png" >}}
