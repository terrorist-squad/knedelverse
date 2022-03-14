+++
date = "2021-09-05"
title = "Geweldige dingen met containers: Logitech mediaservers op het Synology diskstation"
difficulty = "level-1"
tags = ["logitech", "synology", "diskstation", "nas", "sound-system", "multiroom"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/september/20210905-logitech-mediaserver/index.nl.md"
+++
In deze handleiding leert u hoe u een Logitech Media Server op een Synology DiskStation installeert.
{{< gallery match="images/1/*.jpg" >}}

## Stap 1: Logitech Media Server-map voorbereiden
Ik maak een nieuwe directory genaamd "logitechmediaserver" in de Docker directory.
{{< gallery match="images/2/*.png" >}}

## Stap 2: Installeer Logitech Mediaserver image
Ik klik op het tabblad "Registratie" in het Synology Docker-venster en zoek naar "logitechmediaserver". Ik selecteer de Docker image "lmscommunity/logitechmediaserver" en klik dan op de tag "latest".
{{< gallery match="images/3/*.png" >}}
Ik dubbelklik op mijn Logitech Media Server image. Dan klik ik op "Geavanceerde instellingen" en activeer ook hier de "Automatische herstart".
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Ordner |Mountpath|
|--- |---|
|/volume1/docker/logitechmediaserver/config |/config|
|/volume1/docker/logitechmediaserver/music |/muziek|
|/volume1/docker/logitechmediaserver/playlist |/playlist|
{{</table>}}
Ik selecteer het tabblad "Volume" en klik op "Map toevoegen". Daar maak ik drie mappen: Zie:
{{< gallery match="images/5/*.png" >}}
Ik wijs vaste poorten toe voor de "Logitechmediaserver" container. Zonder vaste poorten kan het zijn dat de "Logitechmediaserver server" na een herstart op een andere poort draait.
{{< gallery match="images/6/*.png" >}}
Tenslotte voer ik een omgevingsvariabele in. De variabele "TZ" is de tijdzone "Europa/Berlijn".
{{< gallery match="images/7/*.png" >}}
Na deze instellingen kan Logitechmediaserver-Server gestart worden! Daarna kunt u de Logitechmediaserver oproepen via het Ip adres van het Synology disctation en de toegewezen poort, bijvoorbeeld http://192.168.21.23:9000 .
{{< gallery match="images/8/*.png" >}}
