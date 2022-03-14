+++
date = "2019-07-17"
title = "PIFM: 104,6 na całym świecie w radiu FM"
difficulty = "level-1"
tags = ["104.6rtl", "fm-streaming", "pi", "radio", "raspberry-pi"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-rpi-pifm/index.pl.md"
+++
Jeśli jesteś fanem 104.6 RTL i nie chcesz spędzić dnia bez berlińskiego hitu radiowego, to jesteś we właściwym miejscu. Potrzebny jest komputer jednopłytkowy zwany Raspberry i kabel na porcie GPIO 4 jako antena.
## Wymagane są następujące pakiety

{{< terminal >}}
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install sox libsox-fmt-all

{{</ terminal >}}
Tworzę folder download i pobieram skrypt PIFM:
{{< terminal >}}
mkdir /home/pi/installs
cd /home/pi/installs/
wget http://omattos.com/pifm.tar.gz
tar vfzx pifm.tar.gz

{{</ terminal >}}

## skrypt pifm
Tworzę nowy plik "$vim /home/pi/radio-streamer.sh" z następującą zawartością:
```
#!/bin/bash 
pkill sox 
pkill pifm 
sleep 1 

sox -v .9 -t mp3 http://stream.104.6rtl.com/rtl-live -t wav --input-buffer 80000 -r 22050 -c 1 - | sudo /home/pi/installs/pifm - 104.6

```
Skrypt wymaga następujących uprawnień:
{{< terminal >}}
sudo chmod 775 /home/pi/radio-streamer.sh

{{</ terminal >}}

## Możliwe crontjob
Komputer jest restartowany każdej nocy między godziną 4 a 5. Ponadto Radion łączy się ponownie co godzinę.
```
@reboot sleep 60 && sudo /home/pi/radio-streamer.sh 
36 4 * * * sudo pkill sox 
37 4 * * * sudo pkill pifm 
38 4 * * * sudo reboot 
59 * * * * sudo /home/pi/radio-streamer.sh

```