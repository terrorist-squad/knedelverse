+++
date = "2021-04-16"
title = "Großartiges mit Containern: Eigenes MediaWiki auf der Synology-Diskstation installieren"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "mediawiki", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210416-docker-MediaWiki/index.de.md"
+++

MediaWiki ist ein auf PHP basiertes Wiki-System, welches als Open Source-Produkt kostenlos verfügbar ist. Heute zeige ich, wie man einen MediaWiki-Dienst auf der Synology-Diskstation installiert.

## Option für Profis
Als erfahrener Synology-Nutzer kann man sich natürlich gleich mit SSH einloggen und das ganze Setup via Docker-Compose-Datei installieren.
```
version: '3'
services:
  mediawiki:
    image: mediawiki
    restart: always
    ports:
      - 8081:80
    links:
      - database
    volumes:
      - ./images:/var/www/html/images
      # After initial setup, download LocalSettings.php to the same directory as
      # this yaml and uncomment the following line and use compose to restart
      # the mediawiki service
      # - ./LocalSettings.php:/var/www/html/LocalSettings.php

  database:
    image: mariadb
    restart: always
    volumes:
       - ./mysql:/var/lib/mysql
    environment:
      # @see https://phabricator.wikimedia.org/source/mediawiki/browse/master/includes/DefaultSettings.php
      MYSQL_ROOT_PASSWORD: my_wiki_pass1
      MYSQL_DATABASE: my_wiki
      MYSQL_USER: wikiuser
      MYSQL_PASSWORD: my_wiki_pass
```
Weitere nützliche Docker-Images für den Heimgebrauch finden Sie im [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").

## Schritt 1: MediaWiki-Ordner vorbereiten
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
TZ	| Europe/Berlin	| Zeitzone
MYSQL_ROOT_PASSWORD	| my_wiki_pass	| Masterpassword der Datenbank.
MYSQL_DATABASE |	my_wiki	| Das ist der Datenbankname.
MYSQL_USER	| wikiuser |	Benutzer-Name der Wiki-Datenbank.
MYSQL_PASSWORD	| my_wiki_pass |	Passwort des Wiki-Datenbanknutzers.
{{</table>}}

Siehe:
{{< gallery match="images/6/*.png" >}}

Nach diesen Einstellungen kann Mariadb-Server gestartet werden! Ich drücke überall auf „Übernehmen“.

## Schritt 3: MediaWiki installieren
Ich klicke im Synology-Docker-Fenster auf den Reiter „Registrierung“ und suche nach „mediawiki“. Ich wähle das Docker-Image „mediawiki“ aus und klicke anschließend auf den Tag „latest“.
{{< gallery match="images/7/*.png" >}}

Ich klicke per Doppelklick  auf mein Mediawiki-Abbild.
{{< gallery match="images/8/*.png" >}}

Danach klicke ich auf „Erweiterte Einstellungen“ und aktiviere auch hier den „Automatischen Neustart". Ich wähle den Reiter „Volumen“ und klicke auf „Ordner hinzufügen“. Dort erstelle ich einen neuen Ordner mit diesem Mount-Pfad „/var/www/html/images“.
{{< gallery match="images/9/*.png" >}}

Ich vergebe feste Ports für den „MediaWiki“ – Container. Ohne feste Ports könnte es sein, dass der „MediaWiki-Server“ nach einem Neustart auf einen anderen Port läuft.
{{< gallery match="images/10/*.png" >}}

Außerdem muss noch ein „Link“ zum „mariadb“-Container erstellt werden. Ich klicke auf den „Links“-Reiter und wählen den Datenbank-Container aus. Den Aliasnamen sollte man sich für die Wiki-Installation gut merken.
{{< gallery match="images/11/*.png" >}}

Zum Schluss trage ich noch eine Umgebungsvariable „TZ“ mit Wert „Europe/Berlin“ ein.
{{< gallery match="images/12/*.png" >}}

Der Container kann nun gestartet werden. Ich rufe den Mediawiki-Server mit der Synology-IP-Adresse und meinem Container–Port auf. Bei Datenbankserver trage ich den Aliasnamen des Datenbank-Containers ein. Außerdem trage ich den Datenbanknamen, Nutzernamen und das Password aus „Schritt 2“ ein.
{{< gallery match="images/13/*.png" >}}