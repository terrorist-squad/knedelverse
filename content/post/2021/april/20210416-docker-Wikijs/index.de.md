+++
date = "2021-04-16"
title = "Großartiges mit Containern: Wiki.js auf der Synology-Diskstation installieren"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "wikijs", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-Wikijs/index.de.md"
+++
Wiki.js ist eine leistungsstarke Open-Source-Wiki-Software, die mit ihrer einfachen Oberfläche die Dokumentation zu einem Vergnügen macht. Heute zeige ich, wie man einen Wiki.js-Dienst auf der Synology-Diskstation installiert.

## Option für Profis
Als erfahrener Synology-Nutzer kann man sich natürlich gleich mit SSH einloggen und das ganze Setup via Docker-Compose-Datei installieren.
```
version: '3'
services:
  wikijs:
    image: requarks/wiki:latest
    restart: always
    ports:
      - 8082:3000
    links:
      - database
    environment:
      DB_TYPE: mysql
      DB_HOST: database
      DB_PORT: 3306
      DB_NAME: my_wiki
      DB_USER: wikiuser
      DB_PASS: my_wiki_pass
      TZ: 'Europe/Berlin'

  database:
    image: mysql
    restart: always
    expose:
      - 3306
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: my_wiki_pass
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass
```
Weitere nützliche Docker-Images für den Heimgebrauch finden Sie im Dockerverse.

## Schritt 1: Wiki-Ordner vorbereiten
Ich erstelle ein neues Verzeichnis namens „wiki“ im Docker-Verzeichnis.
{{< gallery match="images/1/*.png" >}}

## Schritt 2: Datenbank installieren
Danach muss eine Datenbank erstellt werden. Ich klicke im Synology-Docker-Fenster auf den Reiter „Registrierung“ und suche nach „mysql“. Ich wähle das Docker-Image „mysql“ und klicke anschließend auf den Tag „latest“.
{{< gallery match="images/2/*.png" >}}

Nach dem Image – Download liegt das Image als Abbild bereit. Docker unterscheide zwischen 2 Zuständen, Container „Dynamisch zustand“ und Image/Abbild (Festzustand). Bevor wir nun einen Container aus dem Abbild erzeugen, müssen noch ein paar Einstellungen getätigt werden.

Ich klicke per Doppelklick  auf mein mysql-Abbild.
{{< gallery match="images/3/*.png" >}}

Danach klicke ich auf „Erweiterte Einstellungen“ und aktiviere den „Automatischen Neustart". Ich wähle den Reiter „Volumen“ aus und klicke auf „Ordner hinzufügen“. Dort erstelle ich einen neuen Datenbank-Ordner mit diesem Mount-Pfad „/var/lib/mysql“.
{{< gallery match="images/4/*.png" >}}

Unter „Port-Einstellungen“ werden alle Ports gelöscht. Das heißt, dass ich den „3306“-Port auswähle und mit dem "-"-Button lösche.
{{< gallery match="images/5/*.png" >}}

Zum Schluss trage ich noch diese vier Umgebungsvariablen ein:
{{<table "table table-striped table-bordered">}}
Variablenname |	Wert | Was ist das?
--- | --- | ---
TZ	| Europe/Berlin |	Zeitzone
MYSQL_ROOT_PASSWORD	| my_wiki_pass |	Masterpassword der Datenbank.
MYSQL_DATABASE |	my_wiki |	Das ist der Datenbankname.
MYSQL_USER	| wikiuser |	Benutzer-Name der Wiki-Datenbank.
MYSQL_PASSWORD |	my_wiki_pass	| Passwort des Wiki-Datenbanknutzers.
{{</table>}}

Siehe:
{{< gallery match="images/6/*.png" >}}
Nach diesen Einstellungen kann Mariadb-Server gestartet werden! Ich drücke überall auf „Übernehmen“.

## Schritt 3: Wiki.js installieren
Ich klicke im Synology-Docker-Fenster auf den Reiter „Registrierung“ und suche nach „wiki“. Ich wähle das Docker-Image „requarks/wiki“ aus und klicke anschließend auf den Tag „latest“.
{{< gallery match="images/7/*.png" >}}

Ich klicke per Doppelklick  auf mein WikiJS-Abbild. Danach klicke ich auf „Erweiterte Einstellungen“ und aktiviere auch hier den „Automatischen Neustart".
{{< gallery match="images/8/*.png" >}}

Ich vergebe feste Ports für den „WikiJS“ – Container. Ohne feste Ports könnte es sein, dass der „bookstack-Server“ nach einem Neustart auf einen anderen Port läuft. 
{{< gallery match="images/9/*.png" >}}

Außerdem muss noch ein „Link“ zum „mysql“-Container erstellt werden. Ich klicke auf den „Links“-Reiter und wählen den Datenbank-Container aus. Den Aliasnamen sollte man sich für die Wiki-Installation gut merken.
{{< gallery match="images/10/*.png" >}}

Zum Schluss trage ich noch diese Umgebungsvariablen ein:
{{<table "table table-striped table-bordered">}}
Variablenname |	Wert | Was ist das?
--- | --- | ---
TZ	| Europe/Berlin	| Zeitzone
DB_HOST	| wiki-db	| Aliasnamen / Container-Link
DB_TYPE	| mysql	|
DB_PORT	| 3306	 |
DB_PASSWORD	| my_wiki	| Daten aus Schritt 2
DB_USER	| wikiuser |	Daten aus Schritt 2
DB_PASS	| my_wiki_pass	| Daten aus Schritt 2
{{</table>}}

Siehe:
{{< gallery match="images/11/*.png" >}}

Der Container kann nun gestartet werden. Ich rufe den Wiki.js-Server mit der Synology-IP-Adresse und meinem Container–Port/3000 auf. 
{{< gallery match="images/12/*.png" >}}