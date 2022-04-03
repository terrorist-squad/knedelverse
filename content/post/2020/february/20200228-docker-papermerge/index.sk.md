+++
date = "2020-02-28"
title = "Veľké veci s kontajnermi: Spustenie Papermerge DMS na Synology NAS"
difficulty = "level-3"
tags = ["archiv", "automatisch", "dms", "Docker", "Document-Managment-System", "google", "ocr", "papermerge", "Synology", "tesseract", "texterkennung"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200228-docker-papermerge/index.sk.md"
+++
Papermerge je mladý systém správy dokumentov (DMS), ktorý dokáže automaticky prideľovať a spracovávať dokumenty. V tomto návode ukážem, ako som nainštaloval Papermerge na svoju diskovú stanicu Synology a ako funguje DMS.
## Možnosť pre profesionálov
Ako skúsený používateľ Synology sa môžete samozrejme prihlásiť pomocou SSH a nainštalovať celú inštaláciu prostredníctvom súboru Docker Compose.
```
version: "2.1"
services:
  papermerge:
    image: ghcr.io/linuxserver/papermerge
    container_name: papermerge
    environment:
      - PUID=1024
      - PGID=100
      - TZ=Europe/Berlin
    volumes:
      - ./config>:/config
      - ./appdata/data>:/data
    ports:
      - 8090:8000
    restart: unless-stopped

```

## Krok 1: Vytvorenie priečinka
Najskôr vytvorím priečinok na zlúčenie dokumentov. Prejdem do "Ovládanie systému" -> "Zdieľaný priečinok" a vytvorím nový priečinok s názvom "Archív dokumentov".
{{< gallery match="images/1/*.png" >}}
Krok 2: Vyhľadanie obrazu DockerKlikneme na kartu "Registrácia" v okne Synology Docker a vyhľadáme "Papermerge". Vyberiem obraz Docker "linuxserver/papermerge" a potom kliknem na značku "latest".
{{< gallery match="images/2/*.png" >}}
Po stiahnutí obrázka je obrázok k dispozícii ako obrázok. Docker rozlišuje 2 stavy, kontajner "dynamický stav" a obraz/image (pevný stav). Pred vytvorením kontajnera z obrazu je potrebné vykonať niekoľko nastavení.
## Krok 3: Uvedenie obrazu do prevádzky:
Dvakrát kliknem na svoj obrázok na zlúčenie papiera.
{{< gallery match="images/3/*.png" >}}
Potom kliknem na "Rozšírené nastavenia" a aktivujem "Automatický reštart". Vyberiem kartu "Volume" a kliknem na "Add folder". Tam vytvorím nový priečinok databázy s touto prípojnou cestou "/data".
{{< gallery match="images/4/*.png" >}}
Ukladám sem aj druhý priečinok, ktorý obsahuje prípojnú cestu "/config". Nezáleží na tom, kde sa tento priečinok nachádza. Je však dôležité, aby patril používateľovi Synology admin.
{{< gallery match="images/5/*.png" >}}
Pre kontajner "Papermerge" priraďujem pevné porty. Bez pevných portov by sa mohlo stať, že "Papermerge server" po reštarte beží na inom porte.
{{< gallery match="images/6/*.png" >}}
Nakoniec zadám tri premenné prostredia. Premenná "PUID" je ID používateľa a "PGID" je ID skupiny môjho používateľa administrátora. PGID/PUID môžete zistiť cez SSH pomocou príkazu "cat /etc/passwd | grep admin".
{{< gallery match="images/7/*.png" >}}
Po týchto nastaveniach je možné spustiť server Papermerge! Potom môžete aplikáciu Papermerge zavolať prostredníctvom Ip adresy zariadenia Synology a priradeného portu, napríklad http://192.168.21.23:8095.
{{< gallery match="images/8/*.png" >}}
Predvolené prihlasovacie meno je admin s heslom admin.
## Ako Papermerge funguje?
Papermerge analyzuje text dokumentov a obrázkov. Papermerge používa knižnicu OCR/"optického rozpoznávania znakov" s názvom tesseract, ktorú vydala spoločnosť Goolge.
{{< gallery match="images/9/*.png" >}}
Vytvoril som priečinok s názvom "Všetko s Lorem", aby som otestoval automatické priraďovanie dokumentov. Potom som klikol na nový rozpoznávací vzor v položke ponuky "Automaty".
{{< gallery match="images/10/*.png" >}}
Všetky nové dokumenty obsahujúce slovo "Lorem" sú umiestnené v priečinku "Všetko s Lorem" a označené "has-lorem". Je dôležité používať v tagoch čiarku, inak sa tag nenastaví. Ak nahráte dokument, bude označený a zoradený.
{{< gallery match="images/11/*.png" >}}
