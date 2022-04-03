+++
date = "2021-05-30"
title = "Udemy Downloader Synology DiskStationilla"
difficulty = "level-2"
tags = ["udemy", "download", "synology", "diskstation", "udemydl"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-udemydl/index.fi.md"
+++
Tässä ohjeessa opit lataamaan "udemy"-kursseja offline-käyttöä varten.
## Vaihe 1: Valmistele Udemy-kansio
Luon Docker-hakemistoon uuden hakemiston nimeltä "udemy".
{{< gallery match="images/1/*.png" >}}

## Vaihe 2: Asenna Ubuntu-kuva
Napsautan Synology Docker -ikkunan "Rekisteröinti"-välilehteä ja etsin "ubunutu". Valitsen Docker-kuvan "ubunutu" ja napsautan sitten tagia "latest".
{{< gallery match="images/2/*.png" >}}
Kaksoisnapsautan Ubuntu-kuvaani. Sitten napsautan "Lisäasetukset" ja aktivoin "Automaattinen uudelleenkäynnistys" myös tässä.
{{< gallery match="images/3/*.png" >}}
Valitsen "Volume"-välilehden ja napsautan "Add folder". Siellä luon uuden kansion, jossa on tämä liitäntäpolku "/download".
{{< gallery match="images/4/*.png" >}}
Nyt kontti voidaan käynnistää
{{< gallery match="images/5/*.png" >}}

## Vaihe 4: Asenna Udemy Downloader
Napsautan Synology Docker -ikkunassa "Container" -kohtaa ja kaksoisnapsautan "Udemy-säiliötä". Sitten napsautan "Terminal"-välilehteä ja kirjoitan seuraavat komennot.
{{< gallery match="images/6/*.png" >}}

##  Komennot:

{{< terminal >}}
apt-get update
apt-get install python3 python3-pip wget unzip
cd /download
wget https://github.com/r0oth3x49/udemy-dl/archive/refs/heads/master.zip
unzip master.zip
cd udemy-dl-master
pip3 pip install -r requirements.txt

{{</ terminal >}}
Kuvakaappauksia:
{{< gallery match="images/7/*.png" >}}

## Vaihe 4: Udemyn latausohjelman käyttöönotto
Nyt tarvitsen "access tokenin". Käyn Udemyssä Firefox-selaimellani ja avaan Firebugin. Napsautan "Web storage" -välilehteä ja kopioin "Access tokenin".
{{< gallery match="images/8/*.png" >}}
Luon uuden tiedoston säiliööni:
{{< terminal >}}
echo "access_token=859wjuhV7PMLsZu15GOWias9A0iFnRjkL9pJXOv2" > /download/cookie.txt

{{</ terminal >}}
Sen jälkeen voin ladata jo ostamani kurssit:
{{< terminal >}}
cd /download
python3 udemy-dl-master/udemy-dl.py -k /download/cookie.txt https://www.udemy.com/course/ansible-grundlagen/learn/

{{</ terminal >}}
Katso:
{{< gallery match="images/9/*.png" >}}

