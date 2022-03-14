+++
date = "2020-02-13"
title = "Synology-Nas: Calibre Web als ebook-Bibliothek installieren"
difficulty = "level-1"
tags = ["calbre-web", "calibre", "Docker", "ds918", "ebook", "epub", "nas", "pdf", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200213-synology-calibreweb/index.de.md"
+++
Wie installiere ich Calibre-Web als Docker-Container auf meinen Synology-Nas?
Achtung: Dieser Installationsweg ist veraltet und ist mit der aktuellen Calibre-Software nicht kompatible. Bitte gucken Sie sich diese neue Anleitung an:
[Großartiges mit Containern: Calibre mit Docker-Compose betreiben]({{< ref "post/2020/february/20200221-docker-Calibre-pro" >}} "Großartiges mit Containern: Calibre mit Docker-Compose betreiben"). Diese Tutorial ist für alle Synology-DS-Profis.


## Schritt 1: Ordner erstellen
Als erstes erstelle ich einen Ordner für die Calibre- Bibliothek.  Ich rufe die „Systemsteurung“ ->  „Gemeinsamer Ordner“ auf und erstelle einen neuen Ordner „Buecher“.
{{< gallery match="images/1/*.png" >}}

##  Schritt 2: Calibre- Bibliothek erstellen
Nun kopiere ich eine bestehende Bibliothek oder "[diese leere Beispiel- Bibliothek](https://drive.google.com/file/d/1zfeU7Jh3FO_jFlWSuZcZQfQOGD0NvXBm/view)" in das neue Verzeichnis. Ich selbst habe die bestehende Bibliothek der Desktop-Applikation kopiert.
{{< gallery match="images/2/*.png" >}}


## Schritt 3: Docker-Image suchen
Ich klicke im Synology-Docker-Fenster auf den Reiter „Registrierung“ und suche nach „Calibre“. Ich wähle das Docker-Image „janeczku/calibre-web“ und klicke anschließend auf den Tag „latest“.
{{< gallery match="images/3/*.png" >}}

Nach dem Image – Download liegt das Image als Abbild bereit. Docker unterscheide zwischen 2 Zuständen, Container „Dynamisch zustand“ und Image/Abbild (Festzustand). Bevor wir nun einen Container aus dem Abbild erzeugen, müssen noch ein paar Einstellungen getätigt werden.

## Schritt 4: Image/Abbild in Betrieb nehmen:
Ich klicke per Doppelklick  auf mein Calibre-Abbild. 
{{< gallery match="images/4/*.png" >}}

Danach klicke ich auf „Erweiterte Einstellungen“ und aktiviere den „Automatischen Neustart". Ich wähle den Reiter „Volumen“ aus und klicke auf „Ordner hinzufügen“. Dort erstelle ich einen neuen Datenbank-Ordner mit diesem Mount-Pfad „/calibre“.
{{< gallery match="images/5/*.png" >}}

Ich vergebe feste Ports für den Calibre – Container. Ohne feste Ports könnte es sein, dass Calibre nach einem Neustart auf einen anderen Port läuft.
{{< gallery match="images/6/*.png" >}}

Nach diesen Einstellungen kann Calibre gestartet werden!
{{< gallery match="images/7/*.png" >}}

Ich rufe nun meine Synology-IP mit dem vergebenen Calibre-Port auf und sehe folgendes Bild. Als „Location of Calibre Database“ gebe ich „/calibre“ an. Die restlichen Einstellungen sind Geschmacksache.
{{< gallery match="images/8/*.png" >}}

Der Standard-Login ist „admin“ mit Passwort „admin123“. 
{{< gallery match="images/9/*.png" >}}

Fertig! Natürlich kann ich nun auch die Desktop-App über mein „Bücherordner“ anbinden. Ich  tausche die Bibliothek in meiner App und wähle anschließen meinen Nas-Ordner aus.
{{< gallery match="images/10/*.png" >}}

Ungefähr so:
{{< gallery match="images/11/*.png" >}}

Wenn ich jetzt Meta-Infos in der Desktop – App bearbeite, dann sind diese auch automatisch in der Web-App  aktualisiert.
{{< gallery match="images/12/*.png" >}}