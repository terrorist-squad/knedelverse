+++
date = "2021-04-25T09:28:11+01:00"
title = "BitwardenRS auf der Synology-Diskstation"
difficulty = "level-2"
tags = ["bitwardenrs", "Docker", "docker-compose", "password-manager", "passwort", "Synology"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2021/april/20210425-docker-BitwardenRS/index.de.md"
+++

Bitwarden ist ein kostenloser Open-Source-Dienst zur Kennwortverwaltung, der vertrauliche Informationen wie Website-Anmeldeinformationen in einem verschlüsselten Tresor speichert. Heute zeige ich, wie man einen BitwardenRS auf der Synology-Diskstation installiert.

## Schritt 1: BitwardenRS-Ordner vorbereiten
Ich erstelle ein neues Verzeichnis namens „bitwarden“ im Docker-Verzeichnis.
{{< gallery match="images/1/*.png" >}}

## Schritt 2: BitwardenRS installieren
Ich klicke im Synology-Docker-Fenster auf den Reiter „Registrierung“ und suche nach „bitwarden“. Ich wähle das Docker-Image „bitwardenrs/server“ aus und klicke anschließend auf den Tag „latest“.
{{< gallery match="images/2/*.png" >}}

Ich klicke per Doppelklick  auf mein bitwardenrs-Abbild. Danach klicke ich auf „Erweiterte Einstellungen“ und aktiviere auch hier den „Automatischen Neustart".
{{< gallery match="images/3/*.png" >}}

Ich wähle den Reiter „Volumen“ und klicke auf „Ordner hinzufügen“. Dort erstelle ich einen neuen Ordner mit diesem Mount-Pfad „/data“.
{{< gallery match="images/4/*.png" >}}

Ich vergebe feste Ports für den „bitwardenrs“ – Container. Ohne feste Ports könnte es sein, dass der „bitwardenrs-Server“ nach einem Neustart auf einen anderen Port läuft. Der erste Container-Port kann gelöscht werden. Den anderen Port sollte man sich merken.
{{< gallery match="images/5/*.png" >}}

Der Container kann nun gestartet werden. Ich rufe den bitwardenrs-Server mit der Synology-IP-Adresse und meinem Container–Port 8084 auf.
{{< gallery match="images/6/*.png" >}}


## Schritt 3: HTTPS einrichten
Ich klicke auf „Systemsteuerung“ > „Reverse Proxy“ und „Erstellen“.
{{< gallery match="images/7/*.png" >}}

Danach kann ich den bitwardenrs-Server mit der Synology-IP-Adresse und meinem Proxy–Port 8085, verschlüsselt aufrufen.
{{< gallery match="images/8/*.png" >}}