+++
date = "2021-04-18"
title = "Veľké veci s kontajnermi: Inštalácia vlastnej dokuWiki na diskovej stanici Synology"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dokuwiki", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-dokuWiki/index.sk.md"
+++
DokuWiki je softvér wiki s otvoreným zdrojovým kódom, ktorý je v súlade so štandardmi, ľahko sa používa a zároveň je mimoriadne všestranný. Dnes ukážem, ako nainštalovať službu DokuWiki na diskovú stanicu Synology.
## Možnosť pre profesionálov
Ako skúsený používateľ Synology sa môžete samozrejme prihlásiť pomocou SSH a nainštalovať celú inštaláciu prostredníctvom súboru Docker Compose.
```
version: '3'
services:
  dokuwiki:
    image:  bitnami/dokuwiki:latest
    restart: always
    ports:
      - 8080:8080
      - 8443:8443
    environment:
      TZ: 'Europe/Berlin'
      DOKUWIKI_USERNAME: 'admin'
      DOKUWIKI_FULL_NAME: 'wiki'
      DOKUWIKI_PASSWORD: 'password'
    volumes:
      - ./data:/bitnami/dokuwiki

```
Ďalšie užitočné obrazy Docker na domáce použitie nájdete v [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").
## Krok 1: Príprava priečinka wiki
V adresári Docker vytvorím nový adresár s názvom "wiki".
{{< gallery match="images/1/*.png" >}}

## Krok 2: Inštalácia DokuWiki
Potom je potrebné vytvoriť databázu. V okne Synology Docker kliknem na kartu "Registrácia" a vyhľadám položku "dokuwiki". Vyberiem obraz Docker "bitnami/dokuwiki" a potom kliknem na značku "latest".
{{< gallery match="images/2/*.png" >}}
Po stiahnutí obrázka je obrázok k dispozícii ako obrázok. Docker rozlišuje 2 stavy, kontajner "dynamický stav" a obraz (pevný stav). Pred vytvorením kontajnera z obrazu je potrebné vykonať niekoľko nastavení. Dvakrát kliknem na svoj obraz dokuwiki.
{{< gallery match="images/3/*.png" >}}
Pre kontajner "dokuwiki" priraďujem pevné porty. Bez pevných portov by sa mohlo stať, že "dokuwiki server" po reštarte beží na inom porte.
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Názov premennej|Hodnota|Čo to je?|
|--- | --- |---|
|TZ	| Europe/Berlin	|Časové pásmo|
|DOKUWIKI_USERNAME	| admin|Používateľské meno administrátora|
|DOKUWIKI_FULL_NAME |	wiki	|Názov WIki|
|DOKUWIKI_PASSWORD	| password	|Heslo správcu|
{{</table>}}
Nakoniec zadám tieto premenné prostredia:Pozri:
{{< gallery match="images/5/*.png" >}}
Kontajner je teraz možné spustiť. Zavolám server dokuWIki s IP adresou Synology a mojím kontajnerovým portom.
{{< gallery match="images/6/*.png" >}}

