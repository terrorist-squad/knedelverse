+++
date = "2021-03-07"
title = "Großartiges mit Containern: Rezepte auf der Synology-Diskstation verwalten und archivieren"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "docker-for-desktop", "rezepte", "speisen", "Synology"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/march/20210307-docker-mealie/index.de.md"
+++

Sammeln Sie alle Ihre Lieblingsrezepte im Docker-Container und organisieren Sie diese nach Ihren Wünschen. Schreiben Sie eigene Rezepte oder Importieren Sie Rezepte von Websites, zum Beispiel „Chefkoch“, „Essen & Trinken“ oder „BBC-FOOD“. Ich zeige Ihnen, wie Sie das Docker-Image „Mealie“ zum Laufen bringen.
{{< gallery match="images/1/*.png" >}}

## Option für Profis
Als erfahrener Synology-Nutzer kann man sich natürlich gleich mit SSH einloggen und das ganze Setup via Docker-Compose-Datei installieren.
```
version: "2.0"
services:
  mealie:
    container_name: mealie
    image: hkotel/mealie:latest
    restart: always
    ports:
      - 9000:80
    environment:
      db_type: sqlite
      TZ: Europa/Berlin
    volumes:
      - ./mealie/data/:/app/data
```

## Schritt 1: Docker-Image suchen
Ich klicke im Synology-Docker-Fenster auf den Reiter „Registrierung“ und suche nach „mealie“. Ich wähle das Docker-Image „hkotel/mealie:latest“ und klick anschließend auf den Tag „latest“.
{{< gallery match="images/2/*.png" >}}

Nach dem Image – Download liegt das Image als Abbild bereit. Docker unterscheide zwischen 2 Zuständen, Container „Dynamisch zustand“ und Image/Abbild (Festzustand). Bevor wir nun einen Container aus dem Abbild erzeugen, müssen noch ein paar Einstellungen getätigt werden.

## Schritt 2: Image/Abbild in Betrieb nehmen:
Ich klicke per Doppelklick  auf mein „mealie“-Abbild.
{{< gallery match="images/3/*.png" >}}

Danach klicke ich auf „Erweiterte Einstellungen“ und aktiviere den „Automatischen Neustart". Ich wähle den Reiter „Volumen“ und klicke auf „Ordner hinzufügen“. Dort erstelle ich einen neuen Ordner mit diesem Mount-Pfad „/app/data“.
{{< gallery match="images/4/*.png" >}}

Ich vergebe feste Ports für den „Mealie“ – Container. Ohne feste Ports könnte es sein, dass der „Mealie-Server“ nach einem Neustart auf einen anderen Port läuft.
{{< gallery match="images/5/*.png" >}}

Zum Schluss trage ich noch zwei Umgebungsvariablen ein. Die Variable „db_type“ ist der Datenbanktyp und „TZ“ die Zeitzone „Europe/Berlin“.
{{< gallery match="images/6/*.png" >}}

Nach diesen Einstellungen kann Mealie-Server gestartet werden! Danach kann man Mealie über die Ip-Adresse der Synology-Disktation und den vergebenen Port aufrufen, zum Beispiel http://192.168.21.23:8096 .
{{< gallery match="images/7/*.png" >}}

## Wie funktioniert Mealie?
Wenn ich mit der Mouse über den „Plus“-Button rechts/unten fahre und danach auf das „Ketten“-Symbol klicke, kann ich eine Url eingeben. Die Mealie -Applikation sucht sich dann selbständig die benötigten Meta- und Schema- Information raus.
{{< gallery match="images/8/*.png" >}}

Der Import funktioniert großartig (ich habe diese Funktionen mit Urls von Chefkoch, Essen & Trinken und BBC-Food getestet). Anschließend kann das Rezept nachbearbeitet werden.
{{< gallery match="images/9/*.png" >}}

Im Bearbeitungs-Modus kann ich auch eine Kategorie hinzufügen. Wichtig ist, dass ich nach jeder Kategorie einmal die „Enter“-Taste drücke. Sonst wird diese Einstellung nicht übernommen.
{{< gallery match="images/10/*.png" >}}

## Besonderheiten
Mir ist aufgefallen, dass sich die Menü-Kategorien nicht automatisch aktualisieren. Hier muss man mit einem Browser-Reload nachhelfen.
{{< gallery match="images/11/*.png" >}}

## Sonstige Features
Natürlich kann man Rezepte suchen und auch Speisepläne erstellen. Außerdem kann man „Mealie“ sehr umfangreich anpassen.
{{< gallery match="images/12/*.png" >}}

Auch auf dem Handy sieht Mealie großartig aus:
{{< gallery match="images/13/*.*" >}}

## Rest-Api
Unter „http://gewaehlte-ip:und-port … /docs“ ist die API-Dokumentation zu finden. Hier findet man viele Methode, die sich für eine Automatisierung nutzen lassen.
{{< gallery match="images/14/*.png" >}}

## Api-Beispiel
Stellen Sie sich die folgende Fiktion vor: „Gruner und Jahr stellt das Internetportal Essen&Trinken ein“! Sichern Sie sich noch schnell alle Rezepte via Bash-Script. Als erstes muss, eine Liste aller Rezept-Urls erstellt werden, Beispiel:
{{< terminal >}}
wget --spider --force-html -r -l12  "https://www.essen-und-trinken.de/rezepte/archiv/"  2>&1 | grep '/rezepte/' | grep '^--' | awk '{ print $3 }' > liste.txt
{{</ terminal >}}

Anschließend bereinigen Sie diese Liste und feuern diese gegen die Rest-Api, Beispiel:
```
#!/bin/bash
sort -u liste.txt > clear.txt

while read p; do
  echo "import url: $p"
  curl -d "{\"url\":\"$p\"}" -H "Content-Type: application/json" http://synology-ip:8096/api/recipes/create-url
  sleep 1
done < clear.txt
```

Nun können Sie die Rezepte auch offline erreichen:
{{< gallery match="images/15/*.png" >}}

Fazit: Wenn man etwas Zeit in Mealie steckt, dann kann man eine tolle Rezept-Datenbank bauen! Mealie wird als open source Projekt ständig weiterentwickelt und ist unter der folgenden Adresse zu finden https://github.com/hay-kot/mealie/