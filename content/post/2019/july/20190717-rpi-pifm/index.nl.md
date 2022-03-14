+++
date = "2019-07-17"
title = "PIFM: 104.6 Wereldwijd op FM Radio"
difficulty = "level-1"
tags = ["104.6rtl", "fm-streaming", "pi", "radio", "raspberry-pi"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-rpi-pifm/index.nl.md"
+++
Als je een fan bent van 104.6 RTL en geen dag zonder de Berlijnse hitradio wilt, dan ben je hier op de juiste plaats. Je hebt een single-board computer nodig, een Raspberry genaamd, en een kabel op GPIO poort 4 als antenne.
## De volgende pakketten zijn vereist

{{< terminal >}}
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install sox libsox-fmt-all

{{</ terminal >}}
Ik maak een download map aan en download het PIFM script:
{{< terminal >}}
mkdir /home/pi/installs
cd /home/pi/installs/
wget http://omattos.com/pifm.tar.gz
tar vfzx pifm.tar.gz

{{</ terminal >}}

## pifm-script
Ik maak een nieuw bestand aan "$vim /home/pi/radio-streamer.sh" met de volgende inhoud:
```
#!/bin/bash 
pkill sox 
pkill pifm 
sleep 1 

sox -v .9 -t mp3 http://stream.104.6rtl.com/rtl-live -t wav --input-buffer 80000 -r 22050 -c 1 - | sudo /home/pi/installs/pifm - 104.6

```
Het script heeft de volgende rechten nodig:
{{< terminal >}}
sudo chmod 775 /home/pi/radio-streamer.sh

{{</ terminal >}}

## Mogelijke crontjob
De computer wordt elke nacht tussen 4 en 5 uur opnieuw opgestart. Bovendien maakt de Radion elk uur opnieuw verbinding.
```
@reboot sleep 60 && sudo /home/pi/radio-streamer.sh 
36 4 * * * sudo pkill sox 
37 4 * * * sudo pkill pifm 
38 4 * * * sudo reboot 
59 * * * * sudo /home/pi/radio-streamer.sh

```