+++
date = "2021-09-05"
title = "Lucruri grozave cu containere: servere media Logitech pe stația de discuri Synology"
difficulty = "level-1"
tags = ["logitech", "synology", "diskstation", "nas", "sound-system", "multiroom"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/september/20210905-logitech-mediaserver/index.ro.md"
+++
În acest tutorial, veți învăța cum să instalați un Logitech Media Server pe Synology DiskStation.
{{< gallery match="images/1/*.jpg" >}}

## Pasul 1: Pregătiți dosarul Logitech Media Server
Creez un nou director numit "logitechmediaserver" în directorul Docker.
{{< gallery match="images/2/*.png" >}}

## Pasul 2: Instalați imaginea Logitech Mediaserver
Fac clic pe fila "Înregistrare" din fereastra Synology Docker și caut "logitechmediaserver". Selectez imaginea Docker "lmscommunity/logitechmediaserver" și apoi dau click pe tag-ul "latest".
{{< gallery match="images/3/*.png" >}}
Fac dublu clic pe imaginea Logitech Media Server. Apoi fac clic pe "Setări avansate" și activez și aici "Repornire automată".
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Ordner |Mountpath|
|--- |---|
|/volume1/docker/logitechmediaserver/config |/config|
|/volume1/docker/logitechmediaserver/music |/music|
|/volume1/docker/logitechmediaserver/playlist |/playlist|
{{</table>}}
Selectez fila "Volume" și fac clic pe "Add folder". Acolo am creat trei dosare:Vezi:
{{< gallery match="images/5/*.png" >}}
Atribui porturi fixe pentru containerul "Logitechmediaserver". Fără porturi fixe, s-ar putea ca "Logitechmediaserver server" să ruleze pe un port diferit după o repornire.
{{< gallery match="images/6/*.png" >}}
În cele din urmă, introduc o variabilă de mediu. Variabila "TZ" este fusul orar "Europa/Berlin".
{{< gallery match="images/7/*.png" >}}
După aceste setări, Logitechmediaserver-Server poate fi pornit! După aceea puteți apela Logitechmediaserver prin intermediul adresei Ip a stației Synology și a portului atribuit, de exemplu http://192.168.21.23:9000 .
{{< gallery match="images/8/*.png" >}}
