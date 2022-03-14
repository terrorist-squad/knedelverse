+++
date = "2019-07-17"
title = "PIFM: 104.6 Weltweit im FM-Radio"
difficulty = "level-1"
tags = ["104.6rtl", "fm-streaming", "pi", "radio", "raspberry-pi"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-rpi-pifm/index.de.md"
+++

Wenn Sie ein 104.6 RTL-Fan sind und keinen Tag ohne Berlins Hitradio verbringen wollen, dann sind Sie hier richtig. Man benötigt einen Einplatinen-Computer namens Raspberry und ein Kabel am GPIO-Port 4 als Antenne. 

## Folgende Pakete werden benötigt
{{< terminal >}}
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install sox libsox-fmt-all
{{</ terminal >}}

Ich lege einen Download-Ordner an und downloade das PIFM-Script: 
{{< terminal >}}
mkdir /home/pi/installs
cd /home/pi/installs/
wget http://omattos.com/pifm.tar.gz
tar vfzx pifm.tar.gz
{{</ terminal >}}

## pifm-Script
Ich erstelle einen neue Datei „$vim /home/pi/radio-streamer.sh“ mit folgendem Inhalt: 
```
#!/bin/bash 
pkill sox 
pkill pifm 
sleep 1 

sox -v .9 -t mp3 http://stream.104.6rtl.com/rtl-live -t wav --input-buffer 80000 -r 22050 -c 1 - | sudo /home/pi/installs/pifm - 104.6
```

Das Script braucht die folgenden Rechte: 
{{< terminal >}}
sudo chmod 775 /home/pi/radio-streamer.sh
{{</ terminal >}}

## Möglicher Crontjob
Der Rechner wird jede Nacht zwischen 4 und 5 Uhr durchgestartet. Zusätzlich Connected sich das Radion jede Stunde neu. 
```
@reboot sleep 60 && sudo /home/pi/radio-streamer.sh 
36 4 * * * sudo pkill sox 
37 4 * * * sudo pkill pifm 
38 4 * * * sudo reboot 
59 * * * * sudo /home/pi/radio-streamer.sh
```