+++
date = "2021-05-30"
title = "Udemy Downloader na stanici Synology DiskStation"
difficulty = "level-2"
tags = ["udemy", "download", "synology", "diskstation", "udemydl"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-udemydl/index.cs.md"
+++
V tomto návodu se dozvíte, jak stáhnout kurzy "udemy" pro offline použití.
## Krok 1: Připravte si složku Udemy
V adresáři Docker vytvořím nový adresář s názvem "udemy".
{{< gallery match="images/1/*.png" >}}

## Krok 2: Instalace obrazu Ubuntu
V okně Synology Docker kliknu na kartu "Registrace" a vyhledám "ubunutu". Vyberu obraz Docker "ubunutu" a kliknu na značku "latest".
{{< gallery match="images/2/*.png" >}}
Dvakrát kliknu na obraz Ubuntu. Pak kliknu na "Rozšířené nastavení" a aktivuji zde také "Automatický restart".
{{< gallery match="images/3/*.png" >}}
Vyberu kartu "Svazek" a kliknu na "Přidat složku". Tam vytvořím novou složku s touto přípojnou cestou "/download".
{{< gallery match="images/4/*.png" >}}
Nyní lze kontejner spustit
{{< gallery match="images/5/*.png" >}}

## Krok 4: Nainstalujte Udemy Downloader
V okně Synology Docker kliknu na "Container" a dvakrát kliknu na svůj "Udemy container". Pak kliknu na kartu Terminál a zadám následující příkazy.
{{< gallery match="images/6/*.png" >}}

##  Příkazy:

{{< terminal >}}
apt-get update
apt-get install python3 python3-pip wget unzip
cd /download
wget https://github.com/r0oth3x49/udemy-dl/archive/refs/heads/master.zip
unzip master.zip
cd udemy-dl-master
pip3 pip install -r requirements.txt

{{</ terminal >}}
Snímky obrazovky:
{{< gallery match="images/7/*.png" >}}

## Krok 4: Zprovoznění nástroje Udemy downloader
Nyní potřebuji "přístupový token". Navštívím Udemy v prohlížeči Firefox a otevřu Firebug. Kliknu na kartu "Webové úložiště" a zkopíruji "Přístupový token".
{{< gallery match="images/8/*.png" >}}
V kontejneru vytvořím nový soubor:
{{< terminal >}}
echo "access_token=859wjuhV7PMLsZu15GOWias9A0iFnRjkL9pJXOv2" > /download/cookie.txt

{{</ terminal >}}
Poté si mohu stáhnout již zakoupené kurzy:
{{< terminal >}}
cd /download
python3 udemy-dl-master/udemy-dl.py -k /download/cookie.txt https://www.udemy.com/course/ansible-grundlagen/learn/

{{</ terminal >}}
Viz:
{{< gallery match="images/9/*.png" >}}

