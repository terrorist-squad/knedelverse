+++
date = "2020-02-13"
title = "Synology-Nas: Confluence jako systém wiki"
difficulty = "level-4"
tags = ["atlassian", "confluence", "Docker", "ds918", "Synology", "wiki", "nas"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2020/february/20200213-synology-confluence/index.cs.md"
+++
Pokud chcete nainstalovat Atlassian Confluence na zařízení Synology NAS, jste na správném místě.
## Krok 1
Nejprve otevřu aplikaci Docker v rozhraní Synology a poté přejdu na dílčí položku "Registrace". Tam vyhledám "Confluence" a kliknu na první obrázek "Atlassian Confluence".
{{< gallery match="images/1/*.png" >}}

## Krok 2
Po stažení obrázku je obrázek k dispozici jako obrázek. Docker rozlišuje 2 stavy, kontejner "dynamický stav" a obraz/image (pevný stav). Před vytvořením kontejneru z bitové kopie je třeba provést několik nastavení.
## Automatický restart
Dvakrát kliknu na svůj obraz Confluence.
{{< gallery match="images/2/*.png" >}}
Pak kliknu na "Rozšířené nastavení" a aktivuji "Automatický restart".
{{< gallery match="images/3/*.png" >}}

## Porty
Kontejneru Confluence přiřadím pevné porty. Bez pevných portů může Confluence po restartu běžet na jiném portu.
{{< gallery match="images/4/*.png" >}}

## Paměť
Vytvořím fyzickou složku a připojím ji do kontejneru (/var/atlassian/application-data/confluence/). Toto nastavení usnadňuje zálohování a obnovu dat.
{{< gallery match="images/5/*.png" >}}
Po těchto nastaveních lze Confluence spustit!
{{< gallery match="images/6/*.png" >}}