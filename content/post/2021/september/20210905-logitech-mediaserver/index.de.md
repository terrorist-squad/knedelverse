+++
date = "2021-09-05"
title = "Großartiges mit Containern: Logitech-Mediaserver auf der Synology-Diskstation"
difficulty = "level-1"
tags = ["logitech", "synology", "diskstation", "nas", "sound-system", "multiroom"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/september/20210905-logitech-mediaserver/index.de.md"
+++
In diesem Tutorial erfahren Sie, wie Sie einen Logitech-Mediaserver auf der Synology-Diskstation installieren.
{{< gallery match="images/1/*.jpg" >}}

## Schritt 1: Logitechmediaserver-Ordner vorbereiten
ich erstelle ein neues Verzeichnis namens „logitechmediaserver“ im Docker-Verzeichnis. 
{{< gallery match="images/2/*.png" >}}

## Schritt 2: Logitechmediaserver-Image installieren
Ich klicke im Synology-Docker-Fenster auf den Reiter „Registrierung“ und suche nach „logitechmediaserver“. Ich wähle das Docker-Image „lmscommunity/logitechmediaserver“ aus und klicke anschließend auf den Tag „latest“. 
{{< gallery match="images/3/*.png" >}}


Ich klicke per Doppelklick auf mein Logitechmediaserver-Abbild. Danach klicke ich auf „Erweiterte Einstellungen“ und aktiviere auch hier den „Automatischen Neustart”. 
{{< gallery match="images/4/*.png" >}}


Ich wähle den Reiter „Volumen“ und klicke auf „Ordner hinzufügen“. Dort erstelle ich drei Ordner:

{{<table "table table-striped table-bordered">}}
Ordner |	 Mountpath
--- | --- 
/volume1/docker/logitechmediaserver/config | /config
/volume1/docker/logitechmediaserver/music | /music
/volume1/docker/logitechmediaserver/playlist | /playlist
{{</table>}}

Siehe:
{{< gallery match="images/5/*.png" >}}


Ich vergebe feste Ports für den „Logitechmediaserver“ – Container. Ohne feste Ports könnte es sein, dass der „Logitechmediaserver-Server“ nach einem Neustart auf einem anderen Port läuft.
{{< gallery match="images/6/*.png" >}}


Zum Schluss trage ich noch eine Umgebungsvariable ein. Die Variable „TZ“ die Zeitzone „Europe/Berlin“.
{{< gallery match="images/7/*.png" >}}

Nach diesen Einstellungen kann Logitechmediaserver-Server gestartet werden! Danach kann man den Logitechmediaserver über die Ip-Adresse der Synology-Disktation und den vergebenen Port aufrufen, zum Beispiel http://192.168.21.23:9000 .
{{< gallery match="images/8/*.png" >}}

