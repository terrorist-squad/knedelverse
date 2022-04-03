+++
date = "2021-09-05"
title = "Wspaniałe rzeczy z kontenerami: serwery multimediów Logitech na stacji dysków Synology"
difficulty = "level-1"
tags = ["logitech", "synology", "diskstation", "nas", "sound-system", "multiroom"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/september/20210905-logitech-mediaserver/index.pl.md"
+++
W tym samouczku dowiesz się, jak zainstalować serwer multimediów firmy Logitech na serwerze Synology DiskStation.
{{< gallery match="images/1/*.jpg" >}}

## Krok 1: Przygotuj folder Logitech Media Server
W katalogu Docker tworzę nowy katalog o nazwie "logitechmediaserver".
{{< gallery match="images/2/*.png" >}}

## Krok 2: Zainstaluj obraz Logitech Mediaserver
Klikam kartę "Rejestracja" w oknie Synology Docker i wyszukuję "logitechmediaserver". Wybieram obraz Docker "lmscommunity/logitechmediaserver", a następnie klikam znacznik "latest".
{{< gallery match="images/3/*.png" >}}
Klikam dwukrotnie obraz serwera Logitech Media Server. Następnie klikam na "Ustawienia zaawansowane" i włączam opcję "Automatyczne ponowne uruchamianie".
{{< gallery match="images/4/*.png" >}}
{{<table "table table-striped table-bordered">}}
|Ordner |Mountpath|
|--- |---|
|/volume1/docker/logitechmediaserver/config |/config|
|/volume1/docker/logitechmediaserver/music |/muzyka|
|/volume1/docker/logitechmediaserver/playlist |/playlista|
{{</table>}}
Wybieram zakładkę "Wolumin" i klikam "Dodaj folder". W tym miejscu tworzę trzy foldery:Zobacz:
{{< gallery match="images/5/*.png" >}}
Do kontenera "Logitechmediaserver" przypisuję stałe porty. Bez ustalonych portów może się zdarzyć, że po ponownym uruchomieniu "serwer Logitechmediaserver" działa na innym porcie.
{{< gallery match="images/6/*.png" >}}
Na koniec należy wprowadzić zmienną środowiskową. Zmienna "TZ" oznacza strefę czasową "Europa/Berlin".
{{< gallery match="images/7/*.png" >}}
Po wprowadzeniu tych ustawień można uruchomić serwer Logitechmediaserver! Następnie można nawiązać połączenie z aplikacją Logitechmediaserver za pośrednictwem adresu IP stacji dyskowej Synology i przypisanego portu, na przykład http://192.168.21.23:9000 .
{{< gallery match="images/8/*.png" >}}

