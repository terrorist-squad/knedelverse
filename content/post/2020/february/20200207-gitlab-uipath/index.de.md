+++
date = "2020-02-07"
title = "uiPath-Windows-Roboter mit Gitlab orchestrieren"
difficulty = "level-5"
tags = ["git", "gitlab", "robot", "roboter", "Robotic-Process-Automation", "rpa", "uipath", "windows"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2020/february/20200207-gitlab-uipath/index.de.md"
+++

UiPath ist ein etablierter Standard in der Robotic-Process-Automation. Mit uiPath können Sie einen software-basierenden Roboter/Bot entwickeln, der ihnen komplexe Datenverarbeitungs- bzw. Klick-Aufgaben abnimmt. Aber lässt sich so ein Roboter auch mit Gitlab steuern?

Kurze Antwort „Ja". Und wie genau sehen Sie hier. Für die folgenden Schritte benötigen Sie neben den Administrationsrechten auch etwas uiPath-, Windows- und Gitlab- Erfahrung.

## Schritt 1: Als erstes muss ein Gitlab-Runner installiert werden.
1.1.) Legen Sie einen neuen Gitlab-User für ihr Ziel-Betriebssytem an. Bitte klicken Sie auf „Einstellungen“ > „Familie und andere Benutzer“ und anschließend auf „Diesen PC eine andere Person hinzufügen".
{{< gallery match="images/1/*.png" >}}

1.2.) Bitte klicken Sie auf „Ich kenne die Anmeldeinformationen für diese Person nicht“ und danach auf „Benutzer ohne Microsoft-Konto hinzufügen„, um einen lokalen Benutzer zu erstellen.
{{< gallery match="images/2/*.png" >}}

1.3.) Im Folgedialog können Sie den Benutzernamen und das Passwort frei wählen:
{{< gallery match="images/3/*.png" >}}

## Schritt 2: Dienstanmeldung aktivieren
Wenn Sie für Ihren Windows-Gitlab-Runner einen separaten, lokalen Benutzer verwenden wollen, dann müssen die „Anmeldung als Dienst aktivieren". Dafür rufen Sie im Windows-Menü > „Lokale Sicherheitsrichtlinie“ auf. Dort wählen Sie auf der linken Seite „Lokale Richtlinien“ > „Zuweisen von Benutzerrechten“ und auf der rechten Seite „Anmelden als Dienst“.
{{< gallery match="images/4/*.png" >}}

Anschließen fügen Sie den neuen Nutzer hinzu.
{{< gallery match="images/5/*.png" >}}

## Schritt 3: Gitlab-Runner registrieren
Auf der folgenden Seite ist der Windows-Installer für den Gitlab-Runner zu finden: https://docs.gitlab.com/runner/install/windows.html . Ich habe mir einen neuen Ordner im „Laufwerk C“ erstellt und dort den Installer abgelegt.
{{< gallery match="images/6/*.png" >}}

3.1.) Ich nutze den Befehl „CMD“ als „Administrator“ um eine neue Konsole und wechsel in ein Verzeichnis „cd C:\gitlab-runner".
{{< gallery match="images/7/*.png" >}}

Dort rufe ich den folgenden Befehl auf. Wie man sehen kann, gebe ich hier auch den Nutzernamen und das Password des Gitlab-Nutzers an.
{{< terminal >}}
gitlab-runner-windows-386.exe install --user ".\gitlab" --password "*****"
{{</ terminal >}}

3.2.) Nun kann der Gitlab – Runner registriert werden. Sollten Sie ein selbstsigniertes Zertifikat für Ihre Gitlab-Installation nutzen, dann müssen Sie das Zertifikat mit dem Attribute „–tls-ca-file=“ mitgeben. Anschließend geben Sie die Gitlab-Url und den Regestrierungs-Token ein.
{{< gallery match="images/8/*.png" >}}

3.2.) Nach der erfolgreichen Regestrierung, kann der Runner mit dem Befehl „gitlab-runner-windows-386.exe start“ gestartet werden:
{{< gallery match="images/9/*.png" >}}

Großartig! Ihr Gitlab-Runner läuft und ist nun Nutzbar.
{{< gallery match="images/10/*.png" >}}

## Schritt 4: Git installieren
Da ein Gitlab-Runner mit der Git-Versionierung arbeitet muss auch Git für Windows installiert werden:
{{< gallery match="images/11/*.png" >}}

## Schritt 5: UiPath installieren
Die UiPath-Installation ist das Einfachste an diesem Tutorial. Melden Sie sich als Gitlab-Nutzer an und installieren Sie die Community-Edition. Sie können natürlich gleich all die Software installieren, die Ihr Roboter benötigt, zum Beispiel: Office 365.
{{< gallery match="images/12/*.png" >}}

## Schritt 6: Gitlab Projekt und Pipeline erstellen
Nun kommt das große Finale dieses Tutorials. Ich erstelle ein neues Gitlab-Projekt und checke meine uiPath-Projektdateien ein.
{{< gallery match="images/13/*.png" >}}

6.1.) Zusätzlich erzeuge ich eine neue Datei ".gitlab-ci.yml“ mit folgendem Inhalt:
```
build1:
  stage: build
  variables:
    GIT_STRATEGY: clone
  script:
    - C:\Users\gitlab\AppData\Local\UiPath\app-20.10.0-beta0149\UiRobot.exe -file "${CI_PROJECT_DIR}\Main.xaml"
```

Mein Windows-Software-Roboter wird direkt nach dem Commit in den Master-Branch ausgeführt:
{{< gallery match="images/14/*.png" >}}


Über die Option „Schedules“ kann das automatische Starten des Roboters verwaltet werden. Ein großer Vorteil dieser Kombination ist, dass sich die „Robotic“-Projekte sowie Projekt-Ergebnisse (artifacts) durch Gitlab zentral mit anderen „nicht Robotic“- Projekten steuern, versionieren und verwalten lassen.
