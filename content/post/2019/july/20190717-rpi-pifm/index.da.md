+++
date = "2019-07-17"
title = "PIFM: 104,6 på verdensplan på FM-radio"
difficulty = "level-1"
tags = ["104.6rtl", "fm-streaming", "pi", "radio", "raspberry-pi"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2019/july/20190717-rpi-pifm/index.da.md"
+++
Hvis du er en 104.6 RTL-fan og ikke ønsker at tilbringe en dag uden Berlins hitradio, så er du kommet til det rette sted. Du skal bruge en singleboard-computer kaldet en Raspberry og et kabel på GPIO-port 4 som antenne.
## Følgende pakker er påkrævet

{{< terminal >}}
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install sox libsox-fmt-all

{{</ terminal >}}
Jeg opretter en download-mappe og downloader PIFM-scriptet:
{{< terminal >}}
mkdir /home/pi/installs
cd /home/pi/installs/
wget http://omattos.com/pifm.tar.gz
tar vfzx pifm.tar.gz

{{</ terminal >}}

## pifm-skrift
Jeg opretter en ny fil "$vim /home/pi/radio-streamer.sh" med følgende indhold:
```
#!/bin/bash 
pkill sox 
pkill pifm 
sleep 1 

sox -v .9 -t mp3 http://stream.104.6rtl.com/rtl-live -t wav --input-buffer 80000 -r 22050 -c 1 - | sudo /home/pi/installs/pifm - 104.6

```
Scriptet skal have følgende rettigheder:
{{< terminal >}}
sudo chmod 775 /home/pi/radio-streamer.sh

{{</ terminal >}}

## Muligt crontjob
Computeren genstartes hver nat mellem kl. 4 og 5. Desuden genopretter Radion forbindelsen hver time.
```
@reboot sleep 60 && sudo /home/pi/radio-streamer.sh 
36 4 * * * sudo pkill sox 
37 4 * * * sudo pkill pifm 
38 4 * * * sudo reboot 
59 * * * * sudo /home/pi/radio-streamer.sh

```