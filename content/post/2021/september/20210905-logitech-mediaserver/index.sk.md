+++
date = "2021-09-05"
title = "Veľké veci s kontajnermi: mediálne servery Logitech na diskovej stanici Synology"
difficulty = "level-1"
tags = ["logitech", "synology", "diskstation", "nas", "sound-system", "multiroom"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/september/20210905-logitech-mediaserver/index.sk.md"
+++
V tomto návode sa dozviete, ako nainštalovať mediálny server Logitech do zariadenia Synology DiskStation.
{{< gallery match="images/1/*.jpg" >}}

## Krok 1: Príprava priečinka Logitech Media Server
V adresári Docker vytvorím nový adresár s názvom "logitechmediaserver".
{{< gallery match="images/2/*.png" >}}

## Krok 2: Inštalácia obrazu Logitech Mediaserver
Kliknem na kartu "Registrácia" v okne Synology Docker a vyhľadám "logitechmediaserver". Vyberiem obraz Docker "lmscommunity/logitechmediaserver" a potom kliknem na značku "latest".
{{< gallery match="images/3/*.png" >}}
Dvakrát kliknem na obraz servera Logitech Media Server. Potom kliknem na "Rozšírené nastavenia" a aktivujem tu aj "Automatický reštart".
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Ordner |Mountpath|
|--- |---|
|/volume1/docker/logitechmediaserver/config |/config|
|/volume1/docker/logitechmediaserver/music |/hudba|
|/volume1/docker/logitechmediaserver/playlist |/playlist|
{{</table>}}
Vyberiem kartu "Zväzok" a kliknem na "Pridať priečinok". Vytvorím tam tri priečinky:Pozri:
{{< gallery match="images/5/*.png" >}}
Pre kontajner "Logitechmediaserver" priraďujem pevné porty. Bez pevných portov by sa mohlo stať, že "Logitechmediaserver server" po reštarte beží na inom porte.
{{< gallery match="images/6/*.png" >}}
Nakoniec zadám premennú prostredia. Premenná "TZ" je časové pásmo "Európa/Berlín".
{{< gallery match="images/7/*.png" >}}
Po týchto nastaveniach je možné spustiť Logitechmediaserver-Server! Potom môžete zavolať Logitechmediaserver prostredníctvom Ip adresy diskovacieho zariadenia Synology a priradeného portu, napríklad http://192.168.21.23:9000 .
{{< gallery match="images/8/*.png" >}}
