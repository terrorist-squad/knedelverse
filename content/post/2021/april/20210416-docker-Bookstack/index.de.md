+++
date = "2021-04-16"
title = "Großartiges mit Containern: Eigenes Bookstack-Wiki auf der Synology-Diskstation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "bookstack", "wiki"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210416-docker-Bookstack/index.de.md"
+++


Bookstack ist eine „Open Source“-Alternative zu MediaWiki oder Confluence. Heute zeige ich, wie man einen Bookstack-Dienst auf der Synology-Diskstation installiert.

## Option für Profis
Als erfahrener Synology-Nutzer kann man sich natürlich gleich mit SSH einloggen und das ganze Setup via Docker-Compose-Datei installieren.
```
version: '3'
services:
  bookstack:
    image: solidnerd/bookstack:0.27.4-1
    restart: always
    ports:
      - 8080:8080
    links:
      - database
    environment:
      DB_HOST: database:3306
      DB_DATABASE: my_wiki
      DB_USERNAME: wikiuser
      DB_PASSWORD: my_wiki_pass
      
  database:
    image: mariadb
    restart: always
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      MYSQL_ROOT_PASSWORD: my_wiki_pass1
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass
```
Weitere nützliche Docker-Images für den Heimgebrauch finden Sie im [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").

## Schritt 1: Bookstack-Ordner vorbereiten
Ich erstelle ein neues Verzeichnis namens „wiki“ im Docker-Verzeichnis.
{{< gallery match="images/1/*.png" >}}

## Schritt 2: Datenbank installieren
Danach muss eine Datenbank erstellt werden. Ich klicke im Synology-Docker-Fenster auf den Reiter „Registrierung“ und suche nach „mariadb“. Ich wähle das Docker-Image „mariadb“ und klicke anschließend auf den Tag „latest“.
{{< gallery match="images/2/*.png" >}}

Nach dem Image – Download liegt das Image als Abbild bereit. Docker unterscheide zwischen 2 Zuständen, Container „Dynamisch zustand“ und Image/Abbild (Festzustand). Bevor wir nun einen Container aus dem Abbild erzeugen, müssen noch ein paar Einstellungen getätigt werden.

Ich klicke per Doppelklick  auf mein mariadb-Abbild.
{{< gallery match="images/3/*.png" >}}

Danach klicke ich auf „Erweiterte Einstellungen“ und aktiviere den „Automatischen Neustart". Ich wähle den Reiter „Volumen“ aus und klicke auf „Ordner hinzufügen“. Dort erstelle ich einen neuen Datenbank-Ordner mit diesem Mount-Pfad „/var/lib/mysql“.
{{< gallery match="images/4/*.png" >}}

Unter „Port-Einstellungen“ werden alle Ports gelöscht. Das heißt, dass ich den „3306“-Port auswähle und mit dem "-"-Button lösche.
{{< gallery match="images/5/*.png" >}}

Zum Schluss trage ich noch diese Umgebungsvariablen ein:
{{<table "table table-striped table-bordered">}}
Variablenname |	Wert | Was ist das?
--- | --- | ---
TZ	| Europe/Berlin |	Zeitzone
MYSQL_ROOT_PASSWORD	|  my_wiki_pass | 	Masterpassword der Datenbank.
MYSQL_DATABASE | 	my_wiki	|  Das ist der Datenbankname.
MYSQL_USER	|  wikiuser	|  Benutzer-Name der Wiki-Datenbank.
MYSQL_PASSWORD	|  my_wiki_pass	|  Passwort des Wiki-Datenbanknutzers.
{{</table>}}

Siehe:
{{< gallery match="images/6/*.png" >}}
Nach diesen Einstellungen kann Mariadb-Server gestartet werden! Ich drücke überall auf „Übernehmen“.

## Schritt 3: Bookstack installieren
Ich klicke im Synology-Docker-Fenster auf den Reiter „Registrierung“ und suche nach „bookstack“. Ich wähle das Docker-Image „solidnerd/bookstack“ aus und klicke anschließend auf den Tag „latest“.
{{< gallery match="images/7/*.png" >}}

Ich klicke per Doppelklick  auf mein Bookstack-Abbild. Danach klicke ich auf „Erweiterte Einstellungen“ und aktiviere auch hier den „Automatischen Neustart".
{{< gallery match="images/8/*.png" >}}

Ich vergebe feste Ports für den „bookstack“ – Container. Ohne feste Ports könnte es sein, dass der „bookstack-Server“ nach einem Neustart auf einen anderen Port läuft. Der erste Container-Port kann gelöscht werden. Den anderen Port sollte man sich merken.
{{< gallery match="images/9/*.png" >}}

Außerdem muss noch ein „Link“ zum „mariadb“-Container erstellt werden. Ich klicke auf den „Links“-Reiter und wählen den Datenbank-Container aus. Den Aliasnamen sollte man sich für die Wiki-Installation gut merken.
{{< gallery match="images/10/*.png" >}}


Zum Schluss trage ich noch diese Umgebungsvariablen ein:
{{<table "table table-striped table-bordered">}}
Variablenname |	Wert | Was ist das?
--- | --- | ---
TZ	| Europe/Berlin |	Zeitzone
DB_HOST	| wiki-db:3306	| Aliasnamen / Container-Link
DB_DATABASE	| my_wiki |	Daten aus Schritt 2
DB_USERNAME	| wikiuser |	Daten aus Schritt 2
DB_PASSWORD	| my_wiki_pass	| Daten aus Schritt 2
{{</table>}}

Siehe:
{{< gallery match="images/11/*.png" >}}

Der Container kann nun gestartet werden. Eventuell kann das Anlegen der Datenbank etwas dauern. Das verhalten lässt sich über die Container-Details beobachten.
{{< gallery match="images/12/*.png" >}}

Ich rufe den Bookstack-Server mit der Synology-IP-Adresse und meinem Container–Port auf. Der Login-Name ist „admin@admin.com“ und das Passwort ist „password“.
{{< gallery match="images/13/*.png" >}}

