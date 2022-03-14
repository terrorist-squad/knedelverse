+++
date = "2021-05-30"
title = "Udemy-Downloader auf der Synology-Diskstation"
difficulty = "level-2"
tags = ["udemy", "download", "synology", "diskstation", "udemydl"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/may/20210530-udemydl/index.de.md"
+++

In diesem Tutorial erfahren Sie, wie man "udemy"-Kurse für den Offline-Gebrauch downloaden kann.

## Schritt 1: Udemy-Ordner vorbereiten
ich erstelle ein neues Verzeichnis namens „udemy“ im Docker-Verzeichnis. 
{{< gallery match="images/1/*.png" >}}

## Schritt 2: Ubuntu-Image installieren
Ich klicke im Synology-Docker-Fenster auf den Reiter „Registrierung“ und suche nach „ubunutu“. Ich wähle das Docker-Image „ubunutu“ aus und klicke anschließend auf den Tag „latest“. 
{{< gallery match="images/2/*.png" >}}


Ich klicke per Doppelklick auf mein Ubuntu-Abbild. Danach klicke ich auf „Erweiterte Einstellungen“ und aktiviere auch hier den „Automatischen Neustart”. 
{{< gallery match="images/3/*.png" >}}

Ich wähle den Reiter „Volumen“ und klicke auf „Ordner hinzufügen“. Dort erstelle ich einen neuen Ordner mit diesem Mount-Pfad „/download“. 
{{< gallery match="images/4/*.png" >}}

Nun kann der Container gestartet werden
{{< gallery match="images/5/*.png" >}}


## Schritt 4: Udemy-Downloader installieren
Ich klicke im Synology-Docker-Fenster auf "Container" und klicke per Doppelklick auf meinen "Udemy-Container". Danach klicke ich auf den "Terminal"-Reiter und gebe die folgenden Befehle ein.
{{< gallery match="images/6/*.png" >}}

### Befehle:
{{< terminal >}}
apt-get update
apt-get install python3 python3-pip wget unzip
cd /download
wget https://github.com/r0oth3x49/udemy-dl/archive/refs/heads/master.zip
unzip master.zip
cd udemy-dl-master
pip3 pip install -r requirements.txt
{{</ terminal >}}
Screenshots:
{{< gallery match="images/7/*.png" >}}

## Schritt 4: Udemy-Downloader in Betrieb nehmen
Nun brauch ich noch eine "Access-Token". Ich besuche Udemy mit meinen Firfox-Browser und öffne Firebug. Ich klicke auf den "Web-Speicher"-Reiter und kopiere mir den  "Access-Token".
{{< gallery match="images/8/*.png" >}}

Ich erzeuge eine neue Datei in meinem Container:
{{< terminal >}}
echo "access_token=859wjuhV7PMLsZu15GOWias9A0iFnRjkL9pJXOv2" > /download/cookie.txt
{{</ terminal >}}

Danach kann ich die bereits gekauften Kurse downloaden:
{{< terminal >}}
cd /download
python3 udemy-dl-master/udemy-dl.py -k /download/cookie.txt https://www.udemy.com/course/ansible-grundlagen/learn/
{{</ terminal >}}

Siehe:
{{< gallery match="images/9/*.png" >}}
