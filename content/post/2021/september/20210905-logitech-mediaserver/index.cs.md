+++
date = "2021-09-05"
title = "Skvělé věci s kontejnery: Mediální servery Logitech na diskové stanici Synology"
difficulty = "level-1"
tags = ["logitech", "synology", "diskstation", "nas", "sound-system", "multiroom"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/september/20210905-logitech-mediaserver/index.cs.md"
+++
V tomto návodu se dozvíte, jak nainstalovat mediální server Logitech na zařízení Synology DiskStation.
{{< gallery match="images/1/*.jpg" >}}

## Krok 1: Příprava složky Logitech Media Server
V adresáři Docker vytvořím nový adresář s názvem "logitechmediaserver".
{{< gallery match="images/2/*.png" >}}

## Krok 2: Instalace obrazu Logitech Mediaserver
V okně Synology Docker kliknu na kartu "Registrace" a vyhledám "logitechmediaserver". Vyberu obraz Docker "lmscommunity/logitechmediaserver" a kliknu na značku "latest".
{{< gallery match="images/3/*.png" >}}
Dvakrát kliknu na obraz serveru Logitech Media Server. Pak kliknu na "Rozšířené nastavení" a aktivuji zde také "Automatický restart".
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Ordner |Mountpath|
|--- |---|
|/volume1/docker/logitechmediaserver/config |/config|
|/volume1/docker/logitechmediaserver/music |/hudba|
|/volume1/docker/logitechmediaserver/playlist |/playlist|
{{</table>}}
Vyberu kartu "Svazek" a kliknu na "Přidat složku". Tam vytvořím tři složky:Viz:
{{< gallery match="images/5/*.png" >}}
Pro kontejner "Logitechmediaserver" přiřadím pevné porty. Bez pevných portů by se mohlo stát, že "Logitechmediaserver server" po restartu poběží na jiném portu.
{{< gallery match="images/6/*.png" >}}
Nakonec zadám proměnnou prostředí. Proměnná "TZ" je časové pásmo "Evropa/Berlín".
{{< gallery match="images/7/*.png" >}}
Po těchto nastaveních lze spustit Logitechmediaserver-Server! Poté můžete zavolat Logitechmediaserver prostřednictvím Ip adresy zařízení Synology a přiřazeného portu, například http://192.168.21.23:9000 .
{{< gallery match="images/8/*.png" >}}

