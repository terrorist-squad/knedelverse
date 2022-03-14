+++
date = "2021-04-25T09:28:11+01:00"
title = "BitwardenRS na strežniku Synology DiskStation"
difficulty = "level-2"
tags = ["bitwardenrs", "Docker", "docker-compose", "password-manager", "passwort", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-BitwardenRS/index.sl.md"
+++
Bitwarden je brezplačna odprtokodna storitev za upravljanje gesel, ki zaupne podatke, kot so poverilnice za spletna mesta, shranjuje v šifriranem trezorju. Danes bom pokazal, kako namestiti BitwardenRS na strežnik Synology DiskStation.
## Korak 1: Pripravite mapo BitwardenRS
V imeniku programa Docker ustvarim nov imenik z imenom "bitwarden".
{{< gallery match="images/1/*.png" >}}

## Korak 2: Namestite BitwardenRS
V oknu Synology Docker kliknem na zavihek "Registracija" in poiščem "bitwarden". Izberem sliko Docker "bitwardenrs/server" in nato kliknem na oznako "latest".
{{< gallery match="images/2/*.png" >}}
Dvakrat kliknem na svojo sliko bitwardenrs. Nato kliknem na "Napredne nastavitve" in aktiviram možnost "Samodejni ponovni zagon".
{{< gallery match="images/3/*.png" >}}
Izberem zavihek "Zvezek" in kliknem na "Dodaj mapo". Tam ustvarim novo mapo s to potjo "/data".
{{< gallery match="images/4/*.png" >}}
Za zabojnik "bitwardenrs" dodelim fiksna vrata. Brez fiksnih vrat se lahko zgodi, da strežnik "bitwardenrs" po ponovnem zagonu teče na drugih vratih. Prvo pristanišče za zabojnik lahko izbrišete. Ne pozabite na drugo pristanišče.
{{< gallery match="images/5/*.png" >}}
Posodo lahko zaženete. Strežnik bitwardenrs pokličem z naslovom IP Synology in pristaniščem 8084.
{{< gallery match="images/6/*.png" >}}

## Korak 3: Nastavitev HTTPS
Kliknem na "Nadzorna plošča" > "Reverzni posrednik" in "Ustvari".
{{< gallery match="images/7/*.png" >}}
Nato lahko šifrirano pokličem strežnik bitwardenrs z naslovom IP strežnika Synology in mojimi posredniškimi vrati 8085.
{{< gallery match="images/8/*.png" >}}