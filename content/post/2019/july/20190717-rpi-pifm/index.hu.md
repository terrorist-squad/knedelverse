+++
date = "2019-07-17"
title = "PIFM: 104,6 világszerte az FM rádióban"
difficulty = "level-1"
tags = ["104.6rtl", "fm-streaming", "pi", "radio", "raspberry-pi"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-rpi-pifm/index.hu.md"
+++
Ha a 104.6 RTL rajongója vagy, és egy napot sem szeretnél Berlin slágerrádiója nélkül tölteni, akkor jó helyen jársz. Szükséged lesz egy Raspberry nevű egylapos számítógépre és egy kábelre a GPIO 4-es porton, mint antenna.
## A következő csomagok szükségesek

{{< terminal >}}
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install sox libsox-fmt-all

{{</ terminal >}}
Létrehozok egy letöltési mappát, és letöltöm a PIFM szkriptet:
{{< terminal >}}
mkdir /home/pi/installs
cd /home/pi/installs/
wget http://omattos.com/pifm.tar.gz
tar vfzx pifm.tar.gz

{{</ terminal >}}

## pifm script
Létrehozok egy új fájlt "$vim /home/pi/radio-streamer.sh" a következő tartalommal:
```
#!/bin/bash 
pkill sox 
pkill pifm 
sleep 1 

sox -v .9 -t mp3 http://stream.104.6rtl.com/rtl-live -t wav --input-buffer 80000 -r 22050 -c 1 - | sudo /home/pi/installs/pifm - 104.6

```
A szkriptnek a következő jogokra van szüksége:
{{< terminal >}}
sudo chmod 775 /home/pi/radio-streamer.sh

{{</ terminal >}}

## Lehetséges crontjob
A számítógép minden este 4 és 5 óra között újraindul. Ezenkívül a Radion óránként újracsatlakozik.
```
@reboot sleep 60 && sudo /home/pi/radio-streamer.sh 
36 4 * * * sudo pkill sox 
37 4 * * * sudo pkill pifm 
38 4 * * * sudo reboot 
59 * * * * sudo /home/pi/radio-streamer.sh

```