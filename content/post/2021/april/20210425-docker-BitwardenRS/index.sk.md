+++
date = "2021-04-25T09:28:11+01:00"
title = "BitwardenRS na zariadení Synology DiskStation"
difficulty = "level-2"
tags = ["bitwardenrs", "Docker", "docker-compose", "password-manager", "passwort", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210425-docker-BitwardenRS/index.sk.md"
+++
Bitwarden je bezplatná služba s otvoreným zdrojovým kódom na správu hesiel, ktorá ukladá dôverné informácie, napríklad poverenia na webové stránky, do zašifrovaného trezoru. Dnes vám ukážem, ako nainštalovať BitwardenRS do zariadenia Synology DiskStation.
## Krok 1: Pripravte priečinok BitwardenRS
V adresári Docker vytvorím nový adresár s názvom "bitwarden".
{{< gallery match="images/1/*.png" >}}

## Krok 2: Inštalácia BitwardenRS
V okne Synology Docker kliknem na kartu "Registrácia" a vyhľadám položku "bitwarden". Vyberiem obraz Docker "bitwardenrs/server" a potom kliknem na značku "latest".
{{< gallery match="images/2/*.png" >}}
Dvakrát kliknem na svoj obrázok bitwardenrs. Potom kliknem na "Rozšírené nastavenia" a aktivujem tu aj "Automatický reštart".
{{< gallery match="images/3/*.png" >}}
Vyberiem kartu "Zväzok" a kliknem na "Pridať priečinok". Tam vytvorím nový priečinok s touto prípojnou cestou "/data".
{{< gallery match="images/4/*.png" >}}
Pre kontajner "bitwardenrs" priraďujem pevné porty. Bez pevných portov by sa mohlo stať, že "bitwardenrs server" po reštarte beží na inom porte. Prvý kontajnerový port je možné vymazať. Treba pamätať aj na druhý port.
{{< gallery match="images/5/*.png" >}}
Kontajner je teraz možné spustiť. Volám server bitwardenrs s IP adresou Synology a mojím kontajnerovým portom 8084.
{{< gallery match="images/6/*.png" >}}

## Krok 3: Nastavenie protokolu HTTPS
Kliknem na "Ovládací panel" > "Reverzná proxy" a "Vytvoriť".
{{< gallery match="images/7/*.png" >}}
Potom môžem zavolať server bitwardenrs s IP adresou Synology a mojím proxy portom 8085, šifrovaným.
{{< gallery match="images/8/*.png" >}}
