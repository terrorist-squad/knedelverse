+++
date = "2021-09-05"
title = "Suuria asioita säiliöillä: Logitechin mediapalvelimet Synologyn levyasemalla"
difficulty = "level-1"
tags = ["logitech", "synology", "diskstation", "nas", "sound-system", "multiroom"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/september/20210905-logitech-mediaserver/index.fi.md"
+++
Tässä opetusohjelmassa opit asentamaan Logitech Media Serverin Synology DiskStationiin.
{{< gallery match="images/1/*.jpg" >}}

## Vaihe 1: Valmistele Logitech Media Server -kansio.
Luon Docker-hakemistoon uuden hakemiston nimeltä "logitechmediaserver".
{{< gallery match="images/2/*.png" >}}

## Vaihe 2: Asenna Logitech Mediaserver -kuva
Napsautan Synology Docker -ikkunan "Rekisteröinti"-välilehteä ja etsin "logitechmediaserver". Valitsen Docker-kuvan "lmscommunity/logitechmediaserver" ja napsautan sitten tagia "latest".
{{< gallery match="images/3/*.png" >}}
Kaksoisnapsautan Logitech Media Server -kuvaa. Sitten napsautan "Lisäasetukset" ja aktivoin "Automaattinen uudelleenkäynnistys" myös täällä.
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Ordner |Mountpath|
|--- |---|
|/volume1/docker/logitechmediaserver/config |/config|
|/volume1/docker/logitechmediaserver/music |/musiikki|
|/volume1/docker/logitechmediaserver/playlist |/playlist|
{{</table>}}
Valitsen "Volume"-välilehden ja napsautan "Add folder". Siellä luon kolme kansiota: Ks:
{{< gallery match="images/5/*.png" >}}
Määritän kiinteät portit kontille "Logitechmediaserver". Ilman kiinteitä portteja voi olla, että "Logitechmediaserver-palvelin" toimii eri portissa uudelleenkäynnistyksen jälkeen.
{{< gallery match="images/6/*.png" >}}
Lopuksi annan ympäristömuuttujan. Muuttuja "TZ" on aikavyöhyke "Eurooppa/Berliini".
{{< gallery match="images/7/*.png" >}}
Näiden asetusten jälkeen Logitechmediaserver-palvelin voidaan käynnistää! Sen jälkeen voit soittaa Logitechmediaserveriin Synology-aseman Ip-osoitteen ja osoitetun portin kautta, esimerkiksi http://192.168.21.23:9000 .
{{< gallery match="images/8/*.png" >}}
