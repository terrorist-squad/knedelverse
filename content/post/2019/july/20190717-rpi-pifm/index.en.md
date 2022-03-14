+++
date = "2019-07-17"
title = "PIFM: 104.6 Worldwide on FM Radio"
difficulty = "level-1"
tags = ["104.6rtl", "fm-streaming", "pi", "radio", "raspberry-pi"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2019/july/20190717-rpi-pifm/index.en.md"
+++
If you are a 104.6 RTL fan and don't want to spend a day without Berlin's hit radio, then you are in the right place. You need a single board computer called Raspberry and a cable on GPIO port 4 as antenna.
## The following packages are required

{{< terminal >}}
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install sox libsox-fmt-all

{{</ terminal >}}
I create a download folder and download the PIFM script:
{{< terminal >}}
mkdir /home/pi/installs
cd /home/pi/installs/
wget http://omattos.com/pifm.tar.gz
tar vfzx pifm.tar.gz

{{</ terminal >}}

## pifm script
I create a new file "$vim /home/pi/radio-streamer.sh" with the following content:
```
#!/bin/bash 
pkill sox 
pkill pifm 
sleep 1 

sox -v .9 -t mp3 http://stream.104.6rtl.com/rtl-live -t wav --input-buffer 80000 -r 22050 -c 1 - | sudo /home/pi/installs/pifm - 104.6

```
The script needs the following permissions:
{{< terminal >}}
sudo chmod 775 /home/pi/radio-streamer.sh

{{</ terminal >}}

## Possible crontjob
The computer is started every night between 4 and 5 o'clock. In addition, the Radion reconnects every hour.
```
@reboot sleep 60 && sudo /home/pi/radio-streamer.sh 
36 4 * * * sudo pkill sox 
37 4 * * * sudo pkill pifm 
38 4 * * * sudo reboot 
59 * * * * sudo /home/pi/radio-streamer.sh

```