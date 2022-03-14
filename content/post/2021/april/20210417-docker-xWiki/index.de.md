+++
date = "2021-04-17"
title = "Großartiges mit Containern: Eigenes xWiki auf der Synology-Diskstation betreiben"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "xwiki", "wiki",]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210417-docker-xWiki/index.de.md"
+++
XWiki ist eine kostenlose Wiki-Softwareplattform, die in Java geschrieben wurde und deren Design auf Erweiterbarkeit ausgerichtet ist. Heute zeige ich, wie man einen xWiki-Dienst auf der Synology-Diskstation installiert.

## Option für Profis
Als erfahrener Synology-Nutzer kann man sich natürlich gleich mit SSH einloggen und das ganze Setup via Docker-Compose-Datei installieren.
```
version: '3'
services:
  xwiki:
    image: xwiki:10-postgres-tomcat
    restart: always
    ports:
      - 8080:8080
    links:
      - db
    environment:
      DB_HOST: db
      DB_DATABASE: xwiki
      DB_DATABASE: xwiki
      DB_PASSWORD: xwiki
      TZ: 'Europe/Berlin'

  db:
    image: postgres:latest
    restart: always
    volumes:
      - ./postgresql:/var/lib/postgresql/data
    environment:
      - POSTGRES_USER=xwiki
      - POSTGRES_PASSWORD=xwiki
      - POSTGRES_DB=xwiki
      - TZ='Europe/Berlin'
```
Weitere nützliche Docker-Images für den Heimgebrauch finden Sie im [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").

## Schritt 1: Wiki-Ordner vorbereiten
Ich erstelle ein neues Verzeichnis namens „wiki“ im Docker-Verzeichnis.
{{< gallery match="images/1/*.png" >}}

## Schritt 2: Datenbank installieren
Danach muss eine Datenbank erstellt werden. Ich klicke im Synology-Docker-Fenster auf den Reiter „Registrierung“ und suche nach „postgres“. Ich wähle das Docker-Image „postgres“ und klicke anschließend auf den Tag „latest“.
{{< gallery match="images/2/*.png" >}}

Nach dem Image – Download liegt das Image als Abbild bereit. Docker unterscheide zwischen 2 Zuständen, Container „Dynamisch zustand“ und Image/Abbild (Festzustand). Bevor wir nun einen Container aus dem Abbild erzeugen, müssen noch ein paar Einstellungen getätigt werden.

Ich klicke per Doppelklick  auf mein postgres-Abbild.
{{< gallery match="images/3/*.png" >}}

Danach klicke ich auf „Erweiterte Einstellungen“ und aktiviere den „Automatischen Neustart". Ich wähle den Reiter „Volumen“ aus und klicke auf „Ordner hinzufügen“. Dort erstelle ich einen neuen Datenbank-Ordner mit diesem Mount-Pfad „/var/lib/postgresql/data“.
{{< gallery match="images/4/*.png" >}}

Unter „Port-Einstellungen“ werden alle Ports gelöscht. Das heißt, dass ich den „5432“-Port auswähle und mit dem "-"-Button lösche.
{{< gallery match="images/5/*.png" >}}

Zum Schluss trage ich noch diese vier Umgebungsvariablen ein:
{{<table "table table-striped table-bordered">}}
Variablenname |	Wert | Was ist das?
--- | --- | ---
TZ	| Europe/Berlin	| Zeitzone
POSTGRES_DB	| xwiki |	Das ist der Datenbankname.
POSTGRES_USER	| xwiki |	Benutzer-Name der Wiki-Datenbank.
POSTGRES_PASSWORD	| xwiki |	Passwort des Wiki-Datenbanknutzers.
{{</table>}}

Siehe:
{{< gallery match="images/6/*.png" >}}

Nach diesen Einstellungen kann Mariadb-Server gestartet werden! Ich drücke überall auf „Übernehmen“.

## Schritt 3: xWiki installieren
Ich klicke im Synology-Docker-Fenster auf den Reiter „Registrierung“ und suche nach „xwiki“. Ich wähle das Docker-Image „xwiki“ aus und klicke anschließend auf den Tag „10-postgres-tomcat“.
{{< gallery match="images/7/*.png" >}}

Ich klicke per Doppelklick  auf mein xwiki-Abbild. Danach klicke ich auf „Erweiterte Einstellungen“ und aktiviere auch hier den „Automatischen Neustart".
{{< gallery match="images/8/*.png" >}}

Ich vergebe feste Ports für den „xwiki“ – Container. Ohne feste Ports könnte es sein, dass der „xwiki-Server“ nach einem Neustart auf einen anderen Port läuft.
{{< gallery match="images/9/*.png" >}}

Außerdem muss noch ein „Link“ zum „postgres“-Container erstellt werden. Ich klicke auf den „Links“-Reiter und wählen den Datenbank-Container aus. Den Aliasnamen sollte man sich für die Wiki-Installation gut merken.
{{< gallery match="images/10/*.png" >}}

Zum Schluss trage ich noch diese Umgebungsvariablen ein:
{{<table "table table-striped table-bordered">}}
Variablenname |	Wert | Was ist das?
--- | --- | ---
TZ |	Europe/Berlin	| Zeitzone
DB_HOST	| db |	Aliasnamen / Container-Link
DB_DATABASE	| xwiki	| Daten aus Schritt 2
DB_USER	| xwiki	| Daten aus Schritt 2
DB_PASSWORD	| xwiki |	Daten aus Schritt 2
{{</table>}}

Siehe:
{{< gallery match="images/11/*.png" >}}

Der Container kann nun gestartet werden. Ich rufe den xWiki-Server mit der Synology-IP-Adresse und meinem Container–Port auf.
{{< gallery match="images/12/*.png" >}}