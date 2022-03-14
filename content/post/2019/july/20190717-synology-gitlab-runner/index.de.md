+++
date = "2019-07-17"
title = "Synology-Nas: Gitlab – Runner im Docker-Container"
difficulty = "level-4"
tags = ["Docker", "git", "gitlab", "gitlab-runner", "raspberry-pi"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2019/july/20190717-synology-gitlab-runner/index.de.md"
+++

Wie installiere ich einen Gitlab – Runner als Docker -Container auf meinen Synology-Nas?

## Schritt 1: Docker-Image suchen
Ich klicke im Synology-Docker-Fenster auf den Reiter „Registrierung“ und suche nach Gitlab. Ich wähle das Docker-Image „gitlab/gitlab-runner“ und wähle anschließend den Tag „bleeding“ 
{{< gallery match="images/1/*.png" >}}

## Schritt 2: Image/Abbild in Betrieb nehmen:
### Hosts-Problem
Meine Synology-Gitlab-insterlation weist sich selbst immer nur über den Hostname aus. Da ich das Original Synology-Gitlab-Paket aus dem Paket-Zentrum genommen habe, lässt sich dieses Verhalten in Nachhinein nicht ändern.  Als Workaround kann ich eine eigene Hosts-Datei einbinden. Hier ist zusehen das der Hostname „peter“ zur Nas-IP-Adresse 192.168.12.42 gehört. 

```
127.0.0.1       localhost                                                       
::1     localhost ip6-localhost ip6-loopback                                    
fe00::0 ip6-localnet                                                            
ff00::0 ip6-mcastprefix                                                         
ff02::1 ip6-allnodes                                                            
ff02::2 ip6-allrouters               
192.168.12.42 peter
```

Diese Datei wird einfach auf dem Synology-Nas abgelegt. 
{{< gallery match="images/2/*.png" >}}

## Schritt 3: GitLab-Runner einrichten
Ich klicke auf mein Runner-Abbild: 
{{< gallery match="images/3/*.png" >}}

Ich aktiviere die Einstellung „Automatischen Neustart aktivieren“:
{{< gallery match="images/4/*.png" >}}

Danach klicke ich auf „Erweiterte Einstellungen“ und wähle den Reiter „Volumen“: 
{{< gallery match="images/5/*.png" >}}

Ich klicke auf Datei hinzufügen und binde meine Hosts-Datei über den Pfad „/etc/hosts“ ein. Dieser Schritt ist nur notwendig, wenn sich der Hostnames nicht auflösen lässt. 
{{< gallery match="images/6/*.png" >}}

Ich übernehme die Einstellungen und klicke auf weiter
{{< gallery match="images/7/*.png" >}}

Nun finde ich das initialisierte Image unter Container:
{{< gallery match="images/8/*.png" >}}

Ich wähle den Container (gitlab-gitlab-runner2 bei mir) und klicke auf „Details". Danach klicke ich auf den Reiter „Terminal“ und erstelle eine neue Bash-Session. Hier gebe ich den Befehl „gitlab-runner register“ ein. Für das Registrieren benötige ich Informationen, die ich in meine GitLab-Installation unter http://gitlab-adresse:port/admin/runners finde.   
{{< gallery match="images/9/*.png" >}}

Wenn Sie noch weitere Pakete benötigen, dann können Sie diese über „apt-get update“ und anschließenden „apt-get install python …“ installieren. 
{{< gallery match="images/10/*.png" >}}

Danach kann ich den Runner in meinem Projekte aufnehmen und verwenden: 
{{< gallery match="images/11/*.png" >}}