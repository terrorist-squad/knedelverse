+++
date = "2021-04-18"
title = "Großartiges mit Containern: Eigenes WallaBag auf der Synology-Diskstation"
difficulty = "level-1"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "archiv", "wallabag"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-WallaBag/index.de.md"
+++

Wallabag ist ein Programm zum archivieren von interessanten Webseiten bzw. Artikeln. Heute zeige ich, wie man einen Wallabag-Dienst auf der Synology-Diskstation installiert.

## Option für Profis
Als erfahrener Synology-Nutzer kann man sich natürlich gleich mit SSH einloggen und das ganze Setup via Docker-Compose-Datei installieren.
```
version: '3'
services:
  wallabag:
    image: wallabag/wallabag
    environment:
      - MYSQL_ROOT_PASSWORD=wallaroot
      - SYMFONY__ENV__DATABASE_DRIVER=pdo_mysql
      - SYMFONY__ENV__DATABASE_HOST=db
      - SYMFONY__ENV__DATABASE_PORT=3306
      - SYMFONY__ENV__DATABASE_NAME=wallabag
      - SYMFONY__ENV__DATABASE_USER=wallabag
      - SYMFONY__ENV__DATABASE_PASSWORD=wallapass
      - SYMFONY__ENV__DATABASE_CHARSET=utf8mb4
      - SYMFONY__ENV__DOMAIN_NAME=http://192.168.178.50:8089
      - SYMFONY__ENV__SERVER_NAME="Your wallabag instance"
      - SYMFONY__ENV__FOSUSER_CONFIRMATION=false
      - SYMFONY__ENV__TWOFACTOR_AUTH=false
    ports:
      - "8089:80"
    volumes:
      - ./wallabag/images:/var/www/wallabag/web/assets/images

  db:
    image: mariadb
    environment:
      - MYSQL_ROOT_PASSWORD=wallaroot
    volumes:
      - ./mariadb:/var/lib/mysql
```
Weitere nützliche Docker-Images für den Heimgebrauch finden Sie im [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").


## Schritt 1: wallabag-Ordner vorbereiten
Ich erstelle ein neues Verzeichnis namens „wallabag“ im Docker-Verzeichnis.
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
TZ| Europe/Berlin	| Zeitzone
MYSQL_ROOT_PASSWORD	 | wallaroot | Masterpassword der Datenbank.
{{</table>}}

Siehe:
{{< gallery match="images/6/*.png" >}}

Nach diesen Einstellungen kann Mariadb-Server gestartet werden! Ich drücke überall auf „Übernehmen“.
{{< gallery match="images/7/*.png" >}}

## Schritt 3: Wallabag installieren
Ich klicke im Synology-Docker-Fenster auf den Reiter „Registrierung“ und suche nach „wallabag“. Ich wähle das Docker-Image „wallabag/wallabag“ aus und klicke anschließend auf den Tag „latest“.
{{< gallery match="images/8/*.png" >}}

Ich klicke per Doppelklick  auf mein wallabag-Abbild. Danach klicke ich auf "Erweiterte Einstellungen“ und aktiviere auch hier den „Automatischen Neustart".
{{< gallery match="images/9/*.png" >}}

Ich wähle den Reiter „Volumen“ und klicke auf „Ordner hinzufügen“. Dort erstelle ich einen neuen Ordner mit diesem Mount-Pfad „/var/www/wallabag/web/assets/images“.
{{< gallery match="images/10/*.png" >}}

Ich vergebe feste Ports für den „wallabag“ – Container. Ohne feste Ports könnte es sein, dass der „wallabag-Server“ nach einem Neustart auf einen anderen Port läuft. Der erste Container-Port kann gelöscht werden. Den anderen Port sollte man sich merken.
{{< gallery match="images/11/*.png" >}}

Außerdem muss noch ein „Link“ zum „mariadb“-Container erstellt werden. Ich klicke auf den „Links“-Reiter und wählen den Datenbank-Container aus. Den Aliasnamen sollte man sich für die wallabag-Installation gut merken.
{{< gallery match="images/12/*.png" >}}

Zum Schluss trage ich noch diese Umgebungsvariablen ein:
{{<table "table table-striped table-bordered">}}
Umgebungsvariable	| Wert
--- | --- 
MYSQL_ROOT_PASSWORD	| wallaroot
SYMFONY__ENV__DATABASE_DRIVER	| pdo_mysql
SYMFONY__ENV__DATABASE_HOST	| db
SYMFONY__ENV__DATABASE_PORT	| 3306
SYMFONY__ENV__DATABASE_NAME	| wallabag
SYMFONY__ENV__DATABASE_USER	| wallabag
SYMFONY__ENV__DATABASE_PASSWORD	| wallapass
SYMFONY__ENV__DATABASE_CHARSET | utf8mb4
SYMFONY__ENV__DOMAIN_NAME	| „http://synology-ip:container-port“ <- Bitte ändern
SYMFONY__ENV__SERVER_NAME	| „Wallabag – Server“
SYMFONY__ENV__FOSUSER_CONFIRMATION	| false
SYMFONY__ENV__TWOFACTOR_AUTH	| false
{{</table>}}

Siehe:
{{< gallery match="images/13/*.png" >}}

Der Container kann nun gestartet werden. Eventuell kann das Anlegen der Datenbank etwas dauern. Das verhalten lässt sich über die Container-Details beobachten.
{{< gallery match="images/14/*.png" >}}

Ich rufe den wallabag-Server mit der Synology-IP-Adresse und meinem Container–Port auf.
{{< gallery match="images/15/*.png" >}}

Ich muss aber sagen, dass ich persönlich shiori als Internet-Archiv bevorzuge.