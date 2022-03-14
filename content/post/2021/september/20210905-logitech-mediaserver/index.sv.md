+++
date = "2021-09-05"
title = "Stora saker med behållare: Logitech medieservrar på Synology diskstation"
difficulty = "level-1"
tags = ["logitech", "synology", "diskstation", "nas", "sound-system", "multiroom"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/september/20210905-logitech-mediaserver/index.sv.md"
+++
I den här handledningen lär du dig hur du installerar en Logitech Media Server på Synology DiskStation.
{{< gallery match="images/1/*.jpg" >}}

## Steg 1: Förbered mappen Logitech Media Server
Jag skapar en ny katalog som heter "logitechmediaserver" i Docker-katalogen.
{{< gallery match="images/2/*.png" >}}

## Steg 2: Installera Logitech Mediaserver-avbildningen
Jag klickar på fliken "Registration" i Synology Docker-fönstret och söker efter "logitechmediaserver". Jag väljer Docker-avbildningen "lmscommunity/logitechmediaserver" och klickar sedan på taggen "latest".
{{< gallery match="images/3/*.png" >}}
Jag dubbelklickar på min Logitech Media Server-avbildning. Sedan klickar jag på "Avancerade inställningar" och aktiverar "Automatisk omstart" även här.
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Ordner |Mountpath|
|--- |---|
|/volume1/docker/logitechmediaserver/config |/konfiguration|
|/volume1/docker/logitechmediaserver/music |/musik|
|/volume1/docker/logitechmediaserver/playlist |/playlist|
{{</table>}}
Jag väljer fliken "Volym" och klickar på "Lägg till mapp". Där skapar jag tre mappar:Se:
{{< gallery match="images/5/*.png" >}}
Jag tilldelar fasta portar för behållaren "Logitechmediaserver". Utan fasta portar kan det vara så att "Logitechmediaserver-servern" körs på en annan port efter en omstart.
{{< gallery match="images/6/*.png" >}}
Slutligen anger jag en miljövariabel. Variabeln "TZ" är tidszonen "Europe/Berlin".
{{< gallery match="images/7/*.png" >}}
Efter dessa inställningar kan Logitechmediaserver-Server startas! Därefter kan du ringa Logitechmediaserver via Ip-adressen till Synology-disctationen och den tilldelade porten, till exempel http://192.168.21.23:9000 .
{{< gallery match="images/8/*.png" >}}
