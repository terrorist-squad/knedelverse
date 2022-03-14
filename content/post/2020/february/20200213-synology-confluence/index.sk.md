+++
date = "2020-02-13"
title = "Synology-Nas: Confluence ako wiki systém"
difficulty = "level-4"
tags = ["atlassian", "confluence", "Docker", "ds918", "Synology", "wiki", "nas"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200213-synology-confluence/index.sk.md"
+++
Ak chcete nainštalovať Atlassian Confluence na Synology NAS, ste na správnom mieste.
## Krok 1
Najprv otvorím aplikáciu Docker v rozhraní Synology a potom prejdem na podpoložku "Registrácia". Tam vyhľadám "Confluence" a kliknem na prvý obrázok "Atlassian Confluence".
{{< gallery match="images/1/*.png" >}}

## Krok 2
Po stiahnutí obrázka je obrázok k dispozícii ako obrázok. Docker rozlišuje 2 stavy, kontajner "dynamický stav" a obraz/image (pevný stav). Pred vytvorením kontajnera z obrazu je potrebné vykonať niekoľko nastavení.
## Automatický reštart
Dvakrát kliknem na svoj obraz Confluence.
{{< gallery match="images/2/*.png" >}}
Potom kliknem na "Rozšírené nastavenia" a aktivujem "Automatický reštart".
{{< gallery match="images/3/*.png" >}}

## Porty
Kontajneru Confluence priraďujem pevné porty. Bez pevných portov môže Confluence po reštarte bežať na inom porte.
{{< gallery match="images/4/*.png" >}}

## Pamäť
Vytvorím fyzický priečinok a pripojím ho do kontajnera (/var/atlassian/application-data/confluence/). Toto nastavenie uľahčuje zálohovanie a obnovu údajov.
{{< gallery match="images/5/*.png" >}}
Po týchto nastaveniach je možné Confluence spustiť!
{{< gallery match="images/6/*.png" >}}