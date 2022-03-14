+++
date = "2021-09-05"
title = "Store ting med containere: Logitech medieservere på Synology diskstation"
difficulty = "level-1"
tags = ["logitech", "synology", "diskstation", "nas", "sound-system", "multiroom"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/september/20210905-logitech-mediaserver/index.da.md"
+++
I denne vejledning lærer du, hvordan du installerer en Logitech Media Server på Synology DiskStation.
{{< gallery match="images/1/*.jpg" >}}

## Trin 1: Forbered Logitech Media Server-mappen
Jeg opretter en ny mappe med navnet "logitechmediaserver" i Docker-mappen.
{{< gallery match="images/2/*.png" >}}

## Trin 2: Installer Logitech Mediaserver-aftryk
Jeg klikker på fanen "Registration" i Synology Docker-vinduet og søger efter "logitechmediaserver". Jeg vælger Docker-image "lmscommunity/logitechmediaserver" og klikker derefter på tagget "latest".
{{< gallery match="images/3/*.png" >}}
Jeg dobbeltklikker på mit Logitech Media Server-aftryk. Derefter klikker jeg på "Avancerede indstillinger" og aktiverer også "Automatisk genstart" her.
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Ordner |Mountpath|
|--- |---|
|/volume1/docker/logitechmediaserver/config |/config|
|/volume1/docker/logitechmediaserver/music |/musik|
|/volume1/docker/logitechmediaserver/playlist |/spilleliste|
{{</table>}}
Jeg vælger fanen "Volume" og klikker på "Add folder" (tilføj mappe). Der opretter jeg tre mapper:Se:
{{< gallery match="images/5/*.png" >}}
Jeg tildeler faste porte til "Logitechmediaserver"-containeren. Uden faste porte kan det være, at "Logitechmediaserver-serveren" kører på en anden port efter en genstart.
{{< gallery match="images/6/*.png" >}}
Endelig indtaster jeg en miljøvariabel. Variablen "TZ" er tidszonen "Europe/Berlin".
{{< gallery match="images/7/*.png" >}}
Efter disse indstillinger kan Logitechmediaserver-Server startes! Derefter kan du ringe til Logitechmediaserver via Ip-adressen på Synology-disktionen og den tildelte port, f.eks. http://192.168.21.23:9000 .
{{< gallery match="images/8/*.png" >}}
