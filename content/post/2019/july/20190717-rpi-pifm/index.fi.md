+++
date = "2019-07-17"
title = "PIFM: 104,6 maailmanlaajuisesti FM-radioasemalla"
difficulty = "level-1"
tags = ["104.6rtl", "fm-streaming", "pi", "radio", "raspberry-pi"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-rpi-pifm/index.fi.md"
+++
Jos olet 104.6 RTL:n fani etkä halua viettää päivääkään ilman Berliinin hittiradiota, olet oikeassa paikassa. Tarvitset yhden piirilevyn tietokoneen nimeltä Raspberry ja GPIO-porttiin 4 liitettävän kaapelin antenniksi.
## Tarvitaan seuraavat paketit

{{< terminal >}}
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install sox libsox-fmt-all

{{</ terminal >}}
Luon latauskansion ja lataan PIFM-skriptin:
{{< terminal >}}
mkdir /home/pi/installs
cd /home/pi/installs/
wget http://omattos.com/pifm.tar.gz
tar vfzx pifm.tar.gz

{{</ terminal >}}

## pifm-käsikirjoitus
Luon uuden tiedoston "$vim /home/pi/radio-streamer.sh", jonka sisältö on seuraava:
```
#!/bin/bash 
pkill sox 
pkill pifm 
sleep 1 

sox -v .9 -t mp3 http://stream.104.6rtl.com/rtl-live -t wav --input-buffer 80000 -r 22050 -c 1 - | sudo /home/pi/installs/pifm - 104.6

```
Käsikirjoitus tarvitsee seuraavat oikeudet:
{{< terminal >}}
sudo chmod 775 /home/pi/radio-streamer.sh

{{</ terminal >}}

## Mahdollinen crontjob
Tietokone käynnistetään uudelleen joka yö kello 4 ja 5 välillä. Lisäksi Radion kytkeytyy uudelleen tunnin välein.
```
@reboot sleep 60 && sudo /home/pi/radio-streamer.sh 
36 4 * * * sudo pkill sox 
37 4 * * * sudo pkill pifm 
38 4 * * * sudo reboot 
59 * * * * sudo /home/pi/radio-streamer.sh

```
