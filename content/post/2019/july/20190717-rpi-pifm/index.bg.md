+++
date = "2019-07-17"
title = "PIFM: 104.6 в целия свят по FM радио"
difficulty = "level-1"
tags = ["104.6rtl", "fm-streaming", "pi", "radio", "raspberry-pi"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2019/july/20190717-rpi-pifm/index.bg.md"
+++
Ако сте фен на 104.6 RTL и не искате да прекарате и ден без хитовото берлинско радио, значи сте на правилното място. Нуждаете се от едноплатков компютър, наречен Raspberry, и кабел на GPIO порт 4 като антена.
## Необходими са следните пакети

{{< terminal >}}
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install sox libsox-fmt-all

{{</ terminal >}}
Създавам папка за изтегляне и изтеглям скрипта PIFM:
{{< terminal >}}
mkdir /home/pi/installs
cd /home/pi/installs/
wget http://omattos.com/pifm.tar.gz
tar vfzx pifm.tar.gz

{{</ terminal >}}

## скрипт на pifm
Създавам нов файл "$vim /home/pi/radio-streamer.sh" със следното съдържание:
```
#!/bin/bash 
pkill sox 
pkill pifm 
sleep 1 

sox -v .9 -t mp3 http://stream.104.6rtl.com/rtl-live -t wav --input-buffer 80000 -r 22050 -c 1 - | sudo /home/pi/installs/pifm - 104.6

```
Скриптът се нуждае от следните права:
{{< terminal >}}
sudo chmod 775 /home/pi/radio-streamer.sh

{{</ terminal >}}

## Възможна crontjob
Компютърът се рестартира всяка вечер между 4 и 5 часа. Освен това Radion се свързва отново на всеки час.
```
@reboot sleep 60 && sudo /home/pi/radio-streamer.sh 
36 4 * * * sudo pkill sox 
37 4 * * * sudo pkill pifm 
38 4 * * * sudo reboot 
59 * * * * sudo /home/pi/radio-streamer.sh

```