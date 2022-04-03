+++
date = "2019-07-17"
title = "PIFM: 104,6 celosvetovo v rádiu FM"
difficulty = "level-1"
tags = ["104.6rtl", "fm-streaming", "pi", "radio", "raspberry-pi"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-rpi-pifm/index.sk.md"
+++
Ak ste fanúšikom stanice 104,6 RTL a nechcete stráviť ani deň bez berlínskeho hitového rádia, potom ste na správnom mieste. Potrebujete jednodoskový počítač s názvom Raspberry a kábel na porte GPIO 4 ako anténu.
## Vyžadujú sa tieto balíky

{{< terminal >}}
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install sox libsox-fmt-all

{{</ terminal >}}
Vytvorím priečinok na stiahnutie a stiahnem skript PIFM:
{{< terminal >}}
mkdir /home/pi/installs
cd /home/pi/installs/
wget http://omattos.com/pifm.tar.gz
tar vfzx pifm.tar.gz

{{</ terminal >}}

## skript pifm
Vytvorím nový súbor "$vim /home/pi/radio-streamer.sh" s nasledujúcim obsahom:
```
#!/bin/bash 
pkill sox 
pkill pifm 
sleep 1 

sox -v .9 -t mp3 http://stream.104.6rtl.com/rtl-live -t wav --input-buffer 80000 -r 22050 -c 1 - | sudo /home/pi/installs/pifm - 104.6

```
Skript potrebuje nasledujúce práva:
{{< terminal >}}
sudo chmod 775 /home/pi/radio-streamer.sh

{{</ terminal >}}

## Možný crontjob
Počítač sa reštartuje každú noc medzi 4. a 5. hodinou. Okrem toho sa zariadenie Radion každú hodinu znovu pripája.
```
@reboot sleep 60 && sudo /home/pi/radio-streamer.sh 
36 4 * * * sudo pkill sox 
37 4 * * * sudo pkill pifm 
38 4 * * * sudo reboot 
59 * * * * sudo /home/pi/radio-streamer.sh

```
