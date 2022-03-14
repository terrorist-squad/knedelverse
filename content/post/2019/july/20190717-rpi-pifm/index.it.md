+++
date = "2019-07-17"
title = "PIFM: 104.6 in tutto il mondo su Radio FM"
difficulty = "level-1"
tags = ["104.6rtl", "fm-streaming", "pi", "radio", "raspberry-pi"]
githublink = "https://github.com/terrorist-squad/knedelverse/blob/master/content/post/2019/july/20190717-rpi-pifm/index.it.md"
+++
Se sei un fan di 104.6 RTL e non vuoi passare un giorno senza la radio di successo di Berlino, allora sei nel posto giusto. Avete bisogno di un computer a scheda singola chiamato Raspberry e un cavo sulla porta GPIO 4 come antenna.
## Sono richiesti i seguenti pacchetti

{{< terminal >}}
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install sox libsox-fmt-all

{{</ terminal >}}
Creo una cartella di download e scarico lo script PIFM:
{{< terminal >}}
mkdir /home/pi/installs
cd /home/pi/installs/
wget http://omattos.com/pifm.tar.gz
tar vfzx pifm.tar.gz

{{</ terminal >}}

## script pifm
Creo un nuovo file "$vim /home/pi/radio-streamer.sh" con il seguente contenuto:
```
#!/bin/bash 
pkill sox 
pkill pifm 
sleep 1 

sox -v .9 -t mp3 http://stream.104.6rtl.com/rtl-live -t wav --input-buffer 80000 -r 22050 -c 1 - | sudo /home/pi/installs/pifm - 104.6

```
Lo script ha bisogno dei seguenti diritti:
{{< terminal >}}
sudo chmod 775 /home/pi/radio-streamer.sh

{{</ terminal >}}

## Possibile crontjob
Il computer viene riavviato ogni notte tra le 4 e le 5. Inoltre, il Radion si riconnette ogni ora.
```
@reboot sleep 60 && sudo /home/pi/radio-streamer.sh 
36 4 * * * sudo pkill sox 
37 4 * * * sudo pkill pifm 
38 4 * * * sudo reboot 
59 * * * * sudo /home/pi/radio-streamer.sh

```