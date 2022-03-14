+++
date = "2019-07-17"
title = "PIFM: 104,6 celosvětově na FM rádiu"
difficulty = "level-1"
tags = ["104.6rtl", "fm-streaming", "pi", "radio", "raspberry-pi"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-rpi-pifm/index.cs.md"
+++
Pokud jste fanoušky stanice 104,6 RTL a nechcete strávit ani den bez berlínského hitového rádia, pak jste na správném místě. Potřebujete jednodeskový počítač Raspberry a kabel na portu GPIO 4 jako anténu.
## Jsou vyžadovány následující balíčky

{{< terminal >}}
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install sox libsox-fmt-all

{{</ terminal >}}
Vytvořím složku ke stažení a stáhnu skript PIFM:
{{< terminal >}}
mkdir /home/pi/installs
cd /home/pi/installs/
wget http://omattos.com/pifm.tar.gz
tar vfzx pifm.tar.gz

{{</ terminal >}}

## skript pifm
Vytvořím nový soubor "$vim /home/pi/radio-streamer.sh" s následujícím obsahem:
```
#!/bin/bash 
pkill sox 
pkill pifm 
sleep 1 

sox -v .9 -t mp3 http://stream.104.6rtl.com/rtl-live -t wav --input-buffer 80000 -r 22050 -c 1 - | sudo /home/pi/installs/pifm - 104.6

```
Skript potřebuje následující práva:
{{< terminal >}}
sudo chmod 775 /home/pi/radio-streamer.sh

{{</ terminal >}}

## Možný crontjob
Počítač se restartuje každou noc mezi 4. a 5. hodinou. Kromě toho se Radion každou hodinu znovu připojuje.
```
@reboot sleep 60 && sudo /home/pi/radio-streamer.sh 
36 4 * * * sudo pkill sox 
37 4 * * * sudo pkill pifm 
38 4 * * * sudo reboot 
59 * * * * sudo /home/pi/radio-streamer.sh

```