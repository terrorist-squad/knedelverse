+++
date = "2019-07-17"
title = "PIFM: 104,6 Mundialmente na Rádio FM"
difficulty = "level-1"
tags = ["104.6rtl", "fm-streaming", "pi", "radio", "raspberry-pi"]
githublink = "https://github.com/ChristianKnedel/knedelverse/blob/main/content/post/2019/july/20190717-rpi-pifm/index.pt.md"
+++
Se você é um fã de 104,6 RTL e não quer passar um dia sem o rádio de Berlim, então você está no lugar certo. Você precisa de um computador de placa única chamado Raspberry e um cabo na porta GPIO 4 como antena.
## São necessários os seguintes pacotes

{{< terminal >}}
sudo apt-get update
sudo apt-get upgrade
sudo apt-get install sox libsox-fmt-all

{{</ terminal >}}
Eu crio uma pasta de download e faço o download do script PIFM:
{{< terminal >}}
mkdir /home/pi/installs
cd /home/pi/installs/
wget http://omattos.com/pifm.tar.gz
tar vfzx pifm.tar.gz

{{</ terminal >}}

## script pifm
Eu crio um novo arquivo "$vim /home/pi/radio-streamer.sh" com o seguinte conteúdo:
```
#!/bin/bash 
pkill sox 
pkill pifm 
sleep 1 

sox -v .9 -t mp3 http://stream.104.6rtl.com/rtl-live -t wav --input-buffer 80000 -r 22050 -c 1 - | sudo /home/pi/installs/pifm - 104.6

```
O roteiro precisa dos seguintes direitos:
{{< terminal >}}
sudo chmod 775 /home/pi/radio-streamer.sh

{{</ terminal >}}

## Possível crontjob
