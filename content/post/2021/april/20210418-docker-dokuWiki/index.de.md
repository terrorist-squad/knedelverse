+++
date = "2021-04-18"
title = "Großartiges mit Containern: Eigenes dokuWiki auf der Synology-Diskstation installieren"
difficulty = "level-2"
tags = ["diskstation", "Docker", "docker-compose", "Synology", "dokuwiki", "wiki"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2021/april/20210418-docker-dokuWiki/index.de.md"
+++

DokuWiki ist eine standardkonforme, einfach zu verwendende und zugleich äußerst vielseitige Open Source Wiki-Software. Heute zeige ich, wie man einen dokuWiki-Dienst auf der Synology-Diskstation installiert.

## Option für Profis
Als erfahrener Synology-Nutzer kann man sich natürlich gleich mit SSH einloggen und das ganze Setup via Docker-Compose-Datei installieren.
```
version: '3'
services:
  dokuwiki:
    image:  bitnami/dokuwiki:latest
    restart: always
    ports:
      - 8080:8080
      - 8443:8443
    environment:
      TZ: 'Europe/Berlin'
      DOKUWIKI_USERNAME: 'admin'
      DOKUWIKI_FULL_NAME: 'wiki'
      DOKUWIKI_PASSWORD: 'password'
    volumes:
      - ./data:/bitnami/dokuwiki
```
Weitere nützliche Docker-Images für den Heimgebrauch finden Sie im [Dockerverse]({{< ref "dockerverse" >}} "Dockerverse").

## Schritt 1: Wiki-Ordner vorbereiten
Ich erstelle ein neues Verzeichnis namens „wiki“ im Docker-Verzeichnis.
{{< gallery match="images/1/*.png" >}}

## Schritt 2: DokuWiki installieren
Danach muss eine Datenbank erstellt werden. Ich klicke im Synology-Docker-Fenster auf den Reiter „Registrierung“ und suche nach „dokuwiki“. Ich wähle das Docker-Image „bitnami/dokuwiki“ und klicke anschließend auf den Tag „latest“.
{{< gallery match="images/2/*.png" >}}

Nach dem Image – Download liegt das Image als Abbild bereit. Docker unterscheide zwischen 2 Zuständen, Container „Dynamisch zustand“ und Image/Abbild (Festzustand). Bevor wir nun einen Container aus dem Abbild erzeugen, müssen noch ein paar Einstellungen getätigt werden.

Ich klicke per Doppelklick  auf mein dokuwiki-Abbild.
{{< gallery match="images/3/*.png" >}}

Ich vergebe feste Ports für den „dokuwiki“ – Container. Ohne feste Ports könnte es sein, dass der „dokuwiki-Server“ nach einem Neustart auf einen anderen Port läuft.
{{< gallery match="images/4/*.png" >}}

Zum Schluss trage ich noch diese Umgebungsvariablen ein:
{{<table "table table-striped table-bordered">}}
Variablenname |	Wert | Was ist das?
--- | --- | ---
TZ	| Europe/Berlin	| Zeitzone
DOKUWIKI_USERNAME	| admin|	Admin-Nutzername
DOKUWIKI_FULL_NAME |	wiki	| WIki-Name
DOKUWIKI_PASSWORD	| password	| Admin-Password
{{</table>}}

Siehe:
{{< gallery match="images/5/*.png" >}}

Der Container kann nun gestartet werden. Ich rufe den dokuWIki-Server mit der Synology-IP-Adresse und meinem Container–Port auf.
{{< gallery match="images/6/*.png" >}}


