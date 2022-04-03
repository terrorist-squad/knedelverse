+++
date = "2021-03-07"
title = "Veľké veci s kontajnermi: správa a archivácia receptov na zariadení Synology DiskStation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "rezepte", "speisen", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-docker-mealie/index.sk.md"
+++
Zhromaždite všetky svoje obľúbené recepty v kontajneri Docker a usporiadajte ich podľa svojich predstáv. Napíšte si vlastné recepty alebo importujte recepty z webových stránok, napríklad "Chefkoch", "Essen
{{< gallery match="images/1/*.png" >}}

## Možnosť pre profesionálov
Ako skúsený používateľ Synology sa môžete samozrejme prihlásiť pomocou SSH a nainštalovať celú inštaláciu prostredníctvom súboru Docker Compose.
```
version: "2.0"
services:
  mealie:
    container_name: mealie
    image: hkotel/mealie:latest
    restart: always
    ports:
      - 9000:80
    environment:
      db_type: sqlite
      TZ: Europa/Berlin
    volumes:
      - ./mealie/data/:/app/data

```

## Krok 1: Vyhľadanie obrazu aplikácie Docker
V okne Synology Docker kliknem na kartu "Registrácia" a vyhľadám položku "mealie". Vyberiem obraz Docker "hkotel/mealie:latest" a potom kliknem na značku "latest".
{{< gallery match="images/2/*.png" >}}
Po stiahnutí obrázka je obrázok k dispozícii ako obrázok. Docker rozlišuje 2 stavy, kontajner "dynamický stav" a obraz/image (pevný stav). Pred vytvorením kontajnera z obrazu je potrebné vykonať niekoľko nastavení.
## Krok 2: Uvedenie obrazu do prevádzky:
Dvakrát kliknem na svoj obrázok "mealie".
{{< gallery match="images/3/*.png" >}}
Potom kliknem na "Rozšírené nastavenia" a aktivujem "Automatický reštart". Vyberiem kartu "Zväzok" a kliknem na "Pridať priečinok". Tam vytvorím nový priečinok s touto prípojnou cestou "/app/data".
{{< gallery match="images/4/*.png" >}}
Pre kontajner "Mealie" priraďujem pevné porty. Bez pevných portov by sa mohlo stať, že "server Mealie" po reštarte beží na inom porte.
{{< gallery match="images/5/*.png" >}}
Nakoniec zadám dve premenné prostredia. Premenná "db_type" je typ databázy a "TZ" je časové pásmo "Europe/Berlin".
{{< gallery match="images/6/*.png" >}}
Po týchto nastaveniach je možné spustiť server Mealie! Potom môžete zavolať Mealie prostredníctvom Ip adresy zariadenia Synology a priradeného portu, napríklad http://192.168.21.23:8096 .
{{< gallery match="images/7/*.png" >}}

## Ako Mealie funguje?
Ak prejdem myšou na tlačidlo "Plus" vpravo/dole a potom kliknem na symbol "Reťazec", môžem zadať url adresu. Aplikácia Mealie potom automaticky vyhľadá požadované metainformácie a informácie o schéme.
{{< gallery match="images/8/*.png" >}}
Import funguje skvele (použil som tieto funkcie s adresami z aplikácie Chef, Food
{{< gallery match="images/9/*.png" >}}
V režime úprav môžem tiež pridať kategóriu. Je dôležité, aby som po každej kategórii raz stlačil kláves Enter. V opačnom prípade sa toto nastavenie nepoužije.
{{< gallery match="images/10/*.png" >}}

## Špeciálne funkcie
Všimol som si, že kategórie ponuky sa neaktualizujú automaticky. Musíte tu pomôcť s opätovným načítaním prehliadača.
{{< gallery match="images/11/*.png" >}}

## Ďalšie funkcie
Samozrejme, môžete vyhľadávať recepty a tiež vytvárať jedálne lístky. Okrem toho môžete aplikáciu Mealie veľmi podrobne prispôsobiť.
{{< gallery match="images/12/*.png" >}}
Mealie vyzerá skvele aj na mobilných zariadeniach:
{{< gallery match="images/13/*.*" >}}

## Rest-Api
Dokumentáciu API nájdete na adrese "http://gewaehlte-ip:und-port ... /docs". Nájdete tu mnoho metód, ktoré možno použiť na automatizáciu.
{{< gallery match="images/14/*.png" >}}

## Príklad rozhrania Api
Predstavte si nasledujúcu fikciu: "Gruner und Jahr spúšťa internetový portál Essen
{{< terminal >}}
wget --spider --force-html -r -l12  "https://www.essen-und-trinken.de/rezepte/archiv/"  2>&1 | grep '/rezepte/' | grep '^--' | awk '{ print $3 }' > liste.txt

{{</ terminal >}}
Potom tento zoznam vyčistite a vypáľte ho proti ostatným api, napr:
```
#!/bin/bash
sort -u liste.txt > clear.txt

while read p; do
  echo "import url: $p"
  curl -d "{\"url\":\"$p\"}" -H "Content-Type: application/json" http://synology-ip:8096/api/recipes/create-url
  sleep 1
done < clear.txt

```
Teraz môžete k receptom pristupovať aj offline:
{{< gallery match="images/15/*.png" >}}
Záver: Ak venujete Mealie trochu času, môžete si vytvoriť skvelú databázu receptov! Mealie je neustále vyvíjaný ako open source projekt a nájdete ho na tejto adrese: https://github.com/hay-kot/mealie/
