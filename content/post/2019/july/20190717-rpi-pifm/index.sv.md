+++
date = "2019-07-17"
title = "PIFM: 104.6 Worldwide på FM-radio"
difficulty = "level-1"
tags = ["104.6rtl", "fm-streaming", "pi", "radio", "raspberry-pi"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-rpi-pifm/index.sv.md"
+++
Om du är ett 104.6 RTL-fan och inte vill tillbringa en dag utan Berlins hitradio, då är du på rätt plats. Du behöver en enkelbordsdator som kallas Raspberry och en kabel på GPIO-port 4 som antenn.
## Följande paket krävs

{{< terminal >}}
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install sox libsox-fmt-all

{{</ terminal >}}
Jag skapar en nedladdningsmapp och laddar ner PIFM-skriptet:
{{< terminal >}}
mkdir /home/pi/installs
cd /home/pi/installs/
wget http://omattos.com/pifm.tar.gz
tar vfzx pifm.tar.gz

{{</ terminal >}}

## pifm-skript
Jag skapar en ny fil "$vim /home/pi/radio-streamer.sh" med följande innehåll:
```
#!/bin/bash 
pkill sox 
pkill pifm 
sleep 1 

sox -v .9 -t mp3 http://stream.104.6rtl.com/rtl-live -t wav --input-buffer 80000 -r 22050 -c 1 - | sudo /home/pi/installs/pifm - 104.6

```
Skriptet behöver följande rättigheter:
{{< terminal >}}
sudo chmod 775 /home/pi/radio-streamer.sh

{{</ terminal >}}

## Möjligt crontjob
Datorn startas om varje natt mellan klockan 4 och 5. Dessutom återansluter Radion varje timme.
```
@reboot sleep 60 && sudo /home/pi/radio-streamer.sh 
36 4 * * * sudo pkill sox 
37 4 * * * sudo pkill pifm 
38 4 * * * sudo reboot 
59 * * * * sudo /home/pi/radio-streamer.sh

```