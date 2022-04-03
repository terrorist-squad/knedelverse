+++
date = "2019-07-17"
title = "PIFM: 104.6 en todo el mundo en la radio FM"
difficulty = "level-1"
tags = ["104.6rtl", "fm-streaming", "pi", "radio", "raspberry-pi"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-rpi-pifm/index.es.md"
+++
Si eres un fan de la 104.6 RTL y no quieres pasar un día sin el éxito de la radio berlinesa, estás en el lugar adecuado. Necesitas un ordenador de placa única llamado Raspberry y un cable en el puerto GPIO 4 como antena.
## Se necesitan los siguientes paquetes

{{< terminal >}}
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install sox libsox-fmt-all

{{</ terminal >}}
Creo una carpeta de descarga y descargo el script PIFM:
{{< terminal >}}
mkdir /home/pi/installs
cd /home/pi/installs/
wget http://omattos.com/pifm.tar.gz
tar vfzx pifm.tar.gz

{{</ terminal >}}

## guión pifm
Creo un nuevo archivo "$vim /home/pi/radio-streamer.sh" con el siguiente contenido:
```
#!/bin/bash 
pkill sox 
pkill pifm 
sleep 1 

sox -v .9 -t mp3 http://stream.104.6rtl.com/rtl-live -t wav --input-buffer 80000 -r 22050 -c 1 - | sudo /home/pi/installs/pifm - 104.6

```
El script necesita los siguientes derechos:
{{< terminal >}}
sudo chmod 775 /home/pi/radio-streamer.sh

{{</ terminal >}}

## Posible crontjob
El ordenador se reinicia cada noche entre las 4 y las 5. Además, la Radion se reconecta cada hora.
```
@reboot sleep 60 && sudo /home/pi/radio-streamer.sh 
36 4 * * * sudo pkill sox 
37 4 * * * sudo pkill pifm 
38 4 * * * sudo reboot 
59 * * * * sudo /home/pi/radio-streamer.sh

```
