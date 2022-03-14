+++
date = "2021-03-07"
title = "Velike stvari s posodami: upravljanje in arhiviranje receptov na strežniku Synology DiskStation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "rezepte", "speisen", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-docker-mealie/index.sl.md"
+++
Vse svoje najljubše recepte zberete v vsebniku Docker in jih uredite po svojih željah. Napišite svoje recepte ali uvozite recepte s spletnih strani, na primer "Chefkoch", "Essen
{{< gallery match="images/1/*.png" >}}

## Možnost za strokovnjake
Kot izkušen uporabnik Synologyja se lahko seveda prijavite s SSH in namestite celotno namestitev prek datoteke Docker Compose.
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

## Korak 1: Iskanje slike Docker
V oknu Synology Docker kliknem na zavihek "Registracija" in poiščem "mealie". Izberem sliko Docker "hkotel/mealie:latest" in nato kliknem na oznako "latest".
{{< gallery match="images/2/*.png" >}}
Po prenosu slike je slika na voljo kot slika. Docker razlikuje med dvema stanjema, zabojnikom (dinamično stanje) in sliko/sliko (fiksno stanje). Preden lahko iz slike ustvarimo vsebnik, je treba opraviti nekaj nastavitev.
## Korak 2: Sliko uporabite v praksi:
Dvakrat kliknem na svojo sliko "mealie".
{{< gallery match="images/3/*.png" >}}
Nato kliknem na "Napredne nastavitve" in aktiviram možnost "Samodejni ponovni zagon". Izberem zavihek "Zvezek" in kliknem na "Dodaj mapo". Tam ustvarim novo mapo s to potjo "/app/data".
{{< gallery match="images/4/*.png" >}}
Zabojniku "Mealie" dodelim fiksna vrata. Brez fiksnih vrat se lahko zgodi, da strežnik Mealie po ponovnem zagonu deluje na drugih vratih.
{{< gallery match="images/5/*.png" >}}
Na koncu vnesem dve okoljski spremenljivki. Spremenljivka "db_type" je vrsta podatkovne zbirke, spremenljivka "TZ" pa je časovni pas "Europe/Berlin".
{{< gallery match="images/6/*.png" >}}
Po teh nastavitvah lahko zaženete strežnik Mealie! Nato lahko Mealie pokličete prek naslova Ip dislokacije Synology in dodeljenih vrat, na primer http://192.168.21.23:8096 .
{{< gallery match="images/7/*.png" >}}

## Kako deluje Mealie?
Če premaknem miško nad gumb "Plus" na desni/spodaj in nato kliknem na simbol "Veriga", lahko vnesem naslov url. Aplikacija Mealie nato samodejno poišče zahtevane metainformacije in informacije o shemi.
{{< gallery match="images/8/*.png" >}}
Uvoz deluje odlično (te funkcije sem uporabil z naslovi iz programov Chef, Food
{{< gallery match="images/9/*.png" >}}
V načinu urejanja lahko dodam tudi kategorijo. Pomembno je, da po vsaki kategoriji enkrat pritisnemo tipko Enter. V nasprotnem primeru se ta nastavitev ne uporabi.
{{< gallery match="images/10/*.png" >}}

## Posebne funkcije
Opazil sem, da se kategorije menija ne posodabljajo samodejno. Tu morate pomagati s ponovnim nalaganjem brskalnika.
{{< gallery match="images/11/*.png" >}}

## Druge funkcije
Seveda lahko iščete recepte in ustvarjate jedilnike. Poleg tega lahko aplikacijo Mealie zelo obsežno prilagodite.
{{< gallery match="images/12/*.png" >}}
Mealie je odlično videti tudi na mobilnih napravah:
{{< gallery match="images/13/*.*" >}}

## Rest-Api
Dokumentacijo API najdete na naslovu "http://gewaehlte-ip:und-port ... /docs". Tu boste našli številne metode, ki jih lahko uporabite za avtomatizacijo.
{{< gallery match="images/14/*.png" >}}

## Primer vmesnika Api
Predstavljajte si naslednjo izmišljotino: "Gruner und Jahr začenja spletni portal Essen
{{< terminal >}}
wget --spider --force-html -r -l12  "https://www.essen-und-trinken.de/rezepte/archiv/"  2>&1 | grep '/rezepte/' | grep '^--' | awk '{ print $3 }' > liste.txt

{{</ terminal >}}
Nato ta seznam očistite in ga sprožite proti api rest, primer:
```
#!/bin/bash
sort -u liste.txt > clear.txt

while read p; do
  echo "import url: $p"
  curl -d "{\"url\":\"$p\"}" -H "Content-Type: application/json" http://synology-ip:8096/api/recipes/create-url
  sleep 1
done < clear.txt

```
Zdaj lahko do receptov dostopate tudi brez povezave:
{{< gallery match="images/15/*.png" >}}
