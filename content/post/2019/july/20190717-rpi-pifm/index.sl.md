+++
date = "2019-07-17"
title = "PIFM: 104,6 po vsem svetu na radiu FM"
difficulty = "level-1"
tags = ["104.6rtl", "fm-streaming", "pi", "radio", "raspberry-pi"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2019/july/20190717-rpi-pifm/index.sl.md"
+++
Če ste oboževalec 104,6 RTL in ne želite preživeti dneva brez berlinskega radijskega hita, potem ste na pravem mestu. Potrebujete računalnik z eno ploščo, imenovan Raspberry, in kabel na vratih GPIO 4 kot anteno.
## Potrebni so naslednji paketi

{{< terminal >}}
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install sox libsox-fmt-all

{{</ terminal >}}
Ustvarim mapo za prenos in prenesem skripto PIFM:
{{< terminal >}}
mkdir /home/pi/installs
cd /home/pi/installs/
wget http://omattos.com/pifm.tar.gz
tar vfzx pifm.tar.gz

{{</ terminal >}}

## skripta pifm
Ustvarim novo datoteko "$vim /home/pi/radio-streamer.sh" z naslednjo vsebino:
```
#!/bin/bash 
pkill sox 
pkill pifm 
sleep 1 

sox -v .9 -t mp3 http://stream.104.6rtl.com/rtl-live -t wav --input-buffer 80000 -r 22050 -c 1 - | sudo /home/pi/installs/pifm - 104.6

```
Skripta potrebuje naslednje pravice:
{{< terminal >}}
sudo chmod 775 /home/pi/radio-streamer.sh

{{</ terminal >}}

## Možno crontjob
Računalnik se ponovno zažene vsako noč med 4. in 5. uro. Poleg tega se naprava Radion vsako uro ponovno poveže.
```
@reboot sleep 60 && sudo /home/pi/radio-streamer.sh 
36 4 * * * sudo pkill sox 
37 4 * * * sudo pkill pifm 
38 4 * * * sudo reboot 
59 * * * * sudo /home/pi/radio-streamer.sh

```