+++
date = "2021-03-07"
title = "Stora saker med behållare: hantera och arkivera recept på Synology DiskStation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "rezepte", "speisen", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-docker-mealie/index.sv.md"
+++
Samla alla dina favoritrecept i en Docker-behållare och ordna dem som du vill. Skriv egna recept eller importera recept från webbplatser, till exempel "Chefkoch", "Essen".
{{< gallery match="images/1/*.png" >}}

## Alternativ för yrkesverksamma
Som erfaren Synology-användare kan du naturligtvis logga in med SSH och installera hela installationen via Docker Compose-filen.
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

## Steg 1: Sök efter Docker-avbildningen
Jag klickar på fliken "Registration" i Synology Docker-fönstret och söker efter "mealie". Jag väljer Docker-avbildningen "hkotel/mealie:latest" och klickar sedan på taggen "latest".
{{< gallery match="images/2/*.png" >}}
När bilden har laddats ner finns den tillgänglig som en bild. Docker skiljer mellan två tillstånd: container (dynamiskt tillstånd) och image/image (fast tillstånd). Innan vi kan skapa en behållare från avbildningen måste några inställningar göras.
## Steg 2: Använd bilden:
Jag dubbelklickar på min "mealie"-bild.
{{< gallery match="images/3/*.png" >}}
Sedan klickar jag på "Avancerade inställningar" och aktiverar "Automatisk omstart". Jag väljer fliken "Volume" och klickar på "Add Folder". Där skapar jag en ny mapp med denna monteringssökväg "/app/data".
{{< gallery match="images/4/*.png" >}}
Jag tilldelar containern "Mealie" fasta portar. Utan fasta portar kan det vara så att "Mealie-servern" körs på en annan port efter en omstart.
{{< gallery match="images/5/*.png" >}}
Slutligen anger jag två miljövariabler. Variabeln "db_type" är databastypen och "TZ" är tidszonen "Europe/Berlin".
{{< gallery match="images/6/*.png" >}}
Efter dessa inställningar kan Mealie Server startas! Därefter kan du ringa Mealie via Ip-adressen till Synology-disctationen och den tilldelade porten, till exempel http://192.168.21.23:8096 .
{{< gallery match="images/7/*.png" >}}

## Hur fungerar Mealie?
Om jag för musen över "Plus"-knappen till höger/nerst och sedan klickar på "Chain"-symbolen kan jag ange en webbadress. Mealie-applikationen söker sedan automatiskt efter den nödvändiga meta- och schemainformationen.
{{< gallery match="images/8/*.png" >}}
Importen fungerar utmärkt (jag har använt dessa funktioner med webbadresser från Chef, Food
{{< gallery match="images/9/*.png" >}}
I redigeringsläget kan jag också lägga till en kategori. Det är viktigt att jag trycker på "Enter"-knappen en gång efter varje kategori. I annat fall tillämpas inte denna inställning.
{{< gallery match="images/10/*.png" >}}

## Specialfunktioner
Jag märkte att menykategorierna inte uppdateras automatiskt. Du måste hjälpa till med att ladda om webbläsaren.
{{< gallery match="images/11/*.png" >}}

## Andra funktioner
Naturligtvis kan du söka efter recept och skapa menyer. Dessutom kan du anpassa "Mealie" i stor utsträckning.
{{< gallery match="images/12/*.png" >}}
Mealie ser också bra ut i mobilen:
{{< gallery match="images/13/*.*" >}}

## Rest-Api
API-dokumentationen finns på "http://gewaehlte-ip:und-port ... /docs". Här hittar du många metoder som kan användas för automatisering.
{{< gallery match="images/14/*.png" >}}

## Exempel på api
Föreställ dig följande fiktion: "Gruner und Jahr lanserar internetportalen Essen".
{{< terminal >}}
wget --spider --force-html -r -l12  "https://www.essen-und-trinken.de/rezepte/archiv/"  2>&1 | grep '/rezepte/' | grep '^--' | awk '{ print $3 }' > liste.txt

{{</ terminal >}}
Rensa sedan upp listan och använd den mot rest api:n, till exempel:
```
#!/bin/bash
sort -u liste.txt > clear.txt

while read p; do
  echo "import url: $p"
  curl -d "{\"url\":\"$p\"}" -H "Content-Type: application/json" http://synology-ip:8096/api/recipes/create-url
  sleep 1
done < clear.txt

```
Nu kan du också få tillgång till recepten offline:
{{< gallery match="images/15/*.png" >}}
