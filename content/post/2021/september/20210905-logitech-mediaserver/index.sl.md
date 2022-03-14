+++
date = "2021-09-05"
title = "Odlične stvari s posodami: Logitechovi medijski strežniki na diskovni postaji Synology"
difficulty = "level-1"
tags = ["logitech", "synology", "diskstation", "nas", "sound-system", "multiroom"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/september/20210905-logitech-mediaserver/index.sl.md"
+++
V tem vodniku boste izvedeli, kako v strežnik Synology DiskStation namestiti medijski strežnik Logitech Media Server.
{{< gallery match="images/1/*.jpg" >}}

## Korak 1: Priprava mape Logitech Media Server
V imeniku Docker ustvarim nov imenik z imenom "logitechmediaserver".
{{< gallery match="images/2/*.png" >}}

## Korak 2: Namestitev slike Logitech Mediaserver
V oknu Synology Docker kliknem na zavihek "Registracija" in poiščem "logitechmediaserver". Izberem sliko Docker "lmscommunity/logitechmediaserver" in nato kliknem na oznako "latest".
{{< gallery match="images/3/*.png" >}}
Dvakrat kliknem na sliko Logitech Media Server. Nato kliknem na "Napredne nastavitve" in aktiviram možnost "Samodejni ponovni zagon".
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Ordner |Mountpath|
|--- |---|
|/volume1/docker/logitechmediaserver/config |/config|
|/volume1/docker/logitechmediaserver/music |/glasba|
|/volume1/docker/logitechmediaserver/playlist |/playlist|
{{</table>}}
Izberem zavihek "Zvezek" in kliknem na "Dodaj mapo". Tam ustvarim tri mape:Glej:
{{< gallery match="images/5/*.png" >}}
Kontejnerju "Logitechmediaserver" dodelim fiksna vrata. Brez fiksnih vrat je mogoče, da strežnik Logitechmediaserver po ponovnem zagonu deluje na drugih vratih.
{{< gallery match="images/6/*.png" >}}
Na koncu vnesem okoljsko spremenljivko. Spremenljivka "TZ" je časovni pas "Europe/Berlin".
{{< gallery match="images/7/*.png" >}}
Po teh nastavitvah lahko zaženete Logitechmediaserver-Server! Nato lahko pokličete Logitechmediaserver prek naslova Ip naprave Synology in dodeljenih vrat, na primer http://192.168.21.23:9000 .
{{< gallery match="images/8/*.png" >}}
