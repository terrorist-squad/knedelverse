+++
date = "2019-07-17"
title = "PIFM: 104.6 în toată lumea la Radio FM"
difficulty = "level-1"
tags = ["104.6rtl", "fm-streaming", "pi", "radio", "raspberry-pi"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2019/july/20190717-rpi-pifm/index.ro.md"
+++
Dacă sunteți un fan al 104.6 RTL și nu vreți să petreceți nici măcar o zi fără radioul de succes al Berlinului, atunci vă aflați în locul potrivit. Aveți nevoie de un computer cu o singură placă numit Raspberry și de un cablu pe portul GPIO 4 ca antenă.
## Sunt necesare următoarele pachete

{{< terminal >}}
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install sox libsox-fmt-all

{{</ terminal >}}
Creez un dosar de descărcare și descarc scriptul PIFM:
{{< terminal >}}
mkdir /home/pi/installs
cd /home/pi/installs/
wget http://omattos.com/pifm.tar.gz
tar vfzx pifm.tar.gz

{{</ terminal >}}

## script pifm
Creez un nou fișier "$vim /home/pi/radio-streamer.sh" cu următorul conținut:
```
#!/bin/bash 
pkill sox 
pkill pifm 
sleep 1 

sox -v .9 -t mp3 http://stream.104.6rtl.com/rtl-live -t wav --input-buffer 80000 -r 22050 -c 1 - | sudo /home/pi/installs/pifm - 104.6

```
Scriptul are nevoie de următoarele drepturi:
{{< terminal >}}
sudo chmod 775 /home/pi/radio-streamer.sh

{{</ terminal >}}

## Posibil crontjob
Calculatorul este repornit în fiecare noapte între orele 4 și 5. În plus, Radion se reconectează la fiecare oră.
```
@reboot sleep 60 && sudo /home/pi/radio-streamer.sh 
36 4 * * * sudo pkill sox 
37 4 * * * sudo pkill pifm 
38 4 * * * sudo reboot 
59 * * * * sudo /home/pi/radio-streamer.sh

```