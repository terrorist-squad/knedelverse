+++
date = "2020-02-13"
title = "Synology-Nas: Inštalácia Calibre Web ako knižnice elektronických kníh"
difficulty = "level-1"
tags = ["calbre-web", "calibre", "Docker", "ds918", "ebook", "epub", "nas", "pdf", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200213-synology-calibreweb/index.sk.md"
+++
Ako môžem nainštalovať Calibre-Web ako kontajner Docker na Synology NAS? Pozor: Táto metóda inštalácie je zastaraná a nie je kompatibilná s aktuálnym softvérom Calibre. Pozrite si tento nový návod:[Veľké veci s kontajnermi: Spustenie aplikácie Calibre pomocou nástroja Docker Compose]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Veľké veci s kontajnermi: Spustenie aplikácie Calibre pomocou nástroja Docker Compose"). Tento návod je určený pre všetkých odborníkov na Synology DS.
## Krok 1: Vytvorenie priečinka
Najprv vytvorím priečinok pre knižnicu Calibre.  Vyvolám "Ovládanie systému" -> "Zdieľaný priečinok" a vytvorím nový priečinok "Knihy".
{{< gallery match="images/1/*.png" >}}

##  Krok 2: Vytvorenie knižnice Calibre
Teraz skopírujem existujúcu knižnicu alebo "[túto prázdnu vzorovú knižnicu](https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view)" do nového adresára. Sám som skopíroval existujúcu knižnicu desktopovej aplikácie.
{{< gallery match="images/2/*.png" >}}

## Krok 3: Vyhľadanie obrazu aplikácie Docker
V okne Synology Docker kliknem na kartu "Registrácia" a vyhľadám položku "Calibre". Vyberiem obraz Docker "janeczku/calibre-web" a potom kliknem na značku "latest".
{{< gallery match="images/3/*.png" >}}
Po stiahnutí obrázka je obrázok k dispozícii ako obrázok. Docker rozlišuje 2 stavy, kontajner "dynamický stav" a obraz/image (pevný stav). Pred vytvorením kontajnera z obrazu je potrebné vykonať niekoľko nastavení.
## Krok 4: Uvedenie obrazu do prevádzky:
Dvakrát kliknem na svoj obrázok Calibre.
{{< gallery match="images/4/*.png" >}}
Potom kliknem na "Rozšírené nastavenia" a aktivujem "Automatický reštart". Vyberiem kartu "Zväzok" a kliknem na "Pridať priečinok". Tam vytvorím nový priečinok databázy s touto prípojnou cestou "/calibre".
{{< gallery match="images/5/*.png" >}}
Kontajneru Calibre priraďujem pevné porty. Bez pevných portov sa môže stať, že Calibre po reštarte beží na inom porte.
{{< gallery match="images/6/*.png" >}}
Po týchto nastaveniach je možné spustiť Calibre!
{{< gallery match="images/7/*.png" >}}
Teraz vyvolám IP adresu Synology s priradeným portom Calibre a vidím nasledujúci obrázok. Ako "Umiestnenie databázy Calibre" zadám "/calibre". Ostatné nastavenia sú vecou vkusu.
{{< gallery match="images/8/*.png" >}}
Predvolené prihlasovacie meno je "admin" s heslom "admin123".
{{< gallery match="images/9/*.png" >}}
Hotovo! Samozrejme, teraz môžem pripojiť aj aplikáciu na ploche cez priečinok s knihami. Vymením knižnicu v aplikácii a potom vyberiem priečinok Nas.
{{< gallery match="images/10/*.png" >}}
Niečo také:
{{< gallery match="images/11/*.png" >}}
Ak teraz upravím metainformácie v aplikácii pre počítače, automaticky sa aktualizujú aj vo webovej aplikácii.
{{< gallery match="images/12/*.png" >}}