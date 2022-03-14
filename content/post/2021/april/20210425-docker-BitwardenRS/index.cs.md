+++
date = "2021-04-25T09:28:11+01:00"
title = "BitwardenRS na stanici Synology DiskStation"
difficulty = "level-2"
tags = ["bitwardenrs", "Docker", "docker-compose", "password-manager", "passwort", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210425-docker-BitwardenRS/index.cs.md"
+++
Bitwarden je bezplatná open-source služba pro správu hesel, která ukládá důvěrné informace, například přihlašovací údaje k webovým stránkám, do šifrovaného trezoru. Dnes vám ukážu, jak nainstalovat BitwardenRS na stanici Synology DiskStation.
## Krok 1: Příprava složky BitwardenRS
V adresáři Docker vytvořím nový adresář s názvem "bitwarden".
{{< gallery match="images/1/*.png" >}}

## Krok 2: Nainstalujte BitwardenRS
V okně Synology Docker kliknu na kartu "Registrace" a vyhledám položku "bitwarden". Vyberu obraz Docker "bitwardenrs/server" a kliknu na značku "latest".
{{< gallery match="images/2/*.png" >}}
Dvakrát kliknu na obrázek bitwardenrs. Pak kliknu na "Rozšířené nastavení" a aktivuji zde také "Automatický restart".
{{< gallery match="images/3/*.png" >}}
Vyberu kartu "Svazek" a kliknu na "Přidat složku". Tam vytvořím novou složku s touto přípojnou cestou "/data".
{{< gallery match="images/4/*.png" >}}
Pro kontejner "bitwardenrs" přiřadím pevné porty. Bez pevných portů by se mohlo stát, že "bitwardenrs server" po restartu poběží na jiném portu. První kontejnerový port lze odstranit. Je třeba pamatovat i na druhý přístav.
{{< gallery match="images/5/*.png" >}}
Nyní lze kontejner spustit. Volám server bitwardenrs s IP adresou Synology a portem kontejneru 8084.
{{< gallery match="images/6/*.png" >}}

## Krok 3: Nastavení protokolu HTTPS
Kliknu na "Ovládací panely" > "Reverzní proxy" a "Vytvořit".
{{< gallery match="images/7/*.png" >}}
Poté mohu volat server bitwardenrs s IP adresou Synology a mým proxy portem 8085, šifrovaně.
{{< gallery match="images/8/*.png" >}}