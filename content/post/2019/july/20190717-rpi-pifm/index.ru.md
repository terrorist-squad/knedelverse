+++
date = "2019-07-17"
title = "ПИФМ: 104,6 по всему миру на FM-радио"
difficulty = "level-1"
tags = ["104.6rtl", "fm-streaming", "pi", "radio", "raspberry-pi"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-rpi-pifm/index.ru.md"
+++
Если вы являетесь поклонником 104.6 RTL и не хотите ни дня провести без берлинского хита радио, то вы попали по адресу. Вам понадобится одноплатный компьютер под названием Raspberry и кабель на порту GPIO 4 в качестве антенны.
## Необходимы следующие пакеты

{{< terminal >}}
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install sox libsox-fmt-all

{{</ terminal >}}
Я создаю папку загрузки и загружаю скрипт PIFM:
{{< terminal >}}
mkdir /home/pi/installs
cd /home/pi/installs/
wget http://omattos.com/pifm.tar.gz
tar vfzx pifm.tar.gz

{{</ terminal >}}

## сценарий pifm
Я создаю новый файл "$vim /home/pi/radio-streamer.sh" со следующим содержимым:
```
#!/bin/bash 
pkill sox 
pkill pifm 
sleep 1 

sox -v .9 -t mp3 http://stream.104.6rtl.com/rtl-live -t wav --input-buffer 80000 -r 22050 -c 1 - | sudo /home/pi/installs/pifm - 104.6

```
Сценарию необходимы следующие права:
{{< terminal >}}
sudo chmod 775 /home/pi/radio-streamer.sh

{{</ terminal >}}

## Возможный crontjob
Компьютер перезагружается каждую ночь между 4 и 5 часами. Кроме того, "Радион" переподключается каждый час.
```
@reboot sleep 60 && sudo /home/pi/radio-streamer.sh 
36 4 * * * sudo pkill sox 
37 4 * * * sudo pkill pifm 
38 4 * * * sudo reboot 
59 * * * * sudo /home/pi/radio-streamer.sh

```
